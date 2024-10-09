module frogger_game #(
/// This module is responsible for controlling the game logic and rendering the game on the VGA display.
	/// Game Parameters
		// Total columns in the VGA display
		parameter c_TOTAL_COLS=800,
		// Total rows in the VGA display
		parameter c_TOTAL_ROWS=525,
		// Active columns in the VGA display
		parameter c_ACTIVE_COLS=640,
		// Active rows in the VGA display
		parameter c_ACTIVE_ROWS=480
)(
	/// Inputs
		// Clock input
		input            i_Clk,
		// Horizontal sync signal
		input            i_HSync,
		// Vertical sync signal
		input            i_VSync,
		// Game Start Button   
		input            i_Game_Start,
		// Up movement switch
		input            i_Up_Mvt,
		// Down movement switch
		input            i_Down_Mvt,
		// Left movement switch
		input            i_Left_Mvt,
		// Right movement switch
		input            i_Right_Mvt,

   	/// Output Video
		// Horizontal sync signal
		output reg       o_HSync,
		// Vertical sync signal
		output reg       o_VSync,
		// Red video output
		output [3:0]     o_Red_Video,
		// Green video output
		output [3:0]     o_Grn_Video,
		// Blue video output
		output [3:0]     o_Blu_Video,
		
		// 7-segment display outputs
		output [6:0]     o_Segment1,
		output [6:0]     o_Segment2
);


  	// Game constants
		// 14 columns in the bitmap
		parameter c_GAME_WIDTH  = 14;
		// 13 rows in the bitmap
		parameter c_GAME_HEIGHT = 13;
		// Each tile is 32x32 pixels
		parameter TILE_SIZE     = 32;

    // Bitmap array: 0=wall, 1=road, 2=water, 3=safe area, 4=lily pad
  		reg [3:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];

  	/// State machine enumerations
		// Game not started
		parameter IDLE    = 2'b00;
		// Game running
		parameter RUNNING = 2'b01;
		// Player 1 wins
		parameter P1_WINS = 2'b10;
		// State for resetting the game
		parameter CLEANUP = 2'b11;

  	// Player starts with 3 lives
		reg [1:0] lives = 2'b11;

	/// Internal signals
		wire w_Game_Active = 1'b1;
		wire       w_HSync, w_VSync;
		wire [9:0] w_Col_Count, w_Row_Count;
		wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
		wire [5:0] w_Frogger_X, w_Frogger_Y;
		wire w_Game_Active;

  	// Cars
		wire [5:0] w_Car_X_1, w_Car_Y_1;
		wire [5:0] w_Car_X_2, w_Car_Y_2;
		wire [5:0] w_Car_X_3, w_Car_Y_3;
		wire [5:0] w_Car_X_4, w_Car_Y_4;
		wire [5:0] w_Car_X_5, w_Car_Y_5;

	// Floating Logs
		wire [5:0] w_Floating_X_1, w_Floating_Y_1;
		wire [5:0] w_Floating_X_2, w_Floating_Y_2;
		wire [5:0] w_Floating_X_3, w_Floating_Y_3;
		wire [5:0] w_Floating_X_4, w_Floating_Y_4;
		wire [5:0] w_Floating_X_5, w_Floating_Y_5;

  	// Drop 5 LSBs, which effectively divides by 32
		assign w_Col_Count_Div = w_Col_Count[9:5];
		assign w_Row_Count_Div = w_Row_Count[9:5];

  	wire w_Collided;

  	reg [6:0] r_Frogger_Score;

  	// Synchronize to row and column counters
		Sync_To_Count #(

			.TOTAL_COLS(c_TOTAL_COLS),
			.TOTAL_ROWS(c_TOTAL_ROWS)
			
			) Sync_To_Count_Inst(

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
    	$readmemh("bitmap_init.mem", r_Bitmap);

  	end

    wire [3:0] w_Bitmap_Data;

  	// Assign bitmap data corresponding to Frogger's position
		assign w_Bitmap_Data = (w_Frogger_Y < c_GAME_HEIGHT && w_Frogger_X < c_GAME_WIDTH) ? 
			r_Bitmap[w_Frogger_Y][w_Frogger_X] : 4'd0;

  	// Control Frogger's movements and track its position
		frogger_ctrl frogger_ctrl_inst (
			.i_Clk(i_Clk),
			.i_Score(r_Frogger_Score),
			.i_Up_Mvt(i_Up_Mvt),
			.i_Down_Mvt(i_Down_Mvt),
			.i_Left_Mvt(i_Left_Mvt),
			.i_Right_Mvt(i_Right_Mvt),
			.i_Game_Active(w_Game_Active),
			.i_Collided(w_Collided),
			.i_Col_Count_Div(w_Col_Count_Div),
			.i_Row_Count_Div(w_Row_Count_Div),
			.i_Bitmap_Data(w_Bitmap_Data),  // Pass the bitmap data
			.o_Frogger_X(w_Frogger_X),
			.o_Frogger_Y(w_Frogger_Y),
			.o_Score(r_Frogger_Score)
		);
/*
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

	// Car 4 instance
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

	// Car 5 instance
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
*/
	// Floating Log 1 instance 
		floating_ctrl #(
			.c_FLOATING_SPEED(1),
			.c_MIN_X(0),
			.c_SLOW_COUNT(4200000),
			.c_INIT_X(13),
			.c_INIT_Y(1)
		)

		floating_ctrl_inst_1 (
			.i_Clk(i_Clk),
			.i_Col_Count_Div(w_Col_Count_Div),
			.i_Row_Count_Div(w_Row_Count_Div),
			.o_Floating_X(w_Floating_X_1),
			.o_Floating_Y(w_Floating_Y_1),
		);

	// Floating Log 2 instance 
		floating_ctrl #(
			.c_FLOATING_SPEED(1),
			.c_MIN_X(0),
			.c_SLOW_COUNT(4200000),
			.c_INIT_X(13),
			.c_INIT_Y(2)
		)

		floating_ctrl_inst_2 (
			.i_Clk(i_Clk),
			.i_Col_Count_Div(w_Col_Count_Div),
			.i_Row_Count_Div(w_Row_Count_Div),
			.o_Floating_X(w_Floating_X_2),
			.o_Floating_Y(w_Floating_Y_2),
		);

	// Floating Log 3 instance 
		floating_ctrl #(
			.c_FLOATING_SPEED(1),
			.c_MIN_X(0),
			.c_SLOW_COUNT(4200000),
			.c_INIT_X(13),
			.c_INIT_Y(3)
		)

		floating_ctrl_inst_3 (
			.i_Clk(i_Clk),
			.i_Col_Count_Div(w_Col_Count_Div),
			.i_Row_Count_Div(w_Row_Count_Div),
			.o_Floating_X(w_Floating_X_3),
			.o_Floating_Y(w_Floating_Y_3),
		);

	// Floating Log 4 instance 
		floating_ctrl #(
			.c_FLOATING_SPEED(1),
			.c_MIN_X(0),
			.c_SLOW_COUNT(4200000),
			.c_INIT_X(13),
			.c_INIT_Y(4)
		)

		floating_ctrl_inst_4 (
			.i_Clk(i_Clk),
			.i_Col_Count_Div(w_Col_Count_Div),
			.i_Row_Count_Div(w_Row_Count_Div),
			.o_Floating_X(w_Floating_X_4),
			.o_Floating_Y(w_Floating_Y_4),
		);

	// Floating Log 5 instance 
		floating_ctrl #(
			.c_FLOATING_SPEED(1),
			.c_MIN_X(0),
			.c_SLOW_COUNT(4200000),
			.c_INIT_X(13),
			.c_INIT_Y(5)
		)

		floating_ctrl_inst_5 (
			.i_Clk(i_Clk),
			.i_Col_Count_Div(w_Col_Count_Div),
			.i_Row_Count_Div(w_Row_Count_Div),
			.o_Floating_X(w_Floating_X_5),
			.o_Floating_Y(w_Floating_Y_5),
		);
	
  	// Check for collisions between Frogger and cars
		frogger_collisions frogger_collisions_inst (
			.i_Clk(i_Clk),
			.i_Frogger_X(w_Frogger_X),
			.i_Frogger_Y(w_Frogger_Y),
			.i_Frogger_Orig_x(10),
			.i_Frogger_Orig_y(14),
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


	// Determine background colors based on the bitmap and draw Frogger if applicable
	reg [3:0] r_Red_Video, r_Grn_Video, r_Blu_Video;

	/// Main game logic
	always @(*) begin

		// Check if the current tile matches Frogger's position
		if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y) || 
			// (w_Col_Count_Div == w_Car_X_1) && (w_Row_Count_Div == w_Car_Y_1) || 
			// (w_Col_Count_Div == w_Car_X_2) && (w_Row_Count_Div == w_Car_Y_2) || 
			// (w_Col_Count_Div == w_Car_X_3) && (w_Row_Count_Div == w_Car_Y_3) || 
			// (w_Col_Count_Div == w_Car_X_4) && (w_Row_Count_Div == w_Car_Y_4) || 
			// (w_Col_Count_Div == w_Car_X_5) && (w_Row_Count_Div == w_Car_Y_5) ||
			(w_Col_Count_Div == w_Floating_X_1) && (w_Row_Count_Div == w_Floating_Y_1) ||
			(w_Col_Count_Div == w_Floating_X_2) && (w_Row_Count_Div == w_Floating_Y_2) ||
			(w_Col_Count_Div == w_Floating_X_3) && (w_Row_Count_Div == w_Floating_Y_3) ||
			(w_Col_Count_Div == w_Floating_X_4) && (w_Row_Count_Div == w_Floating_Y_4) ||
			(w_Col_Count_Div == w_Floating_X_5) && (w_Row_Count_Div == w_Floating_Y_5))
			begin

				// If in the same tile as Frogger, draw Frogger in white
				r_Red_Video = 4'b1111; // White
				r_Grn_Video = 4'b1111;
				r_Blu_Video = 4'b1111;
			end

		// Otherwise, draw the background based on the bitmap
		else if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT)
			begin
				
				// Check the current tile in the bitmap
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
					if ((w_Row_Count % TILE_SIZE == 0) || (w_Row_Count % TILE_SIZE == TILE_SIZE - 1)) 
						begin

							// Top or bottom line of the tile
							r_Red_Video = 4'b0000;  // Black line
							r_Grn_Video = 4'b0000;
							r_Blu_Video = 4'b0000;
						end
						
						else begin
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
			end else
				begin
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
