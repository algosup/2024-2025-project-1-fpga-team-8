// module multi_car_ctrl #(
//     parameter NUM_CARS = 10,                    // Number of cars
//     parameter c_MAX_X = 40,                    // Maximum X position (grid width)
//     parameter [NUM_CARS-1:0] c_CAR_SPEED = {1, 2, 1, 3}, // Speed for each car
//     parameter c_SLOW_COUNT = 2000000,          // Reduced Slowdown counter threshold
//     parameter COUNTER_WIDTH = 26               // Counter width for slowdown
// )(
//     input i_Clk,                               // Clock input
//     input [NUM_CARS*6-1:0] i_Init_X,           // Flattened initial X positions for all cars
//     input [NUM_CARS*6-1:0] i_Init_Y,           // Flattened initial Y positions for all cars (lanes)
//     output reg [NUM_CARS*6-1:0] o_Car_X,       // Flattened X positions for all cars
//     output reg [NUM_CARS*6-1:0] o_Car_Y        // Flattened Y positions for all cars (lanes)
// );

//     // Internal signals
//     reg [COUNTER_WIDTH-1:0] r_Counter = 0;  // Shared slowdown counter
//     reg initialized = 0;  // Flag to ensure initialization happens only once
//     integer i;  // Loop variable

//     // Main car control logic
//     always @(posedge i_Clk) begin
//         // Initialize car positions only once
//         if (!initialized) begin
//             for (i = 0; i < NUM_CARS; i = i + 1) begin
//                 o_Car_X[i*6 +: 6] <= i_Init_X[i*6 +: 6];
//                 o_Car_Y[i*6 +: 6] <= i_Init_Y[i*6 +: 6];
//             end
//             initialized <= 1;  // Set flag to prevent reinitialization
//         end

//         // Increment the slow down counter
//         r_Counter <= r_Counter + 1;

//         // When the counter reaches the threshold, update all car positions
//         if (r_Counter >= c_SLOW_COUNT) begin
//             // Reset the counter
//             r_Counter <= 0;

//             // Update each car's position based on its speed
//             for (i = 0; i < NUM_CARS; i = i + 1) begin
//                 if (o_Car_X[i*6 +: 6] + c_CAR_SPEED[i] < c_MAX_X) begin
//                     o_Car_X[i*6 +: 6] <= o_Car_X[i*6 +: 6] + c_CAR_SPEED[i];  // Move car based on its speed
//                 end
//                 else begin
//                     o_Car_X[i*6 +: 6] <= 0;  // Wrap around when reaching or exceeding the end
//                 end
//             end
//         end
//     end

// endmodule




module multi_car_ctrl_debug #(
    parameter NUM_CARS = 10,                     // Number of cars
    parameter c_MAX_X = 20,                     // Maximum X position
    parameter c_CAR_SPEED_0 = 1,                // Speed for car 1
    parameter c_CAR_SPEED_1 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_2 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_3 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_4 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_5 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_6 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_7 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_8 = 1,                // Speed for car 2
    parameter c_CAR_SPEED_9 = 1,                // Speed for car 2
    parameter c_SLOW_COUNT = 2000000,           // Slowdown counter threshold
    parameter COUNTER_WIDTH = 26                // Counter width for slowdown
)(
    input i_Clk,                                // Clock input
    output reg [NUM_CARS*6-1:0] o_Car_X,        // Flattened X positions for all cars
    output reg [NUM_CARS*6-1:0] o_Car_Y,        // Flattened Y positions for all cars
);

    // Register arrays for car positions
    reg [5:0] r_Car_X [NUM_CARS-1:0];  // X positions for cars
    reg [5:0] r_Car_Y [NUM_CARS-1:0];  // Y positions for cars
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;     // Slowdown counter
    integer i;                                 // Loop variable

    // Initialize car positions
    initial begin
        r_Car_X[0] = 6'd1;   // Start positions for car 1
        r_Car_Y[0] = 6'd1;   // Y position for car 1
        r_Car_X[1] = 6'd2;  // Start positions for car 2
        r_Car_Y[1] = 6'd2;   // Y position for car 2
        r_Car_X[2] = 6'd3;  // Start positions for car 3
        r_Car_Y[2] = 6'd3;   // Y position for car 3
        r_Car_X[3] = 6'd4;  // Start positions for car 4
        r_Car_Y[3] = 6'd4;   // Y position for car 4
        r_Car_X[4] = 6'd5;  // Start positions for car 5
        r_Car_Y[4] = 6'd5;   // Y position for car 5
        r_Car_X[5] = 6'd6;  // Start positions for car 6
        r_Car_Y[5] = 6'd8;   // Y position for car 6
        r_Car_X[6] = 6'd7;  // Start positions for car 7
        r_Car_Y[6] = 6'd9;   // Y position for car 7
        r_Car_X[7] = 6'd8;  // Start positions for car 8
        r_Car_Y[7] = 6'd10;   // Y position for car 8
        r_Car_X[8] = 6'd9;  // Start positions for car 9
        r_Car_Y[8] = 6'd11;   // Y position for car 9
        r_Car_X[9] = 6'd10;  // Start positions for car 10
        r_Car_Y[9] = 6'd12;   // Y position for car 10
    end

    // Main car control logic
    always @(posedge i_Clk) begin
        // Increment the slowdown counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update both cars
        if (r_Counter >= c_SLOW_COUNT) begin
            // Reset the counter
            r_Counter <= 0;

            // Move car 1
            if (r_Car_X[0] + c_CAR_SPEED_0 < c_MAX_X) begin
                r_Car_X[0] <= r_Car_X[0] + c_CAR_SPEED_0;  // Move car 1
            end else begin
                r_Car_X[0] <= 0;  // Wrap around for car 1
            end

            // Move car 2
            if (r_Car_X[1] + c_CAR_SPEED_1 < c_MAX_X) begin
                r_Car_X[1] <= r_Car_X[1] + c_CAR_SPEED_1;  // Move car 2
            end else begin
                r_Car_X[1] <= 0;  // Wrap around for car 2
            end

            // Move car 3
            if (r_Car_X[2] + c_CAR_SPEED_2 < c_MAX_X) begin
                r_Car_X[2] <= r_Car_X[2] + c_CAR_SPEED_2;  // Move car 3
            end else begin
                r_Car_X[2] <= 0;  // Wrap around for car 3
            end

            // Move car 4
            if (r_Car_X[3] + c_CAR_SPEED_3 < c_MAX_X) begin
                r_Car_X[3] <= r_Car_X[3] + c_CAR_SPEED_3;  // Move car 4
            end else begin
                r_Car_X[3] <= 0;  // Wrap around for car 4
            end

            // Move car 5
            if (r_Car_X[4] + c_CAR_SPEED_4 < c_MAX_X) begin
                r_Car_X[4] <= r_Car_X[4] + c_CAR_SPEED_4;  // Move car 5
            end else begin
                r_Car_X[4] <= 0;  // Wrap around for car 5
            end

            // Move car 6
            if (r_Car_X[5] + c_CAR_SPEED_5 < c_MAX_X) begin
                r_Car_X[5] <= r_Car_X[5] + c_CAR_SPEED_5;  // Move car 6
            end else begin
                r_Car_X[5] <= 0;  // Wrap around for car 6
            end

            // Move car 7
            if (r_Car_X[6] + c_CAR_SPEED_6 < c_MAX_X) begin
                r_Car_X[6] <= r_Car_X[6] + c_CAR_SPEED_6;  // Move car 7
            end else begin
                r_Car_X[6] <= 0;  // Wrap around for car 7
            end

            // Move car 8
            if (r_Car_X[7] + c_CAR_SPEED_7 < c_MAX_X) begin
                r_Car_X[7] <= r_Car_X[7] + c_CAR_SPEED_7;  // Move car 8
            end else begin
                r_Car_X[7] <= 0;  // Wrap around for car 8
            end

            // Move car 9
            if (r_Car_X[8] + c_CAR_SPEED_8 < c_MAX_X) begin
                r_Car_X[8] <= r_Car_X[8] + c_CAR_SPEED_8;  // Move car 9
            end else begin
                r_Car_X[8] <= 0;  // Wrap around for car 9
            end

            // Move car 10
            if (r_Car_X[9] + c_CAR_SPEED_9 < c_MAX_X) begin
                r_Car_X[9] <= r_Car_X[9] + c_CAR_SPEED_9;  // Move car 10
            end else begin
                r_Car_X[9] <= 0;  // Wrap around for car 10
            end
        end
    end

    // Output the car positions
    always @(*) begin
        o_Car_X[0*6 +: 6] = r_Car_X[0];  // Car 1 X position
        o_Car_Y[0*6 +: 6] = r_Car_Y[0];  // Car 1 Y position
        o_Car_X[1*6 +: 6] = r_Car_X[1];  // Car 2 X position
        o_Car_Y[1*6 +: 6] = r_Car_Y[1];  // Car 2 Y position
        o_Car_X[2*6 +: 6] = r_Car_X[2];  // Car 2 X position
        o_Car_Y[2*6 +: 6] = r_Car_Y[2];  // Car 2 Y position
        o_Car_X[3*6 +: 6] = r_Car_X[3];  // Car 2 X position
        o_Car_Y[3*6 +: 6] = r_Car_Y[3];  // Car 2 Y position
        o_Car_X[4*6 +: 6] = r_Car_X[4];  // Car 2 X position
        o_Car_Y[4*6 +: 6] = r_Car_Y[4];  // Car 2 Y position
        o_Car_X[5*6 +: 6] = r_Car_X[5];  // Car 2 X position
        o_Car_Y[5*6 +: 6] = r_Car_Y[5];  // Car 2 Y position
        o_Car_X[6*6 +: 6] = r_Car_X[6];  // Car 2 X position
        o_Car_Y[6*6 +: 6] = r_Car_Y[6];  // Car 2 Y position
        o_Car_X[7*6 +: 6] = r_Car_X[7];  // Car 2 X position
        o_Car_Y[7*6 +: 6] = r_Car_Y[7];  // Car 2 Y position
        o_Car_X[8*6 +: 6] = r_Car_X[8];  // Car 2 X position
        o_Car_Y[8*6 +: 6] = r_Car_Y[8];  // Car 2 Y position
        o_Car_X[9*6 +: 6] = r_Car_X[9];  // Car 2 X position
        o_Car_Y[9*6 +: 6] = r_Car_Y[9];  // Car 2 Y position
    end

endmodule
