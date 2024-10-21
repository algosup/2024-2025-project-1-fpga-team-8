module frogger_top(
    input wire i_Clk,                 
    input wire i_Switch_1,            
    input wire i_Switch_2,            
    input wire i_Switch_3,
    input wire i_Switch_4,
    output reg [6:0] o_Segment1,
    output reg [6:0] o_Segment2,

    
    output wire o_VGA_HSync,          
    output wire o_VGA_VSync,          
    output wire o_VGA_Red_0,           
    output wire o_VGA_Red_1,           
    output wire o_VGA_Red_2,           
    output wire o_VGA_Grn_0,           
    output wire o_VGA_Grn_1,           
    output wire o_VGA_Grn_2,           
    output wire o_VGA_Blu_0,           
    output wire o_VGA_Blu_1,           
    output wire o_VGA_Blu_2,           

    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4
);

    
    parameter c_VIDEO_WIDTH = 3;
    parameter c_TOTAL_COLS  = 800;
    parameter c_TOTAL_ROWS  = 525;
    parameter c_ACTIVE_COLS = 640;
    parameter c_ACTIVE_ROWS = 480;

    
    wire [c_VIDEO_WIDTH-1:0] w_Red_Video_Frogger, w_Red_Video_Porch;
    wire [c_VIDEO_WIDTH-1:0] w_Grn_Video_Frogger, w_Grn_Video_Porch;
    wire [c_VIDEO_WIDTH-1:0] w_Blu_Video_Frogger, w_Blu_Video_Porch;

    wire w_LED_1, w_LED_2, w_LED_3, w_LED_4;

    wire w_HSync_VGA, w_VSync_VGA;
    wire w_HSync_Frogger, w_VSync_Frogger;

    
    wire [3:0] w_Switches = {i_Switch_4, i_Switch_3, i_Switch_2, i_Switch_1}; 
    wire [3:0] w_Debounced_Switches;  

    
    multi_button_debouncer multi_button_debouncer_inst (
        .i_Clk(i_Clk),
        .i_Buttons(w_Switches),
        .o_Debounced(w_Debounced_Switches)
    );

    
    wire w_Debounced_1 = w_Debounced_Switches[0];
    wire w_Debounced_2 = w_Debounced_Switches[1];
    wire w_Debounced_3 = w_Debounced_Switches[2];
    wire w_Debounced_4 = w_Debounced_Switches[3];

    
    VGA_sync_pulses #(
        .TOTAL_COLS(c_TOTAL_COLS),
        .TOTAL_ROWS(c_TOTAL_ROWS),
        .ACTIVE_COLS(c_ACTIVE_COLS),
        .ACTIVE_ROWS(c_ACTIVE_ROWS)
    ) VGA_sync_pulses_Inst (
        .i_Clk(i_Clk),
        .o_HSync(w_HSync_Frogger),
        .o_VSync(w_VSync_Frogger),
        .o_Col_Count(),
        .o_Row_Count()
    );

    
    frogger_game frogger_game_inst (
        .i_Clk(i_Clk),
        .i_HSync(w_HSync_Frogger),
        .i_VSync(w_VSync_Frogger),
        .i_Game_Start(w_Debounced_1 & w_Debounced_2 & w_Debounced_3 & w_Debounced_4),
        .i_Up_Mvt(w_Debounced_1),
        .i_Down_Mvt(w_Debounced_2),
        .i_Left_Mvt(w_Debounced_3),
        .i_Right_Mvt(w_Debounced_4),
        .o_HSync(w_HSync_VGA),
        .o_VSync(w_VSync_VGA),
        .o_Red_Video(w_Red_Video_Frogger),
        .o_Grn_Video(w_Grn_Video_Frogger),
        .o_Blu_Video(w_Blu_Video_Frogger),
        .o_Segment1(o_Segment1),
        .o_Segment2(o_Segment2),
        .o_LED_2(w_LED_2),
        .o_LED_3(w_LED_3),
        .o_LED_4(w_LED_4)
    );

    
    VGA_sync_porch #(
        .VIDEO_WIDTH(c_VIDEO_WIDTH),
        .TOTAL_COLS(c_TOTAL_COLS),
        .TOTAL_ROWS(c_TOTAL_ROWS),
        .ACTIVE_COLS(c_ACTIVE_COLS),
        .ACTIVE_ROWS(c_ACTIVE_ROWS)
    ) VGA_sync_porch_Inst (
        .i_Clk(i_Clk),
        .i_HSync(w_HSync_Frogger),
        .i_VSync(w_VSync_Frogger),
        .i_Red_Video(w_Red_Video_Frogger),
        .i_Grn_Video(w_Grn_Video_Frogger),
        .i_Blu_Video(w_Blu_Video_Frogger),
        .o_HSync(o_VGA_HSync),
        .o_VSync(o_VGA_VSync),
        .o_Red_Video(w_Red_Video_Porch),
        .o_Grn_Video(w_Grn_Video_Porch),
        .o_Blu_Video(w_Blu_Video_Porch)
    );

    assign o_VGA_Red_0 = w_Red_Video_Porch[0];
    assign o_VGA_Red_1 = w_Red_Video_Porch[1];
    assign o_VGA_Red_2 = w_Red_Video_Porch[2];

    assign o_VGA_Grn_0 = w_Grn_Video_Porch[0];
    assign o_VGA_Grn_1 = w_Grn_Video_Porch[1];
    assign o_VGA_Grn_2 = w_Grn_Video_Porch[2];

    assign o_VGA_Blu_0 = w_Blu_Video_Porch[0];
    assign o_VGA_Blu_1 = w_Blu_Video_Porch[1];
    assign o_VGA_Blu_2 = w_Blu_Video_Porch[2];

  assign o_LED_2 = w_LED_2;
  assign o_LED_3 = w_LED_3;
  assign o_LED_4 = w_LED_4;

endmodule
