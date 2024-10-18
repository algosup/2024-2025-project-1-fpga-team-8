// module frogger_game #(
// /// This module is responsible for controlling the game logic and rendering the game on the VGA display.
// 	/// Game Parameters
// 		// Total columns in the VGA display
// 		parameter c_TOTAL_COLS=800,
// 		// Total rows in the VGA display
// 		parameter c_TOTAL_ROWS=525,
// 		// Active columns in the VGA display
// 		parameter c_ACTIVE_COLS=640,
// 		// Active rows in the VGA display
// 		parameter c_ACTIVE_ROWS=480
// )(
// 	/// Inputs
// 		// Clock input
// 		input            i_Clk,
// 		// Horizontal sync signal
// 		input            i_HSync,
// 		// Vertical sync signal
// 		input            i_VSync,
// 		// Game Start Button   
// 		input            i_Game_Start,
// 		// Up movement switch
// 		input            i_Up_Mvt,
// 		// Down movement switch
// 		input            i_Down_Mvt,
// 		// Left movement switch
// 		input            i_Left_Mvt,
// 		// Right movement switch
// 		input            i_Right_Mvt,

//    	/// Output Video
// 		// Horizontal sync signal
// 		output reg       o_HSync,
// 		// Vertical sync signal
// 		output reg       o_VSync,
// 		// Red video output
// 		output [3:0]     o_Red_Video,
// 		// Green video output
// 		output [3:0]     o_Grn_Video,
// 		// Blue video output
// 		output [3:0]     o_Blu_Video,

// 		// TODO: On Log led debug
// 		output o_LED_1,
		
// 		// 7-segment display outputs
// 		output [6:0]     o_Segment1,
// 		output [6:0]     o_Segment2
// );

//   	// Game constants
// 		// 14 columns in the bitmap
// 		parameter c_GAME_WIDTH = 20;
// 		// 13 rows in the bitmap
// 		parameter c_GAME_HEIGHT = 15;
// 		// Each tile is 32x32 pixels
// 		parameter TILE_SIZE     = 32;

//     // Bitmap array: 0=wall, 1=road, 2=water, 3=safe area, 4=lily pad
// 	// OPTIMIZEDBELOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

//   		// reg [3:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];
//   		reg [2:0] r_Bitmap[0:c_GAME_HEIGHT-1][0:c_GAME_WIDTH-1];

// 	/// Functions
// 		// Function to handle coordinate wrapping
// 		function [5:0] subtract_modulo;
// 			input [5:0] x;
// 			input [5:0] y;
// 			begin
// 				if (x >= y)
// 					subtract_modulo = x - y;
// 				else
// 					subtract_modulo = c_GAME_WIDTH - (y - x);
// 			end
// 		endfunction

//   	// Player starts with 3 lives
// 		// reg [1:0] lives = 2'b11;
  	
// 	// Register for storing the score
// 		// reg [6:0] r_Frogger_Score;

// 	// Main game consolidated state storage
// 		reg [8:0] game_state;

// 		// Use specific bits to represent different states
// 		// always @(posedge i_Clk) begin
// 		// 	game_state[1:0] <= lives;
// 		// 	game_state[8:2] <= r_Frogger_Score;
// 		// 	game_state[31:9] <= r_LED_Counter;
// 		// end



// 	/// Internal signals
// 		wire w_Game_Active = 1'b1;
// 		wire       w_HSync, w_VSync;
// 		wire [9:0] w_Col_Count, w_Row_Count;
// 		wire [4:0] w_Col_Count_Div, w_Row_Count_Div;
// 		wire [5:0] w_Frogger_X, w_Frogger_Y;

//   	// Cars
// 		// Outputs for the car positions
// 		output wire [NUM_CARS*6-1:0] o_Car_X,
// 		// Lanes 
// 		output wire [NUM_CARS*6-1:0] o_Car_Y 

//   	// Drop 5 LSBs, which effectively divides by 32
// 		assign w_Col_Count_Div = w_Col_Count[9:5];
// 		assign w_Row_Count_Div = w_Row_Count[9:5];


//   	wire w_Collided;


//   	// Synchronize to row and column counters
// 		Sync_To_Count #(

// 			.TOTAL_COLS(c_TOTAL_COLS),
// 			.TOTAL_ROWS(c_TOTAL_ROWS)
			
// 			) Sync_To_Count_Inst(

// 			.i_Clk(i_Clk),
// 			.i_HSync(i_HSync),
// 			.i_VSync(i_VSync),
// 			.o_HSync(o_HSync),
// 			.o_VSync(o_VSync),
// 			.o_Col_Count(w_Col_Count),
// 			.o_Row_Count(w_Row_Count)
			
// 		);

//   	// Convert current column and row into tile coordinates
// 		assign w_Col_Count_Div = w_Col_Count[9:5]; // Divide by TILE_SIZE (32)
// 		assign w_Row_Count_Div = w_Row_Count[9:5];

//   	// Initialize bitmap background
// 		integer row, col;  // Declare loop index variables outside of the loops
// 		initial begin
// 			$readmemh("bitmap_init.mem", r_Bitmap);

// 		end

// 	// OPTIMIZEDBELOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; REMOVED ONE BIT FROM BITMAP DATA
//     // wire [3:0] w_Bitmap_Data;
//     wire [2:0] w_Bitmap_Data;

//   	// Assign bitmap data corresponding to Frogger's position
// 		assign w_Bitmap_Data = (w_Frogger_Y < c_GAME_HEIGHT && w_Frogger_X < c_GAME_WIDTH) ? 
// 			r_Bitmap[w_Frogger_Y][w_Frogger_X] : 4'd0;

//   	// Control Frogger's movements and track its position
// 		frogger_ctrl frogger_ctrl_inst (
// 			.i_Clk(i_Clk),
// 			.i_Score(game_state[8:2]),
// 			.i_Up_Mvt(i_Up_Mvt),
// 			.i_Down_Mvt(i_Down_Mvt),
// 			.i_Left_Mvt(i_Left_Mvt),
// 			.i_Right_Mvt(i_Right_Mvt),
// 			.i_Collided(w_Collided),
// 			.i_Col_Count_Div(w_Col_Count_Div),
// 			.i_Row_Count_Div(w_Row_Count_Div),
// 			.i_Bitmap_Data(w_Bitmap_Data),  // Pass the bitmap data
// 			.o_Frogger_X(w_Frogger_X),
// 			.o_Frogger_Y(w_Frogger_Y),
// 			.o_Score(game_state[8:2]),
// 		);


//     // Car 1 instance
// 		// car_ctrl #(
// 		// .c_CAR_SPEED(1),
// 		// .c_MAX_X(20),
// 		// .c_SLOW_COUNT(10000000),
// 		// .c_INIT_X(0),
// 		// .c_INIT_Y(12)
// 		// )
		
// 		// car_ctrl_inst_1 (
// 		// 	.i_Clk(i_Clk),
// 		// 	.i_Col_Count_Div(w_Col_Count_Div),
// 		// 	.i_Row_Count_Div(w_Row_Count_Div),
// 		// 	.o_Car_X(w_Car_X_1),
// 		// 	.o_Car_Y(w_Car_Y_1),
// 		// );


// 	multi_car_ctrl #(
//     .NUM_CARS(4),
//     .c_CAR_SPEED({1, 2, 1, 3}),  // Speeds for each car
//     .c_MAX_X(40)
// 	) car_control_inst (
// 		.i_Clk(i_Clk),
// 		.i_Init_X({0, 10, 20, 30}),  // Initial X positions
// 		.i_Init_Y({5, 6, 7, 8}),     // Y positions (lanes) for each car
// 		.o_Car_X(o_Car_X),
// 		.o_Car_Y(o_Car_Y)
// 	);


// 	// TEMPORARY: Assign car positions to out-of-bounds values to deactivate collisions
// 		// assign w_Car_X_2 = 6'd63;
// 		// assign w_Car_Y_2 = 6'd63;

//   	// Check for collisions between Frogger and cars
// 		frogger_collisions frogger_collisions_inst (
// 			.i_Clk(i_Clk),
// 			.i_Frogger_X(w_Frogger_X),
// 			.i_Frogger_Y(w_Frogger_Y),
// 			.i_Frogger_Orig_x(10),
// 			.i_Frogger_Orig_y(14),
// 			// .i_Car_X_1(w_Car_X_1),
// 			// .i_Car_Y_1(w_Car_Y_1),
// 			.o_Collided(w_Collided),
// 		);


// 	// Determine background colors based on the bitmap and draw Frogger if applicable
// 	// OPTIMIZEDBELOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; REMOVED ONE BIT FROM EACH COLOR CHANNEL
// 		// reg [3:0] r_Red_Video, r_Grn_Video, r_Blu_Video;
// 		reg [2:0] r_Red_Video, r_Grn_Video, r_Blu_Video;

// 	/// Main game logic
// 		always @(*) begin

// 			// Check if the current tile matches Frogger's position
// 			if ((w_Col_Count_Div == w_Frogger_X) && (w_Row_Count_Div == w_Frogger_Y))
// 				begin

// 					// If in the same tile as Frogger, draw Frogger in red
// 					r_Red_Video = 4'b1111; // White
// 					r_Grn_Video = 4'b0000;
// 					r_Blu_Video = 4'b0000;
// 				end


// 			// else if ((w_Col_Count_Div == w_Car_X_1) && (w_Row_Count_Div == w_Car_Y_1))

// 			// 	begin

// 			// 		// If in the same tile as a car, draw the car in white
// 			// 		r_Red_Video = 4'b1111;
// 			// 		r_Grn_Video = 4'b1111;
// 			// 		r_Blu_Video = 4'b1111;
// 			// 	end


// 			// Otherwise, draw the background based on the bitmap
// 			else if (w_Col_Count_Div < c_GAME_WIDTH && w_Row_Count_Div < c_GAME_HEIGHT)
// 				begin
					
// 					// Check the current tile in the bitmap
// 					case (r_Bitmap[w_Row_Count_Div][w_Col_Count_Div])

// 					4'd0: begin
// 						r_Red_Video = 4'b0001;  // Wall: Red Channel = 0
// 						r_Grn_Video = 4'b1110;  // Wall: Green Channel = 14
// 						r_Blu_Video = 4'b0000;  // Wall: Blue Channel = 0
// 					end

// 					4'd1: begin
// 						r_Red_Video = 4'b0000;  // Road: Red Channel = 0
// 						r_Grn_Video = 4'b0000;  // Road: Green Channel = 0
// 						r_Blu_Video = 4'b0000;  // Road: Blue Channel = 0
// 					end

// 					4'd2: begin
// 						r_Red_Video = 4'b0001;  // Water: Red Channel = 1
// 						r_Grn_Video = 4'b0000;  // Water: Green Channel = 0
// 						r_Blu_Video = 4'b1110;  // Water: Blue Channel = 14
// 					end
					
// 					4'd3: begin

// 						// Safe Area: Check if it's the top or bottom line of the tile
// 						if ((w_Row_Count % TILE_SIZE == 0) || (w_Row_Count % TILE_SIZE == TILE_SIZE - 1)) 
// 							begin

// 								// Top or bottom line of the tile
// 								r_Red_Video = 4'b0000;  // Black line
// 								r_Grn_Video = 4'b0000;
// 								r_Blu_Video = 4'b0000;
// 							end
							
// 							else begin
// 								// Normal safe area color
// 								r_Red_Video = 4'b0011;  // Safe Area: Red Channel = 3
// 								r_Grn_Video = 4'b0000;  // Safe Area: Green Channel = 0
// 								r_Blu_Video = 4'b1111;  // Safe Area: Blue Channel = 15
// 							end
// 					end

// 					4'd4: begin
// 						r_Red_Video = 4'b0001;  // Lily Pad: Red Channel = 1
// 						r_Grn_Video = 4'b0000;  // Lily Pad: Green Channel = 0
// 						r_Blu_Video = 4'b1110;  // Lily Pad: Blue Channel = 14
// 					end

// 					default: begin
// 						r_Red_Video = 4'b0000;  // Background: Red Channel = 0
// 						r_Grn_Video = 4'b0000;  // Background: Green Channel = 0
// 						r_Blu_Video = 4'b0000;  // Background: Blue Channel = 0
// 					end

// 					endcase
// 				end else
// 					begin
// 						r_Red_Video = 4'b0000;
// 						r_Grn_Video = 4'b0000;
// 						r_Blu_Video = 4'b0000;
// 					end
// 		end

// 		// Assign video outputs
// 			assign o_Red_Video = r_Red_Video;
// 			assign o_Grn_Video = r_Grn_Video;
// 			assign o_Blu_Video = r_Blu_Video;

// 		// Display Score on 7-segment displays
// 			score_control score_control_inst (
// 				.i_Clk(i_Clk),
// 				.i_Score(game_state[8:2]),
// 				.o_Segment1(o_Segment1),
// 				.o_Segment2(o_Segment2)
// 			);

// endmodule


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
	multi_car_ctrl_debug #(
		.NUM_CARS(2),               // Test with 2 cars
		.c_MAX_X(20),               // Maximum X position (smaller grid for testing)
		.c_CAR_SPEED_0(1),          // Speed for car 1
		.c_CAR_SPEED_1(2),          // Speed for car 2
		.c_SLOW_COUNT(2000000)      // Slowdown counter value
	) car_control_debug_inst (
		.i_Clk(i_Clk),              // Pass the clock signal
		.o_Car_X(o_Car_X),          // Connect to the X position output
		.o_Car_Y(o_Car_Y)           // Connect to the Y position output
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
			// Check if the current tile matches any car's position
			// for (i = 0; i < NUM_CARS; i = i + 1) begin
			// 	if ((w_Col_Count_Div == o_Car_X[i*6 +: 6]) && (w_Row_Count_Div == o_Car_Y[i*6 +: 6])) begin
			// 		// Draw the car in white
			// 		r_Red_Video = 3'b111;  // White
			// 		r_Grn_Video = 3'b111;
			// 		r_Blu_Video = 3'b111;
			// 	end
			// end

			// DEBUG
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
