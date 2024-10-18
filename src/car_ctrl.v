/*
module car_ctrl #(
/// This module is responsible for controlling the movement of the car in the game.
    /// Parameters
        // Maximum X position (grid width)
        parameter c_MAX_X = 40,
        // How much to move the car in one step
        parameter c_CAR_SPEED = 1,
        // Slow down counter threshold (adjust based on clock speed)
        parameter c_SLOW_COUNT = 4000000,
        // Initial X position
        parameter c_INIT_X = 0,
        // Initial Y position
        parameter c_INIT_Y = 13,
        // Counter width
        parameter COUNTER_WIDTH = 26,
)(
    /// Inputs
        // Clock input
        input i_Clk,
        // Column count divider
        input [5:0] i_Col_Count_Div,
        // Row count divider
        input [5:0] i_Row_Count_Div,

    /// Outputs
        // X position of the car
        output reg [5:0] o_Car_X,
        // Y position of the car
        output reg [5:0] o_Car_Y
);
// test

    /// Internal signals
        // Counter for slowing down the car movement
        reg [COUNTER_WIDTH-1:0] r_Counter = 0;      // 32-bit counter for slowing down the car movement

    /// Initialize starting position of the car
    initial begin
        o_Car_X = c_INIT_Y;  // Start position
        o_Car_Y = c_INIT_Y; // Starting Y position
    end

    /// Main car control logic
    always @(posedge i_Clk) begin

        // Increment the slow down counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update the car position
        if (r_Counter >= c_SLOW_COUNT) begin
            
            // Reset the counter
            r_Counter <= 0;

            // Update car's X position (move car)
            if (o_Car_X < c_MAX_X - 1) begin
                o_Car_X <= (o_Car_X + c_CAR_SPEED);
            end

            // Wrap around when the car reaches the end of the grid
            else begin
                o_Car_X <= 0;
            end
        end
    end

endmodule
*/


// module multi_car_ctrl #(
//     parameter NUM_CARS = 4,                    // Number of cars
//     parameter c_MAX_X = 40,                    // Maximum X position (grid width)
//     parameter [NUM_CARS-1:0] c_CAR_SPEED = {1, 2, 1, 3}, // Speed for each car
//     parameter c_SLOW_COUNT = 4000000,          // Slowdown counter threshold
//     parameter COUNTER_WIDTH = 26               // Counter width for slowdown
// )(
//     input i_Clk,                               // Clock input
//     input [NUM_CARS-1:0][5:0] i_Init_X,        // Initial X positions for each car
//     input [NUM_CARS-1:0][5:0] i_Init_Y,        // Initial Y positions for each car (lanes)
//     output reg [NUM_CARS-1:0][5:0] o_Car_X,    // X positions for all cars
//     output reg [NUM_CARS-1:0][5:0] o_Car_Y     // Y positions for all cars (lanes)
// );

//     // Internal signals
//     reg [COUNTER_WIDTH-1:0] r_Counter = 0;  // Shared slowdown counter
//     integer i;  // Loop variable

//     // Initialize starting positions of all cars
//     initial begin
//         for (i = 0; i < NUM_CARS; i = i + 1) begin
//             o_Car_X[i] = i_Init_X[i];
//             o_Car_Y[i] = i_Init_Y[i];  // Each car gets a fixed Y position (lane)
//         end
//     end

//     // Main car control logic
//     always @(posedge i_Clk) begin
//         // Increment the slow down counter
//         r_Counter <= r_Counter + 1;

//         // When the counter reaches the threshold, update all car positions
//         if (r_Counter >= c_SLOW_COUNT) begin
//             // Reset the counter
//             r_Counter <= 0;

//             // Update each car's position based on its speed
//             for (i = 0; i < NUM_CARS; i = i + 1) begin
//                 if (o_Car_X[i] < c_MAX_X - 1) begin
//                     o_Car_X[i] <= o_Car_X[i] + c_CAR_SPEED[i];  // Move car based on its individual speed
//                 end
//                 else begin
//                     o_Car_X[i] <= 0;  // Wrap around when reaching the end
//                 end
//             end
//         end
//     end

// endmodule

/*
module multi_car_ctrl #(
    parameter NUM_CARS = 4,                    // Number of cars
    parameter c_MAX_X = 40,                    // Maximum X position (grid width)
    parameter [NUM_CARS-1:0] c_CAR_SPEED = {1, 2, 1, 3}, // Speed for each car
    parameter c_SLOW_COUNT = 4000000,          // Slowdown counter threshold
    parameter COUNTER_WIDTH = 26               // Counter width for slowdown
)(
    input i_Clk,                               // Clock input
    input [NUM_CARS*6-1:0] i_Init_X,           // Flattened initial X positions for all cars
    input [NUM_CARS*6-1:0] i_Init_Y,           // Flattened initial Y positions for all cars (lanes)
    output reg [NUM_CARS*6-1:0] o_Car_X,       // Flattened X positions for all cars
    output reg [NUM_CARS*6-1:0] o_Car_Y        // Flattened Y positions for all cars (lanes)
);

    // Internal signals
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;  // Shared slowdown counter
    integer i;  // Loop variable

    // Main car control logic
    always @(posedge i_Clk) begin
        // Increment the slow down counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update all car positions
        if (r_Counter >= c_SLOW_COUNT) begin
            // Reset the counter
            r_Counter <= 0;

            // Update each car's position based on its speed
            for (i = 0; i < NUM_CARS; i = i + 1) begin
                if (o_Car_X[i*6 +: 6] < c_MAX_X - 1) begin
                    o_Car_X[i*6 +: 6] <= o_Car_X[i*6 +: 6] + c_CAR_SPEED[i];  // Move car based on its individual speed
                end
                else begin
                    o_Car_X[i*6 +: 6] <= 0;  // Wrap around when reaching the end
                end
            end
        end
    end

    // Initialize car positions
    always @(posedge i_Clk) begin
        if (r_Counter == 0) begin
            for (i = 0; i < NUM_CARS; i = i + 1) begin
                o_Car_X[i*6 +: 6] <= i_Init_X[i*6 +: 6];
                o_Car_Y[i*6 +: 6] <= i_Init_Y[i*6 +: 6];
            end
        end
    end

endmodule
*/

module multi_car_ctrl #(
    parameter NUM_CARS = 10,                    // Number of cars
    parameter c_MAX_X = 40,                    // Maximum X position (grid width)
    parameter [NUM_CARS-1:0] c_CAR_SPEED = {1, 2, 1, 3}, // Speed for each car
    parameter c_SLOW_COUNT = 2000000,          // Reduced Slowdown counter threshold
    parameter COUNTER_WIDTH = 26               // Counter width for slowdown
)(
    input i_Clk,                               // Clock input
    input [NUM_CARS*6-1:0] i_Init_X,           // Flattened initial X positions for all cars
    input [NUM_CARS*6-1:0] i_Init_Y,           // Flattened initial Y positions for all cars (lanes)
    output reg [NUM_CARS*6-1:0] o_Car_X,       // Flattened X positions for all cars
    output reg [NUM_CARS*6-1:0] o_Car_Y        // Flattened Y positions for all cars (lanes)
);

    // Internal signals
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;  // Shared slowdown counter
    reg initialized = 0;  // Flag to ensure initialization happens only once
    integer i;  // Loop variable

    // Main car control logic
    always @(posedge i_Clk) begin
        // Initialize car positions only once
        if (!initialized) begin
            for (i = 0; i < NUM_CARS; i = i + 1) begin
                o_Car_X[i*6 +: 6] <= i_Init_X[i*6 +: 6];
                o_Car_Y[i*6 +: 6] <= i_Init_Y[i*6 +: 6];
            end
            initialized <= 1;  // Set flag to prevent reinitialization
        end

        // Increment the slow down counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update all car positions
        if (r_Counter >= c_SLOW_COUNT) begin
            // Reset the counter
            r_Counter <= 0;

            // Update each car's position based on its speed
            for (i = 0; i < NUM_CARS; i = i + 1) begin
                if (o_Car_X[i*6 +: 6] + c_CAR_SPEED[i] < c_MAX_X) begin
                    o_Car_X[i*6 +: 6] <= o_Car_X[i*6 +: 6] + c_CAR_SPEED[i];  // Move car based on its speed
                end
                else begin
                    o_Car_X[i*6 +: 6] <= 0;  // Wrap around when reaching or exceeding the end
                end
            end
        end
    end

endmodule
