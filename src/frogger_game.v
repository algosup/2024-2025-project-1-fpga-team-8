module frogger_game #(
    // Game Parameters
    parameter c_TOTAL_COLS=800,
    parameter c_TOTAL_ROWS=525,
    parameter c_ACTIVE_COLS=640,
    parameter c_ACTIVE_ROWS=480
)(
    // Inputs
    input            i_Clk,
    input            i_HSync,
    input            i_VSync,
    input            i_Game_Start,
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

    // Debug and display
    output o_LED_1,
    output [6:0]     o_Segment1,
    output [6:0]     o_Segment2
);

    // Game constants
    parameter c_GAME_WIDTH = 20;
    parameter c_GAME_HEIGHT = 15;
    parameter TILE_SIZE     = 32;
    parameter NUM_CARS      = 10;

	// Car speeds
	localparam [NUM_CARS*6-1:0] car_speeds = {6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1};

    reg [2:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];
    reg [8:0] game_state;

    // Internal signals
    wire w_Game_Active = 1'b1;
    wire       w_HSync, w_VSync;
    wire [9:0] w_Col_Count, w_Row_Count;
    wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
    wire [5:0] w_Frogger_X, w_Frogger_Y;
    wire w_Collided;

    wire [NUM_CARS*6-1:0] o_Car_X;
    wire [NUM_CARS*6-1:0] o_Car_Y;

    assign w_Col_Count_Div = w_Col_Count[9:5];
    assign w_Row_Count_Div = w_Row_Count[9:5];

    // Synchronize to row and column counters
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

    integer row, col;
    initial begin
        $readmemh("bitmap_init.mem", r_Bitmap);
    end

    wire [2:0] w_Bitmap_Data;
    assign w_Bitmap_Data = (w_Frogger_Y < c_GAME_HEIGHT && w_Frogger_X < c_GAME_WIDTH) ? 
        r_Bitmap[w_Frogger_Y][w_Frogger_X] : 3'd0;

    // Control Frogger's movements and track its position
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

    // multi_car_ctrl #(
	// 	.NUM_CARS(NUM_CARS),
	// 	.c_CAR_SPEED({1, 1, 1, 1, 1, 1, 1, 1, 1, 1}),
	// 	.c_MAX_X(20)  // Ensure this is aligned with the grid and display limits
	// ) car_control_inst (
	// 	.i_Clk(i_Clk),
	// 	.i_Init_X({6'd1, 6'd2, 6'd3, 6'd4, 6'd5, 6'd6, 6'd7, 6'd8, 6'd9, 6'd10}),  // Smaller, distinct X values for testing
	// 	.i_Init_Y({6'd1, 6'd2, 6'd3, 6'd4, 6'd5, 6'd8, 6'd9, 6'd10, 6'd11, 6'd12}),  // Y values as before
	// 	.o_Car_X(o_Car_X),
	// 	.o_Car_Y(o_Car_Y)
	// );


	// Instantiate the debug version of the multi-car controller with only 2 cars
	// multi_car_ctrl_debug #(
	// 	.NUM_CARS(10),               // Test with 2 cars
	// 	.c_MAX_X(20),               // Maximum X position (smaller grid for testing)
	// 	.c_CAR_SPEED_0(1),          // Speed for car 1
	// 	.c_CAR_SPEED_1(1),
	// 	.c_CAR_SPEED_2(1),
	// 	.c_CAR_SPEED_3(1),
	// 	.c_CAR_SPEED_4(1),
	// 	.c_CAR_SPEED_5(1),
	// 	.c_CAR_SPEED_6(1),
	// 	.c_CAR_SPEED_7(1),
	// 	.c_CAR_SPEED_8(1),
	// 	.c_CAR_SPEED_9(1),
	// 	.c_SLOW_COUNT(2000000)      // Slowdown counter value
	// ) car_control_debug_inst (
	// 	.i_Clk(i_Clk),              // Pass the clock signal
	// 	.o_Car_X(o_Car_X),          // Connect to the X position output
	// 	.o_Car_Y(o_Car_Y)           // Connect to the Y position output
	// );

	// multi_car_ctrl_optimized #(
	// 	.NUM_CARS(10),
	// 	.c_CAR_SPEED(car_speeds),
	// 	.c_MAX_X(20),
	// 	.c_SLOW_COUNT(10000000)
	// ) car_control_inst (
	// 	.i_Clk(i_Clk),
	// 	.o_Car_X(o_Car_X),
	// 	.o_Car_Y(o_Car_Y)
	// );

	multi_car_ctrl_optimized #(
    .NUM_CARS(10),
    .c_CAR_SPEED(car_speeds),                  // Keep your speed configuration
    .c_CAR_DIRECTION(10'b1010101010),          // Example: alternating directions for 10 cars
    .c_MAX_X(20),
    .c_SLOW_COUNT(2000000)
	) car_control_inst (
		.i_Clk(i_Clk),
		.o_Car_X(o_Car_X),
		.o_Car_Y(o_Car_Y)
	);






    // Collision check with multiple cars
    integer i;
    always @(posedge i_Clk) begin
        w_Collided = 1'b0;
        for (i = 0; i < NUM_CARS; i = i + 1) begin
            if (w_Frogger_X == o_Car_X[i*6 +: 6] && w_Frogger_Y == o_Car_Y[i*6 +: 6]) begin
                w_Collided = 1'b1;
            end
        end
    end

    reg [2:0] r_Red_Video, r_Grn_Video, r_Blu_Video;

    always @(*) begin
		// Reset video signals to black (default)
		r_Red_Video = 3'b000;
		r_Grn_Video = 3'b000;
		r_Blu_Video = 3'b000;

		// Check if the current tile matches Frogger's position
		if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y)) begin
			// Draw Frogger in red
			r_Red_Video = 3'b111;  // Red
			r_Grn_Video = 3'b000;  // No green
			r_Blu_Video = 3'b000;  // No blue
		end 
		else begin

			// Draw car 1 based on its X and Y position
			if ((w_Col_Count_Div == o_Car_X[0*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[0*6 +: 6])) begin
				r_Red_Video = 3'b111;  // White
				r_Grn_Video = 3'b111;
				r_Blu_Video = 3'b111;
			end

			// Draw car 2 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[1*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[1*6 +: 6])) begin
				r_Red_Video = 3'b000;  // Cyan
				r_Grn_Video = 3'b111;
				r_Blu_Video = 3'b111;
			end
			
			// Draw car 3 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[2*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[2*6 +: 6])) begin
				r_Red_Video = 3'b111;  // Magenta
				r_Grn_Video = 3'b000;
				r_Blu_Video = 3'b111;
			end

			// Draw car 4 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[3*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[3*6 +: 6])) begin
				r_Red_Video = 3'b111;  // Yellow
				r_Grn_Video = 3'b111;
				r_Blu_Video = 3'b000;
			end

			// Draw car 5 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[4*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[4*6 +: 6])) begin
				r_Red_Video = 3'b000;  // Blue
				r_Grn_Video = 3'b000;
				r_Blu_Video = 3'b111;
			end

			// Draw car 6 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[5*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[5*6 +: 6])) begin
				r_Red_Video = 3'b111;  // Green
				r_Grn_Video = 3'b000;
				r_Blu_Video = 3'b111;
			end

			// Draw car 7 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[6*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[6*6 +: 6])) begin
				r_Red_Video = 3'b111;  // Cyan
				r_Grn_Video = 3'b111;
				r_Blu_Video = 3'b000;
			end

			// Draw car 8 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[7*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[7*6 +: 6])) begin
				r_Red_Video = 3'b000;  // Magenta
				r_Grn_Video = 3'b111;
				r_Blu_Video = 3'b111;
			end

			// Draw car 9 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[8*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[8*6 +: 6])) begin
				r_Red_Video = 3'b111;  // Yellow
				r_Grn_Video = 3'b000;
				r_Blu_Video = 3'b111;
			end

			// Draw car 10 based on its X and Y position
			else if ((w_Col_Count_Div == o_Car_X[9*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[9*6 +: 6])) begin
				r_Red_Video = 3'b000;  // White
				r_Grn_Video = 3'b111;
				r_Blu_Video = 3'b111;
			end
		end

		// If no Frogger or car, draw the background based on the bitmap
		if (r_Red_Video == 3'b000 && r_Grn_Video == 3'b000 && r_Blu_Video == 3'b000) begin
			// Only draw the background if nothing is drawn yet (no Frogger or car)
			if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT) begin
				case (r_Bitmap[w_Row_Count_Div][w_Col_Count_Div])
					3'd0: begin  // Wall
						r_Red_Video = 3'b001;
						r_Grn_Video = 3'b110;
						r_Blu_Video = 3'b000;
					end
					3'd1: begin  // Road
						r_Red_Video = 3'b000;
						r_Grn_Video = 3'b000;
						r_Blu_Video = 3'b000;
					end
					3'd2: begin  // Water
						r_Red_Video = 3'b001;
						r_Grn_Video = 3'b000;
						r_Blu_Video = 3'b110;
					end
					3'd3: begin  // Safe Area
						// Safe Area color with black lines on the top/bottom
						if ((w_Row_Count % TILE_SIZE == 0) || (w_Row_Count % TILE_SIZE == TILE_SIZE - 1)) begin
							r_Red_Video = 3'b000;  // Black line
							r_Grn_Video = 3'b000;
							r_Blu_Video = 3'b000;
						end else begin
							r_Red_Video = 3'b011;  // Safe Area
							r_Grn_Video = 3'b000;
							r_Blu_Video = 3'b111;
						end
					end
					3'd4: begin  // Lily Pad
						r_Red_Video = 3'b001;
						r_Grn_Video = 3'b000;
						r_Blu_Video = 3'b110;
					end
					default: begin  // Background (black)
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
