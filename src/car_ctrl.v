module multi_car_ctrl#(
    parameter NUM_CARS = 10,                    // Number of cars
    parameter c_MAX_X = 20,                     // Maximum X position
    parameter [NUM_CARS*6-1:0] c_CAR_SPEED = {6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1}, // Speeds for each car
    parameter [NUM_CARS-1:0] c_CAR_DIRECTION = {10'b1111111111}, // Directions (1 = right, 0 = left) for each car
    parameter c_SLOW_COUNT = 2000000,           // Slowdown counter threshold
    parameter COUNTER_WIDTH = 26                // Counter width for slowdown
)(
    input i_Clk,                                // Clock input
    output reg [NUM_CARS*6-1:0] o_Car_X,        // Flattened X positions for all cars
    output reg [NUM_CARS*6-1:0] o_Car_Y         // Flattened Y positions for all cars
);

    // Register arrays for car positions
    reg [5:0] r_Car_X [NUM_CARS-1:0];           // X positions for cars
    reg [5:0] r_Car_Y [NUM_CARS-1:0];           // Y positions for cars
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;      // Slowdown counter
    integer i;                                  // Loop variable

    // Initialize car positions
    initial begin
        r_Car_X[0] = 6'd1;   // Start positions for car 1
        r_Car_Y[0] = 6'd1;   // Y position for car 1
        r_Car_X[1] = 6'd2;   // Start positions for car 2
        r_Car_Y[1] = 6'd2;   // Y position for car 2
        r_Car_X[2] = 6'd3;   // Start positions for car 3
        r_Car_Y[2] = 6'd3;   // Y position for car 3
        r_Car_X[3] = 6'd4;   // Start positions for car 4
        r_Car_Y[3] = 6'd4;   // Y position for car 4
        r_Car_X[4] = 6'd5;   // Start positions for car 5
        r_Car_Y[4] = 6'd5;   // Y position for car 5
        r_Car_X[5] = 6'd6;   // Start positions for car 6
        r_Car_Y[5] = 6'd8;   // Y position for car 6
        r_Car_X[6] = 6'd7;   // Start positions for car 7
        r_Car_Y[6] = 6'd9;   // Y position for car 7
        r_Car_X[7] = 6'd8;   // Start positions for car 8
        r_Car_Y[7] = 6'd10;  // Y position for car 8
        r_Car_X[8] = 6'd9;   // Start positions for car 9
        r_Car_Y[8] = 6'd11;  // Y position for car 9
        r_Car_X[9] = 6'd10;  // Start positions for car 10
        r_Car_Y[9] = 6'd12;  // Y position for car 10
    end

    // Main car control logic
    always @(posedge i_Clk) begin
        // Increment the slowdown counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update the cars
        if (r_Counter >= c_SLOW_COUNT) begin
            // Reset the counter
            r_Counter <= 0;

            // Loop through all cars and move them based on their respective speeds and directions
            for (i = 0; i < NUM_CARS; i = i + 1) begin
                if (c_CAR_DIRECTION[i] == 1'b1) begin
                    // Move right
                    if (r_Car_X[i] + c_CAR_SPEED[i*6 +: 6] < c_MAX_X) begin
                        r_Car_X[i] <= r_Car_X[i] + c_CAR_SPEED[i*6 +: 6];
                    end else begin
                        r_Car_X[i] <= 0;  // Wrap around for right-moving cars
                    end
                end else begin
                    // Move left
                    if (r_Car_X[i] >= c_CAR_SPEED[i*6 +: 6]) begin
                        r_Car_X[i] <= r_Car_X[i] - c_CAR_SPEED[i*6 +: 6];
                    end else begin
                        r_Car_X[i] <= c_MAX_X;  // Wrap around for left-moving cars
                    end
                end
            end
        end
    end

    // Output the car positions
    always @(*) begin
        for (i = 0; i < NUM_CARS; i = i + 1) begin
            o_Car_X[i*6 +: 6] = r_Car_X[i];  // Car `i` X position
            o_Car_Y[i*6 +: 6] = r_Car_Y[i];  // Car `i` Y position
        end
    end

endmodule

