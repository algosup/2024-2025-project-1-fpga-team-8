module frogger_game
#(
    parameter c_TOTAL_COLS=800,
    parameter c_TOTAL_ROWS=525,
    parameter c_ACTIVE_COLS=640,
    parameter c_ACTIVE_ROWS=480
)(
   input            i_Clk,
   input            i_HSync,
   input            i_VSync,
   // Game Start Button   
   input            i_Game_Start,
   // Player 1 and Player 2 Controls (Controls Frogger)
   input            i_Up_Mvt,
   input            i_Down_Mvt,
   input            i_Left_Mvt,
   input            i_Right_Mvt,
   // Output Video
   output reg       o_HSync,
   output reg       o_VSync,
   output [3:0]     o_Red_Video,
   output [3:0]     o_Grn_Video,
   output [3:0]     o_Blu_Video,
   output [6:0]     o_Segment1,
   output [6:0]     o_Segment2
);

  // Game constants
  parameter c_GAME_WIDTH  = 14;   // 14 columns in the bitmap
  parameter c_GAME_HEIGHT = 13;   // 13 rows in the bitmap
  parameter TILE_SIZE     = 32;   // Each tile is 32x32 pixels
  parameter c_SCORE_LIMIT = 99;
  
  // Bitmap array: 0=wall, 1=road, 2=water, 3=safe area, 4=lily pad
  reg [3:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];

  // Signals
  wire [9:0] w_Col_Count, w_Row_Count;
  wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
  wire [5:0] w_Frogger_X, w_Frogger_Y;
  wire w_Draw_Frogger, w_Game_Active;

  // Score variable
  reg [6:0] r_Frogger_Score;

  // Synchronize to row and column counters
  Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS),
                  .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
  (
    .i_Clk(i_Clk),
    .i_HSync(i_HSync),
    .i_VSync(i_VSync),
    .o_HSync(o_HSync),
    .o_VSync(o_VSync),
    .o_Col_Count(w_Col_Count),
    .o_Row_Count(w_Row_Count)
  );

  // Convert current column and row into tile coordinates
  assign w_Col_Count_Div = w_Col_Count[9:5]; // Divide by TILE_SIZE (32)
  assign w_Row_Count_Div = w_Row_Count[9:5];

  // Initialize bitmap background
  integer row, col;  // Declare loop index variables outside of the loops
  initial begin
    // Row 0: Lily pads
    r_Bitmap[0][0] = 0; r_Bitmap[0][1] = 4; r_Bitmap[0][2] = 0; r_Bitmap[0][3] = 0;
    r_Bitmap[0][4] = 4; r_Bitmap[0][5] = 0; r_Bitmap[0][6] = 0; r_Bitmap[0][7] = 4;
    r_Bitmap[0][8] = 0; r_Bitmap[0][9] = 0; r_Bitmap[0][10] = 4; r_Bitmap[0][11] = 0;
    r_Bitmap[0][12] = 0; r_Bitmap[0][13] = 4;

    // Rows 1-5: Water
    for (row = 1; row < 6; row = row + 1) begin
      for (col = 0; col < c_GAME_WIDTH; col = col + 1) begin
        r_Bitmap[row][col] = 2;
      end
    end

    // Row 6: Safe Area (Grass)
    for (col = 0; col < c_GAME_WIDTH; col = col + 1) begin
      r_Bitmap[6][col] = 3;
    end

    // Rows 7-11: Road
    for (row = 7; row < 12; row = row + 1) begin
      for (col = 0; col < c_GAME_WIDTH; col = col + 1) begin
        r_Bitmap[row][col] = 1;
      end
    end

    // Row 12: Safe Area (Grass)
    for (col = 0; col < c_GAME_WIDTH; col = col + 1) begin
      r_Bitmap[12][col] = 3;
    end
  end

  // Control Frogger's movements and track its position
  frogger_ctrl frogger_ctrl_inst (
    .i_Clk(i_Clk),
    .i_Score(r_Frogger_Score),
    .i_Up_Mvt(i_Up_Mvt),
    .i_Down_Mvt(i_Down_Mvt),
    .i_Left_Mvt(i_Left_Mvt),
    .i_Right_Mvt(i_Right_Mvt),
    .i_Game_Active(w_Game_Active),
    .i_Col_Count_Div(w_Col_Count_Div),
    .i_Row_Count_Div(w_Row_Count_Div),
    .o_Draw_Frogger(w_Draw_Frogger),
    .o_Frogger_X(w_Frogger_X),
    .o_Frogger_Y(w_Frogger_Y),
    .o_Score(r_Frogger_Score)
  );

  // Determine background colors based on the bitmap and draw Frogger if applicable
  reg [3:0] r_Red_Video, r_Grn_Video, r_Blu_Video;
  always @(*) begin
    // Check if the current tile matches Frogger's position
    if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y)) begin
      // If in the same tile as Frogger, draw Frogger in white
      r_Red_Video = 4'b1111; // White
      r_Grn_Video = 4'b1111;
      r_Blu_Video = 4'b1111;
    end else if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT) begin
      // Otherwise, draw the background based on the bitmap
      case (r_Bitmap[w_Row_Count_Div][w_Col_Count_Div])
      4'd0: begin
        r_Red_Video = 4'b0001;  // Wall: Red Channel = 0
        r_Grn_Video = 4'b1110;  // Wall: Green Channel = 14
        r_Blu_Video = 4'b0000;  // Wall: Blue Channel = 0
      end
      4'd1: begin
        r_Red_Video = 4'b0000;  // Road: Red Channel = 0
        r_Grn_Video = 4'b0000;  // Road: Green Channel = 0
        r_Blu_Video = 4'b0000;  // Road: Blue Channel = 0
      end
      4'd2: begin
        r_Red_Video = 4'b0001;  // Water: Red Channel = 1
        r_Grn_Video = 4'b0000;  // Water: Green Channel = 0
        r_Blu_Video = 4'b1110;  // Water: Blue Channel = 14
      end
      4'd3: begin
        // Safe Area: Check if it's the top or bottom line of the tile
        if ((w_Row_Count % TILE_SIZE == 0) || (w_Row_Count % TILE_SIZE == TILE_SIZE - 1)) begin
          // Top or bottom line of the tile
          r_Red_Video = 4'b0000;  // Black line
          r_Grn_Video = 4'b0000;
          r_Blu_Video = 4'b0000;
        end else begin
          // Normal safe area color
          r_Red_Video = 4'b0011;  // Safe Area: Red Channel = 3
          r_Grn_Video = 4'b0000;  // Safe Area: Green Channel = 0
          r_Blu_Video = 4'b1111;  // Safe Area: Blue Channel = 15
        end
      end
      4'd4: begin
        r_Red_Video = 4'b0001;  // Lily Pad: Red Channel = 1
        r_Grn_Video = 4'b0000;  // Lily Pad: Green Channel = 0
        r_Blu_Video = 4'b1110;  // Lily Pad: Blue Channel = 14
      end
      default: begin
        r_Red_Video = 4'b0000;  // Background: Red Channel = 0
        r_Grn_Video = 4'b0000;  // Background: Green Channel = 0
        r_Blu_Video = 4'b0000;  // Background: Blue Channel = 0
      end
    endcase
    end else begin
      r_Red_Video = 4'b0000;
      r_Grn_Video = 4'b0000;
      r_Blu_Video = 4'b0000;
    end
  end

  // Assign video outputs
  assign o_Red_Video = r_Red_Video;
  assign o_Grn_Video = r_Grn_Video;
  assign o_Blu_Video = r_Blu_Video;

  // Display Score on 7-segment displays
  score_control score_control_inst (
    .i_Clk(i_Clk),
    .i_Score(r_Frogger_Score),
    .o_Segment1(o_Segment1),
    .o_Segment2(o_Segment2)
  );

endmodule
