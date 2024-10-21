module frogger_game #(
    
    parameter c_TOTAL_COLS=800,
    parameter c_TOTAL_ROWS=525,
    parameter c_ACTIVE_COLS=640,
    parameter c_ACTIVE_ROWS=480
)(
    input            i_Clk,
    input            i_HSync,
    input            i_VSync,
    input            i_Game_Start,
    input            i_Up_Mvt,
    input            i_Down_Mvt,
    input            i_Left_Mvt,
    input            i_Right_Mvt,
    
    output reg       o_HSync,
    output reg       o_VSync,
    output [3:0]     o_Red_Video,
    output [3:0]     o_Grn_Video,
    output [3:0]     o_Blu_Video,
    
    output o_LED_1,
    output [6:0]     o_Segment1,
    output [6:0]     o_Segment2
);

    parameter c_GAME_WIDTH = 20;
    parameter c_GAME_HEIGHT = 15;
    parameter TILE_SIZE     = 32;
    parameter NUM_CARS      = 10;

    reg [2:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];
    reg [8:0] game_state;

    
    wire w_Game_Active = 1'b1;
    wire       w_HSync, w_VSync;
    wire [9:0] w_Col_Count, w_Row_Count;
    wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
    wire [5:0] w_Frogger_X, w_Frogger_Y;
    wire w_Collided;

    reg [4:0] o_Car_X [0:NUM_CARS-1];  
    reg [4:0] o_Car_Y [0:NUM_CARS-1];  

    wire [4:0] car_x_0, car_x_1, car_x_2, car_x_3, car_x_4, car_x_5, car_x_6, car_x_7, car_x_8, car_x_9;

    assign w_Col_Count_Div = w_Col_Count[9:5];
    assign w_Row_Count_Div = w_Row_Count[9:5];
    
    sync_to_count #(
        .TOTAL_COLS(c_TOTAL_COLS),
        .TOTAL_ROWS(c_TOTAL_ROWS)
    ) sync_to_count_Inst (
        .i_Clk(i_Clk),
        .i_HSync(i_HSync),
        .i_VSync(i_VSync),
        .o_HSync(o_HSync),
        .o_VSync(o_VSync),
        .o_Col_Count(w_Col_Count),
        .o_Row_Count(w_Row_Count)
    );

    integer row, col;
    initial begin
        $readmemh("bitmap_init.mem", r_Bitmap);
    end

    wire slow_clk;

    clock_divider #(
        .DIV_FACTOR(23'd2500000)  
    ) clock_divider_inst (
        .i_Clk(i_Clk),
        .o_Divided_Clk(slow_clk)
    );

    wire [2:0] w_Bitmap_Data;
    assign w_Bitmap_Data = (w_Frogger_Y < c_GAME_HEIGHT && w_Frogger_X < c_GAME_WIDTH) ? 
        r_Bitmap[w_Frogger_Y][w_Frogger_X] : 3'd0;

    
    frogger_ctrl frogger_ctrl_inst (
        .i_Clk(i_Clk),
        .i_Score(game_state[8:2]),
        .i_Up_Mvt(i_Up_Mvt),
        .i_Down_Mvt(i_Down_Mvt),
        .i_Left_Mvt(i_Left_Mvt),
        .i_Right_Mvt(i_Right_Mvt),
        .i_Collided(w_Collided),
        .i_Col_Count_Div(w_Col_Count_Div),
        .i_Row_Count_Div(w_Row_Count_Div),
        .i_Bitmap_Data(w_Bitmap_Data),
        .o_Frogger_X(w_Frogger_X),
        .o_Frogger_Y(w_Frogger_Y),
        .o_Score(game_state[8:2])
    );

    
    car #(.CAR_INIT_X(0), .BASE_SPEED(24'd9000), .CAR_DIRECTION(1)) car_0 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_0));
    car #(.CAR_INIT_X(19), .BASE_SPEED(24'd9000), .CAR_DIRECTION(0)) car_1 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_1));
    car #(.CAR_INIT_X(6), .BASE_SPEED(24'd9000), .CAR_DIRECTION(1)) car_2 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_2));
    car #(.CAR_INIT_X(20), .BASE_SPEED(24'd9000), .CAR_DIRECTION(0)) car_3 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_3));
    car #(.CAR_INIT_X(3), .BASE_SPEED(24'd10003), .CAR_DIRECTION(1)) car_4 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_4));
    car #(.CAR_INIT_X(4), .BASE_SPEED(24'd10003), .CAR_DIRECTION(0)) car_5 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_5));
    car #(.CAR_INIT_X(9), .BASE_SPEED(24'd10003), .CAR_DIRECTION(1)) car_6 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_6));
    car #(.CAR_INIT_X(18), .BASE_SPEED(24'd10003), .CAR_DIRECTION(0)) car_7 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_7));
    car #(.CAR_INIT_X(4), .BASE_SPEED(24'd10003), .CAR_DIRECTION(1)) car_8 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_8));
    car #(.CAR_INIT_X(11), .BASE_SPEED(24'd10003), .CAR_DIRECTION(1)) car_9 (.i_Clk(slow_clk),.level(game_state[8:2]),.o_car_x(car_x_9));

   
    always @(posedge i_Clk) begin
        o_Car_X[0] <= car_x_0;
        o_Car_X[1] <= car_x_1;
        o_Car_X[2] <= car_x_2;
        o_Car_X[3] <= car_x_3;
        o_Car_X[4] <= car_x_4;
        o_Car_X[5] <= car_x_5;
        o_Car_X[6] <= car_x_6;
        o_Car_X[7] <= car_x_7;
        o_Car_X[8] <= car_x_8;
        o_Car_X[9] <= car_x_9;

        
        o_Car_Y[0] <= 5'd12;
        o_Car_Y[1] <= 5'd11;
        o_Car_Y[2] <= 5'd12;
        o_Car_Y[3] <= 5'd11;
        o_Car_Y[4] <= 5'd10;
        o_Car_Y[5] <= 5'd9;
        o_Car_Y[6] <= 5'd10;
        o_Car_Y[7] <= 5'd9;
        o_Car_Y[8] <= 5'd8;
        o_Car_Y[9] <= 5'd8;
    end

    
    integer i;
    always @(posedge i_Clk) begin
        w_Collided = 1'b0;
        for (i = 0; i < NUM_CARS; i = i + 1) begin
            if (w_Frogger_X == o_Car_X[i] && w_Frogger_Y == o_Car_Y[i]) begin
                w_Collided = 1'b1;
            end
        end
    end

    reg [2:0] r_Red_Video, r_Grn_Video, r_Blu_Video;

    always @(*) begin
        
        r_Red_Video = 3'b000;
        r_Grn_Video = 3'b000;
        r_Blu_Video = 3'b000;

        
        if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y)) begin
            
            r_Red_Video = 3'b111;  
            r_Grn_Video = 3'b000;  
            r_Blu_Video = 3'b000;  
        end else begin
            
            if ((w_Col_Count_Div == car_x_0 && w_Row_Count_Div == 6'd12) ||
                (w_Col_Count_Div == car_x_1 && w_Row_Count_Div == 6'd11) ||
                (w_Col_Count_Div == car_x_2 && w_Row_Count_Div == 6'd12) ||
                (w_Col_Count_Div == car_x_3 && w_Row_Count_Div == 6'd11) ||
                (w_Col_Count_Div == car_x_4 && w_Row_Count_Div == 6'd10) ||
                (w_Col_Count_Div == car_x_5 && w_Row_Count_Div == 6'd9) ||
                (w_Col_Count_Div == car_x_6 && w_Row_Count_Div == 6'd10) ||
                (w_Col_Count_Div == car_x_7 && w_Row_Count_Div == 6'd9) ||
                (w_Col_Count_Div == car_x_8 && w_Row_Count_Div == 6'd8) ||
                (w_Col_Count_Div == car_x_9 && w_Row_Count_Div == 6'd8)) begin
                
                r_Red_Video = 3'b111;  
                r_Grn_Video = 3'b111;  
                r_Blu_Video = 3'b111;  
            end
        end

        
        if (r_Red_Video == 3'b000 && r_Grn_Video == 3'b000 && r_Blu_Video == 3'b000) begin
            if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT) begin
                case (r_Bitmap[w_Row_Count_Div][w_Col_Count_Div])
                    3'd0: begin  
                        r_Red_Video = 3'b001;
                        r_Grn_Video = 3'b110;
                        r_Blu_Video = 3'b000;
                    end
                    3'd1: begin  
                        r_Red_Video = 3'b000;
                        r_Grn_Video = 3'b000;
                        r_Blu_Video = 3'b000;
                    end
                    3'd2: begin  
                        r_Red_Video = 3'b001;
                        r_Grn_Video = 3'b000;
                        r_Blu_Video = 3'b110;
                    end
                    3'd3: begin  
                        if ((w_Row_Count % TILE_SIZE == 0) || (w_Row_Count % TILE_SIZE == TILE_SIZE - 1)) begin
                            r_Red_Video = 3'b000;  
                            r_Grn_Video = 3'b000;
                            r_Blu_Video = 3'b000;
                        end else begin
                            r_Red_Video = 3'b011;  
                            r_Grn_Video = 3'b000;
                            r_Blu_Video = 3'b111;
                        end
                    end
                    3'd4: begin  
                        r_Red_Video = 3'b001;
                        r_Grn_Video = 3'b000;
                        r_Blu_Video = 3'b110;
                    end
                    default: begin  
                        r_Red_Video = 3'b000;
                        r_Grn_Video = 3'b000;
                        r_Blu_Video = 3'b000;
                    end
                endcase
            end
        end
    end

    assign o_Red_Video = r_Red_Video;
    assign o_Grn_Video = r_Grn_Video;
    assign o_Blu_Video = r_Blu_Video;

    
    score_control score_control_inst (
        .i_Clk(i_Clk),
        .i_Score(game_state[8:2]),
        .o_Segment1(o_Segment1),
        .o_Segment2(o_Segment2)
    );

endmodule
