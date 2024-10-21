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

    output o_LED_1, o_LED_2, o_LED_3, o_LED_4,
    
    output o_LED_1,
    output [6:0]     o_Segment1,
    output [6:0]     o_Segment2
);

    parameter c_GAME_WIDTH = 20;
    parameter c_GAME_HEIGHT = 15;
    parameter TILE_SIZE     = 32;
    parameter NUM_CARS      = 16;
    parameter SPRITE_SIZE = 32;

    reg [2:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];
    reg [3:0] frog_sprite [31:0][31:0];
	reg [3:0] car_sprite [31:0][31:0];
    reg [6:0] game_level;


	integer car_row = w_Row_Count % SPRITE_SIZE;
	integer car_col = w_Col_Count % SPRITE_SIZE;

	integer frog_row = w_Row_Count % SPRITE_SIZE;
	integer frog_col = w_Col_Count % SPRITE_SIZE;

    
    wire w_Game_Active = 1'b1;
    wire       w_HSync, w_VSync;
    wire [9:0] w_Col_Count, w_Row_Count;
    wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
    wire [5:0] w_Frogger_X, w_Frogger_Y;
    reg w_Collided;

    reg [4:0] o_Car_X [0:NUM_CARS-1];  
    reg [4:0] o_Car_Y [0:NUM_CARS-1];  

    wire [4:0] car_x_0, car_x_1, car_x_2, car_x_3, car_x_4, car_x_5, car_x_6, car_x_7, car_x_8, car_x_9, car_x_10, car_x_11, car_x_12, car_x_13, car_x_14, car_x_15;

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
        $readmemh("car.mem", car_sprite);
		$readmemh("frogger.mem", frog_sprite);
    end


    wire slow_clk;

    clock_divider #(
        .DIV_FACTOR(23'd2500000)  
    ) clock_divider_inst (
        .i_Clk(i_Clk),
        .o_Divided_Clk(slow_clk)
    );

    wire [3:0] w_Bitmap_Data;
    assign w_Bitmap_Data = (w_Frogger_Y < c_GAME_HEIGHT && w_Frogger_X < c_GAME_WIDTH) ? 
        r_Bitmap[w_Frogger_Y][w_Frogger_X] : 3'd0;



    wire[31:0] w_Car_Sprites;
    assign w_Car_Sprites = (w_Car_Y_1 < car_sprite_height && w_Car_X_1 < car_sprite_width) ?
			car_sprite[w_Car_Y_1][w_Car_X_1] : 4'd0;

    wire [15:0] w_Frog_Sprite;
	assign w_Frog_Sprite = (w_Frogger_Y < frog_sprite_height && w_Frogger_X < frog_sprite_width) ?
		frog_sprite[w_Frogger_Y][w_Frogger_X] : 4'd0;
    
    frogger_ctrl frogger_ctrl_inst (
        .i_Clk(i_Clk),
        .i_Score(game_level[6:0]),
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
        .o_Score(game_level[6:0])
    );

    
    car #(.CAR_INIT_X(0), .BASE_SPEED(25'd17000), .CAR_DIRECTION(1)) car_0 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_0));
    car #(.CAR_INIT_X(19), .BASE_SPEED(25'd8000), .CAR_DIRECTION(0)) car_1 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_1));
    car #(.CAR_INIT_X(7), .BASE_SPEED(25'd17000), .CAR_DIRECTION(1)) car_2 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_2));
    car #(.CAR_INIT_X(12), .BASE_SPEED(25'd8000), .CAR_DIRECTION(1)) car_3 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_3));
    car #(.CAR_INIT_X(3), .BASE_SPEED(25'd10003), .CAR_DIRECTION(1)) car_4 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_4));
    car #(.CAR_INIT_X(4), .BASE_SPEED(25'd70003), .CAR_DIRECTION(0)) car_5 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_5));
    car #(.CAR_INIT_X(9), .BASE_SPEED(25'd50003), .CAR_DIRECTION(1)) car_6 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_6));
    car #(.CAR_INIT_X(18), .BASE_SPEED(25'd70003), .CAR_DIRECTION(0)) car_7 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_7));
    car #(.CAR_INIT_X(4), .BASE_SPEED(25'd20003), .CAR_DIRECTION(1)) car_8 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_8));
    car #(.CAR_INIT_X(10), .BASE_SPEED(25'd20003), .CAR_DIRECTION(1)) car_9 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_9));
    car #(.CAR_INIT_X(4), .BASE_SPEED(25'd1003), .CAR_DIRECTION(0)) car_10 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_10));
    car #(.CAR_INIT_X(5), .BASE_SPEED(25'd9000), .CAR_DIRECTION(1)) car_11 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_11));
    car #(.CAR_INIT_X(6), .BASE_SPEED(25'd10000), .CAR_DIRECTION(0)) car_12 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_12));
    car #(.CAR_INIT_X(18), .BASE_SPEED(25'd8000), .CAR_DIRECTION(1)) car_13 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_13));
    car #(.CAR_INIT_X(10), .BASE_SPEED(25'd1600000), .CAR_DIRECTION(0)) car_14 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_14));
    car #(.CAR_INIT_X(0), .BASE_SPEED(25'd10000), .CAR_DIRECTION(0)) car_15 (.i_Clk(slow_clk),.level(game_level[6:0]),.o_car_x(car_x_15));

   
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
        o_Car_X[10] <= car_x_10;
        o_Car_X[11] <= car_x_11;
        o_Car_X[12] <= car_x_12;
        o_Car_X[13] <= car_x_13;
        o_Car_X[14] <= car_x_14;
        o_Car_X[15] <= car_x_15;

        
        o_Car_Y[0] <= 5'd12;
        o_Car_Y[1] <= 5'd11;
        o_Car_Y[2] <= 5'd12;
        o_Car_Y[3] <= 5'd2;
        o_Car_Y[4] <= 5'd10;
        o_Car_Y[5] <= 5'd9;
        o_Car_Y[6] <= 5'd10;
        o_Car_Y[7] <= 5'd9;
        o_Car_Y[8] <= 5'd8;
        o_Car_Y[9] <= 5'd8;
        o_Car_Y[10] <= 5'd5;
        o_Car_Y[11] <= 5'd4;
        o_Car_Y[12] <= 5'd3;
        o_Car_Y[13] <= 5'd2;
        o_Car_Y[14] <= 5'd1;
        o_Car_Y[15] <= 5'd3;
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

    always @(posedge i_Clk) begin
        
        r_Red_Video = 3'b000;
        r_Grn_Video = 3'b000;
        r_Blu_Video = 3'b000;

        
        if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y) && frog_sprite[frog_row][frog_col]!=4'd0) begin
			if(frog_sprite[frog_row][frog_col]==4'd1)begin
				// Red
	            r_Red_Video = 4'b0000;
	            r_Grn_Video = 4'b1111;
	            r_Blu_Video = 4'b0000;
			end
			else if(frog_sprite[frog_row][frog_col]==4'd2) begin
				// Yellow
	            r_Red_Video = 4'b1111;
	            r_Grn_Video = 4'b1111;
	            r_Blu_Video = 4'b0000;
			end
			else if(frog_sprite[frog_row][frog_col]==4'd3) begin
	            r_Red_Video = 4'b1111;
	            r_Grn_Video = 4'b0011;
	            r_Blu_Video = 4'b1001;
			end
		 
    end else begin
            
            if ((w_Col_Count_Div == car_x_0 && w_Row_Count_Div == 6'd12) ||
                (w_Col_Count_Div == car_x_1 && w_Row_Count_Div == 6'd11) ||
                (w_Col_Count_Div == car_x_2 && w_Row_Count_Div == 6'd12) ||
                (w_Col_Count_Div == car_x_3 && w_Row_Count_Div == 6'd2) ||
                (w_Col_Count_Div == car_x_4 && w_Row_Count_Div == 6'd10) ||
                (w_Col_Count_Div == car_x_5 && w_Row_Count_Div == 6'd9) ||
                (w_Col_Count_Div == car_x_6 && w_Row_Count_Div == 6'd10) ||
                (w_Col_Count_Div == car_x_7 && w_Row_Count_Div == 6'd9) ||
                (w_Col_Count_Div == car_x_8 && w_Row_Count_Div == 6'd8) ||
                (w_Col_Count_Div == car_x_9 && w_Row_Count_Div == 6'd8) ||
                (w_Col_Count_Div == car_x_10 && w_Row_Count_Div == 6'd5) ||
                (w_Col_Count_Div == car_x_11 && w_Row_Count_Div == 6'd4) ||
                (w_Col_Count_Div == car_x_12 && w_Row_Count_Div == 6'd3) ||
                (w_Col_Count_Div == car_x_13 && w_Row_Count_Div == 6'd2) ||
                (w_Col_Count_Div == car_x_14 && w_Row_Count_Div == 6'd1) ||
                (w_Col_Count_Div == car_x_15 && w_Row_Count_Div == 6'd3)) begin
                
                r_Red_Video = 3'b111;  
                r_Grn_Video = 3'b111;  
                r_Blu_Video = 3'b111;  
                    
                case (car_sprite[car_row][car_col])
	                4'd0: begin
	                    // Background color (Black)
	                    r_Red_Video = 4'b0000;
	                    r_Grn_Video = 4'b0000;
	                    r_Blu_Video = 4'b0000;
	                end
	                4'd1: begin
	                    // Red
	                    r_Red_Video = 4'b1111;
	                    r_Grn_Video = 4'b0000;
	                    r_Blu_Video = 4'b0000;
	                end
	                4'd2: begin
	                    // Yellow
	                    r_Red_Video = 4'b1111;
	                    r_Grn_Video = 4'b1111;
	                    r_Blu_Video = 4'b0000;
	                end
	                4'd3: begin
	                    // Purple 
	                    r_Red_Video = 4'b1111;
	                    r_Grn_Video = 4'b0000;
	                    r_Blu_Video = 4'b1111;
	                end
	                default: begin
	                    // Default to background color (Black)
	                    r_Red_Video = 4'b0000;
	                    r_Grn_Video = 4'b0000;
	                    r_Blu_Video = 4'b0000;
	                end
	            endcase
            end
        end

        
        if (r_Red_Video == 3'b000 && r_Grn_Video == 3'b000 && r_Blu_Video == 3'b000) begin
            if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT) begin
                case (r_Bitmap[w_Row_Count_Div][w_Col_Count_Div])
                    3'd0: begin  
                        r_Red_Video = 3'b010; // orange is r = 3'b001, g = 3'b000, b = 3'b000
                        r_Grn_Video = 3'b100;
                        r_Blu_Video = 3'b001;
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
                        r_Red_Video = 3'b100;  
                        r_Grn_Video = 3'b100;
                        r_Blu_Video = 3'b100;
                    end
                    3'd4: begin  
                        r_Red_Video = 3'b001;
                        r_Grn_Video = 3'b001;
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
        .i_Score(game_level[6:0]),
        .o_Segment1(o_Segment1),
        .o_Segment2(o_Segment2)
    );

    // Implement lives display
    lives_counter lives_counter_inst (
        .i_Clk(i_Clk),
        .i_Collided(w_Collided),
        .o_LED_2(o_LED_2),
        .o_LED_3(o_LED_3),
        .o_LED_4(o_LED_4)
    );

endmodule