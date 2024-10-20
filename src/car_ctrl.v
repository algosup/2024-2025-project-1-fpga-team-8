module multi_car_ctrl #(
    parameter c_MAX_X = 20,                     // Maximum X position
    parameter [59:0] c_CAR_SPEED = {6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1},  // Speeds for 10 cars
    parameter c_SLOW_COUNT = 700000,            // Slowdown counter threshold
    parameter COUNTER_WIDTH = 21                // Counter width for slowdown
)(
    input i_Clk,                                // Clock input
    output reg [59:0] o_Car_X,                  // Flattened X positions for 10 cars (10 * 6 bits)
    output reg [59:0] o_Car_Y                   // Flattened Y positions for 10 cars (10 * 6 bits)
);

    // Register arrays for car positions (10 cars)
    reg [4:0] r_Car_X [9:0];  // 10 cars with 5-bit positions
    reg [4:0] r_Car_Y [9:0];  // 10 cars with 5-bit positions
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;
    reg [3:0] current_car = 0;  // Counter to keep track of which car to update
    integer i;  // Declare the loop variable outside the loop

    // Initialize car positions
    initial begin
        // Lane 12 (Both cars go right, so use even indices)
        r_Car_X[0] = 6'd0;    // Car 1 (even index, goes right)
        r_Car_Y[0] = 6'd12;
        r_Car_X[2] = 6'd6;    // Car 2 (even index, goes right)
        r_Car_Y[2] = 6'd12;

        // Lane 11 (Both cars go left, so use odd indices)
        r_Car_X[1] = 6'd24;   // Car 1 (odd index, goes left)
        r_Car_Y[1] = 6'd11;
        r_Car_X[3] = 6'd20;   // Car 2 (odd index, goes left)
        r_Car_Y[3] = 6'd11;
        r_Car_X[9] = 6'd16;   // Extra car (goes right)
        r_Car_Y[9] = 6'd11;

        // Lane 10 (Both cars go right, so use even indices)
        r_Car_X[4] = 6'd3;    // Car 1 (even index, goes right)
        r_Car_Y[4] = 6'd10;
        r_Car_X[6] = 6'd9;    // Car 2 (even index, goes right)
        r_Car_Y[6] = 6'd10;

        // Lane 9 (Both cars go left, so use odd indices)
        r_Car_X[5] = 6'd4;    // Car 1 (odd index, goes left)
        r_Car_Y[5] = 6'd9;
        r_Car_X[7] = 6'd18;   // Car 2 (odd index, goes left)
        r_Car_Y[7] = 6'd9;

        // Lane 8 (Both cars go right, so use even indices)
        r_Car_X[8] = 6'd4;    // Car 1 (even index, goes right)
        r_Car_Y[8] = 6'd8;
        r_Car_X[10] = 6'd11;  // Car 2 (even index, goes right)
        r_Car_Y[10] = 6'd8;
    end

    // Main car control logic
    always @(posedge i_Clk) begin
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update one car at a time
        if (r_Counter >= c_SLOW_COUNT) begin
            r_Counter <= 0;

            // Odd lanes (right movement) and even lanes (left movement)
            if (current_car % 2 == 0) begin
                // Odd lanes: Move right
                if (r_Car_X[current_car] + c_CAR_SPEED[current_car*6 +: 6] < c_MAX_X) begin
                    r_Car_X[current_car] <= r_Car_X[current_car] + c_CAR_SPEED[current_car*6 +: 6];
                end else begin
                    r_Car_X[current_car] <= 0;  // Wrap around for right-moving cars
                end
            end else begin
                // Even lanes: Move left
                if (r_Car_X[current_car] >= c_CAR_SPEED[current_car*6 +: 6]) begin
                    r_Car_X[current_car] <= r_Car_X[current_car] - c_CAR_SPEED[current_car*6 +: 6];
                end else begin
                    r_Car_X[current_car] <= c_MAX_X;  // Wrap around for left-moving cars
                end
            end

            // Move to the next car
            current_car <= (current_car + 1) % 10;  // Fixed 10 cars
        end
    end

    // Output the car positions
    always @(*) begin
        for (i = 0; i < 10; i = i + 1) begin
            o_Car_X[i*6 +: 6] = r_Car_X[i];  // Car `i` X position
            o_Car_Y[i*6 +: 6] = r_Car_Y[i];  // Car `i` Y position
        end
    end

endmodule
