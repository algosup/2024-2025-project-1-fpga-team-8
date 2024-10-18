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
    parameter NUM_CARS = 2,                    // Test with 2 cars
    parameter c_MAX_X = 20,                    // Smaller grid for testing
    parameter [NUM_CARS-1:0] c_CAR_SPEED = {1, 1}, // Same speed for both cars
    parameter c_SLOW_COUNT = 2000000,          // Slowdown counter threshold
    parameter COUNTER_WIDTH = 26               // Counter width for slowdown
)(
    input i_Clk,                               // Clock input
    output reg [NUM_CARS*6-1:0] o_Car_X,       // Flattened X positions for all cars
    output reg [NUM_CARS*6-1:0] o_Car_Y        // Flattened Y positions for all cars (lanes)
);

    // Register arrays for car positions
    reg [5:0] r_Car_X [NUM_CARS-1:0];  // X positions for cars
    reg [5:0] r_Car_Y [NUM_CARS-1:0];  // Y positions for cars
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;     // Slowdown counter
    integer i;                                 // Loop variable

    // Initialize car positions
    initial begin
        r_Car_X[0] = 6'd4;   // Start positions for car 1
        r_Car_X[1] = 6'd10;  // Start positions for car 2
        r_Car_Y[0] = 6'd4;   // Same Y position for both cars for simplicity
        r_Car_Y[1] = 6'd5;
    end

    // Main car control logic
    always @(posedge i_Clk) begin
        // Increment the slowdown counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update the car positions
        if (r_Counter >= c_SLOW_COUNT) begin
            // Reset the counter
            r_Counter <= 0;

            // Update car 1's position
            if (r_Car_X[0] + c_CAR_SPEED[0] < c_MAX_X) begin
                r_Car_X[0] <= r_Car_X[0] + c_CAR_SPEED[0];  // Move car 1
            end else begin
                r_Car_X[0] <= 0;  // Wrap around for car 1
            end

            // Update car 2's position
            if (r_Car_X[1] + c_CAR_SPEED[1] < c_MAX_X) begin
                r_Car_X[1] <= r_Car_X[1] + c_CAR_SPEED[1];  // Move car 2
            end else begin
                r_Car_X[1] <= 0;  // Wrap around for car 2
            end
        end
    end

    // Output the car positions
    always @(*) begin
        o_Car_X[0*6 +: 6] = r_Car_X[0];  // Car 1 X position
        o_Car_X[1*6 +: 6] = r_Car_X[1];  // Car 2 X position
        o_Car_Y[0*6 +: 6] = r_Car_Y[0];  // Car 1 Y position
        o_Car_Y[1*6 +: 6] = r_Car_Y[1];  // Car 2 Y position
    end

endmodule
