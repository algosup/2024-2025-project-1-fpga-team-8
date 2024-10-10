module frogger_game
#(
    parameter c_TOTAL_COLS  = 800,
    parameter c_TOTAL_ROWS  = 525,
    parameter c_ACTIVE_COLS = 640,
    parameter c_ACTIVE_ROWS = 480
)
(
    input            i_Clk,
    input            i_HSync,
    input            i_VSync,
    
    // Game Control Inputs
    input            i_Game_Start, // Game Start Signal
    input            i_Up_Mvt,     // Up Movement Signal
    input            i_Down_Mvt,   // Down Movement Signal
    input            i_Left_Mvt,   // Left Movement Signal
    input            i_Right_Mvt,  // Right Movement Signal

    // VGA Output Signals
    output reg       o_HSync,
    output reg       o_VSync,
    output [3:0]     o_Red_Video,
    output [3:0]     o_Grn_Video,
    output [3:0]     o_Blu_Video,

    // 7-Segment Display Outputs
    output [6:0]     o_Segment1,
    output [6:0]     o_Segment2,

    // LED Outputs
    output           o_LED_2,
    output           o_LED_3,
    output           o_LED_4
);

  // ============================================================================
  // Parameter Declarations
  // ============================================================================
  parameter c_GAME_WIDTH  = 14;   // Number of columns in the bitmap
  parameter c_GAME_HEIGHT = 13;   // Number of rows in the bitmap
  parameter TILE_SIZE     = 32;   // Each tile is 32x32 pixels

  // State Machine States
  parameter IDLE    = 2'b00;
  parameter PLAY    = 2'b01;
  parameter CLEANUP = 2'b10;

  // ============================================================================
  // Internal Signals and Registers
  // ============================================================================
  reg [3:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1]; // Bitmap Array
  reg [1:0] r_SM_Main = IDLE;                             // State Machine Register
  reg [6:0] r_Frogger_Score;                              // Frogger Score Register
  reg       r_Game_Start;                                 // Game Start Signal Register
  reg [1:0] r_Lives;                                     // Lives Counter

  wire [3:0] w_Bitmap_Data;                               // Bitmap Data
  wire [9:0] w_Col_Count, w_Row_Count;                    // Column and Row Counters
  wire [4:0] w_Col_Count_Div, w_Row_Count_Div;            // Divided Counters for Tile Size
  wire [5:0] w_Frogger_X, w_Frogger_Y;                    // Frogger Position Coordinates
  wire [5:0] w_Car_X_1, w_Car_Y_1;                        // Car 1 Position Coordinates
  wire [5:0] w_Car_X_2, w_Car_Y_2;                        // Car 2 Position Coordinates
  wire [5:0] w_Car_X_3, w_Car_Y_3;                        // Car 3 Position Coordinates
  wire [5:0] w_Car_X_4, w_Car_Y_4;                        // Car 4 Position Coordinates
  wire [5:0] w_Car_X_5, w_Car_Y_5;                        // Car 5 Position Coordinates
  wire       w_Game_Active;                               // Game Active Signal
  wire       w_Collided;                                  // Collision Detection Signal

  // ============================================================================
  // State Machine Control
  // ============================================================================
  assign w_Game_Active = (r_SM_Main == PLAY) ? 1'b1 : 1'b0;

  always @(posedge i_Clk) begin
    case (r_SM_Main)
      IDLE: begin
        if (i_Game_Start) r_SM_Main <= PLAY;
      end

      PLAY: begin
        if (r_Lives == 0) begin
          r_SM_Main <= CLEANUP;
        end
      end

      CLEANUP: begin
        // Reset logic here
        r_SM_Main <= IDLE;
      end

      default: r_SM_Main <= IDLE;
    endcase
  end

  // ============================================================================
  // VGA Synchronization and Tile Position Calculation
  // ============================================================================
  Sync_To_Count #(
    .TOTAL_COLS(c_TOTAL_COLS),
    .TOTAL_ROWS(c_TOTAL_ROWS)
  ) Sync_To_Count_Inst (
    .i_Clk(i_Clk),
    .i_HSync(i_HSync),
    .i_VSync(i_VSync),
    .o_HSync(o_HSync),
    .o_VSync(o_VSync),
    .o_Col_Count(w_Col_Count),
    .o_Row_Count(w_Row_Count)
  );

  // Convert current column and row into tile coordinates (Dividing by TILE_SIZE)
  assign w_Col_Count_Div = w_Col_Count[9:5];
  assign w_Row_Count_Div = w_Row_Count[9:5];

  // ============================================================================
  // Bitmap Initialization
  // ============================================================================
  integer row, col; // Loop indices for initialization
  initial begin
    $readmemh("bitmap_init.mem", r_Bitmap); // Load the bitmap data from a file
  end

  // Assign bitmap data corresponding to Frogger's position
  assign w_Bitmap_Data = (w_Frogger_Y < c_GAME_HEIGHT && w_Frogger_X < c_GAME_WIDTH) ? 
                         r_Bitmap[w_Frogger_Y][w_Frogger_X] : 4'd0;

  // ============================================================================
  // Module Instantiations (Frogger Control, Car Control, Collision Detection)
  // ============================================================================
  frogger_ctrl frogger_ctrl_inst (
    .i_Clk(i_Clk),
    .i_Score(r_Frogger_Score),
    .i_Up_Mvt(i_Up_Mvt),
    .i_Down_Mvt(i_Down_Mvt),
    .i_Left_Mvt(i_Left_Mvt),
    .i_Right_Mvt(i_Right_Mvt),
    .i_Collided(w_Collided),
    .i_Col_Count_Div(w_Col_Count_Div),
    .i_Row_Count_Div(w_Row_Count_Div),
    .i_Bitmap_Data(w_Bitmap_Data),  // Bitmap data for Frogger's current tile
    .o_Frogger_X(w_Frogger_X),
    .o_Frogger_Y(w_Frogger_Y),
    .o_Score(r_Frogger_Score)
  );

  // Lives Counter instance
  lives_counter lives_counter_inst (
    .i_Clk(i_Clk),
    .i_Collided(w_Collided),
    .o_LED_2(o_LED_2),
    .o_LED_3(o_LED_3),
    .o_LED_4(o_LED_4),
    .o_Lives(r_Lives)
  );

    // Car 1 instance
    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(14),
      .c_SLOW_COUNT(4000000),
      .c_INIT_X(0),
      .c_INIT_Y(11)
    )
      
      car_ctrl_inst_1 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Car_X(w_Car_X_1),
        .o_Car_Y(w_Car_Y_1),
    );

    // Car 2 instance
    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(14),
      .c_SLOW_COUNT(5000000),
      .c_INIT_X(0),
      .c_INIT_Y(10)
    )

      car_ctrl_inst_2 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Car_X(w_Car_X_2),
        .o_Car_Y(w_Car_Y_2),
    );

    // Car 3 instance
    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(14),
      .c_SLOW_COUNT(3700000),
      .c_INIT_X(0),
      .c_INIT_Y(9)
    )

      car_ctrl_inst_3 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Car_X(w_Car_X_3),
        .o_Car_Y(w_Car_Y_3),
    );

    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(14),
      .c_SLOW_COUNT(4500000),
      .c_INIT_X(0),
      .c_INIT_Y(8)
    )

      car_ctrl_inst_4 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Car_X(w_Car_X_4),
        .o_Car_Y(w_Car_Y_4),
    );

    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(14),
      .c_SLOW_COUNT(4200000),
      .c_INIT_X(0),
      .c_INIT_Y(7)
    )

      car_ctrl_inst_5 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Car_X(w_Car_X_5),
        .o_Car_Y(w_Car_Y_5),
    );

  car_collisions car_collisions_inst (
    .i_Clk(i_Clk),
    .i_Frogger_X(w_Frogger_X),
    .i_Frogger_Y(w_Frogger_Y),
    .i_Car_X_1(w_Car_X_1),
    .i_Car_Y_1(w_Car_Y_1),
    .i_Car_X_2(w_Car_X_2),
    .i_Car_Y_2(w_Car_Y_2),
    .i_Car_X_3(w_Car_X_3),
    .i_Car_Y_3(w_Car_Y_3),
    .i_Car_X_4(w_Car_X_4),
    .i_Car_Y_4(w_Car_Y_4),
    .i_Car_X_5(w_Car_X_5),
    .i_Car_Y_5(w_Car_Y_5),
    .o_Collided(w_Collided)
  );

  // ============================================================================
  // Score Display and LED Control
  // ============================================================================
  score_control score_control_inst (
    .i_Clk(i_Clk),
    .i_Score(r_Frogger_Score),
    .o_Segment1(o_Segment1),
    .o_Segment2(o_Segment2)
  );

  // Determine background colors based on the bitmap and draw Frogger if applicable
  reg [3:0] r_Red_Video, r_Grn_Video, r_Blu_Video;
  always @(*) begin
    // Check if the current tile matches Frogger's position
    if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y) || 
    (w_Col_Count_Div == w_Car_X_1) && (w_Row_Count_Div == w_Car_Y_1) || 
    (w_Col_Count_Div == w_Car_X_2) && (w_Row_Count_Div == w_Car_Y_2) || 
    (w_Col_Count_Div == w_Car_X_3) && (w_Row_Count_Div == w_Car_Y_3) || 
    (w_Col_Count_Div == w_Car_X_4) && (w_Row_Count_Div == w_Car_Y_4) || 
    (w_Col_Count_Div == w_Car_X_5) && (w_Row_Count_Div == w_Car_Y_5)) begin
      // If in the same tile as Frogger, draw Frogger in white
      r_Red_Video = 4'b1111; // White
      r_Grn_Video = 4'b1111;
      r_Blu_Video = 4'b1111;
    end
    else if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT) begin
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

endmodule
