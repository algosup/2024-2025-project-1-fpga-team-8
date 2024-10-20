module multi_car_ctrl #(
    parameter NUM_CARS = 10,                    // Number of cars
    parameter c_MAX_X = 20,                     // Maximum X position
    parameter [NUM_CARS*6-1:0] c_CAR_SPEED = {6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1, 6'd1},  // Speeds for each car
    parameter c_SLOW_COUNT = 700000,           // Slowdown counter threshold
    parameter COUNTER_WIDTH = 21               // Counter width for slowdown
)(
    input i_Clk,                                // Clock input
    output reg [NUM_CARS*6-1:0] o_Car_X,        // Flattened X positions for all cars
    output reg [NUM_CARS*6-1:0] o_Car_Y         // Flattened Y positions for all cars
);

    // Register arrays for car positions
    reg [4:0] r_Car_X [NUM_CARS-1:0];
    reg [4:0] r_Car_Y [NUM_CARS-1:0];
    reg [COUNTER_WIDTH-1:0] r_Counter = 0;
    reg [3:0] current_car = 0;  // Counter to keep track of which car to update
    integer i;  // Declare the loop variable outside the loop

    // Initialize car positions
    initial begin
        r_Car_X[0] = 6'd1;
        r_Car_Y[0] = 6'd1;
        r_Car_X[1] = 6'd2;
        r_Car_Y[1] = 6'd2;
        r_Car_X[2] = 6'd3;
        r_Car_Y[2] = 6'd3;
        r_Car_X[3] = 6'd4;
        r_Car_Y[3] = 6'd4;
        r_Car_X[4] = 6'd5;
        r_Car_Y[4] = 6'd5;
        r_Car_X[5] = 6'd6;
        r_Car_Y[5] = 6'd8;
        r_Car_X[6] = 6'd7;
        r_Car_Y[6] = 6'd9;
        r_Car_X[7] = 6'd8;
        r_Car_Y[7] = 6'd10;
        r_Car_X[8] = 6'd9;
        r_Car_Y[8] = 6'd11;
        r_Car_X[9] = 6'd10;
        r_Car_Y[9] = 6'd12;
    end

    // Main car control logic
    always @(posedge i_Clk) begin
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update one car at a time
        if (r_Counter >= c_SLOW_COUNT) begin
            r_Counter <= 0;

            // Odd lanes (right movement) and even lanes (left movement)
            if (current_car % 2 == 1) begin
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
            current_car <= (current_car + 1) % NUM_CARS;
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
