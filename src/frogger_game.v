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
   // Player 1 and Player 2 Controls (Controls Paddles)
   input            i_Up_Mvt,
   input            i_Down_Mvt,
   input            i_Left_Mvt,
   input            i_Right_Mvt,
   // Output Video
   output reg       o_HSync,
   output reg       o_VSync,
   output [3:0] o_Red_Video,
   output [3:0] o_Grn_Video,
   output [3:0] o_Blu_Video,
   output [6:0] o_Segment1,
   output [6:0] o_Segment2,
);

  parameter c_TOTAL_COLS = 800;
  parameter c_TOTAL_ROWS = 525;

  // Local Constants to Determine Game Play
  parameter c_GAME_WIDTH  = 20;
  parameter c_GAME_HEIGHT = 15;
  parameter c_SCORE_LIMIT = 99;
  parameter TILE_BORDER = 32;

  // State machine enumerations
  parameter IDLE    = 3'b000;
  parameter RUNNING = 3'b001;
  parameter P1_WINS = 3'b010;
  parameter P2_WINS = 3'b011;
  parameter CLEANUP = 3'b100;


  wire w_Game_Active = 1'b1;
  wire w_Draw_Any, w_Draw_Frogger, w_Draw_Car_1, w_Draw_Car_2;

  wire       w_HSync, w_VSync;
  wire [9:0] w_Col_Count, w_Row_Count;

    // Divided version of the Row/Col Counters
  // Allows us to make the board 40x30
  wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
  wire [5:0] w_Frogger_X, w_Frogger_Y;

  // Cars
  wire [5:0] w_Car_X_1, w_Car_Y_1;
  wire [5:0] w_Car_X_2, w_Car_Y_2;

  // Drop 5 LSBs, which effectively divides by 32
  assign w_Col_Count_Div = w_Col_Count[9:5];
  assign w_Row_Count_Div = w_Row_Count[9:5];

    reg [6:0] counter = 0;

    Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS),
                  .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
    (.i_Clk(i_Clk),
     .i_HSync(i_HSync),
     .i_VSync(i_VSync),
     .o_HSync(w_HSync),
     .o_VSync(w_VSync),
     .o_Col_Count(w_Col_Count),
     .o_Row_Count(w_Row_Count));

// Register syncs to align with output data.
always @(posedge i_Clk) begin
    o_HSync <= w_HSync;
    o_VSync <= w_VSync;
  end
    // Control the score display

    score_control score_control_inst (
        .i_Clk(i_Clk),
        .i_Score(counter),
        .o_Segment1(o_Segment1),
        .o_Segment2(o_Segment2)
    );

    // Control frogger
    frogger_ctrl frogger_ctrl_inst (
        .i_Clk(i_Clk),
        .i_Score(counter),
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
        // .o_Score(counter)
    );

    // Control car
    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(20),
      .c_SLOW_COUNT(4000000),
      .c_INIT_X(0),
      .c_INIT_Y(13)
    )
      
      car_ctrl_inst_1 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Draw_Car(w_Draw_Car),
        .o_Car_X(w_Car_X),
        .o_Car_Y(w_Car_Y),

    );

    // Control car
    car_ctrl #(
      .c_CAR_SPEED(1),
      .c_MAX_X(20),
      .c_SLOW_COUNT(5000000),
      .c_INIT_X(0),
      .c_INIT_Y(11)
    )

      car_ctrl_inst_2 (
        .i_Clk(i_Clk),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .o_Draw_Car(w_Draw_Car_2),
        .o_Car_X(w_Car_X_2),
        .o_Car_Y(w_Car_Y_2),
    );

  // Conditional Assignment based on State Machine state
//   assign w_Game_Active = (r_SM_Main == RUNNING) ? 1'b1 : 1'b0;

  // Draw any 
  assign w_Draw_Any = w_Draw_Frogger || w_Draw_Car || w_Draw_Car_2;

  // Assign colors. Currently set to only 2 colors, white or black.
  assign o_Red_Video = w_Draw_Any ? 4'b1111 : 4'b0000;
  assign o_Grn_Video = w_Draw_Any ? 4'b1111 : 4'b0000;
  assign o_Blu_Video = w_Draw_Any ? 4'b1111 : 4'b0000;

endmodule