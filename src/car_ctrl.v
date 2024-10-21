module multi_car_ctrl #(
    parameter COUNTER_WIDTH = 32  // Counter width for slowdown
)(
    input i_Clk,                                           // Clock input
    output reg [59:0] o_Car_X,                             // Flattened X positions for 10 cars (10 * 6 bits)
    output reg [59:0] o_Car_Y                              // Flattened Y positions for 10 cars (10 * 6 bits)
);

    // Precomputed slowdown counts for each lane (scaled to match the speeds)
    localparam [COUNTER_WIDTH-1:0] LANE_12_SLOW_COUNT = 32'd11666430;  // Lane 12 (39 million)
    localparam [COUNTER_WIDTH-1:0] LANE_11_SLOW_COUNT = 32'd9574300;   // Lane 11 (32 million)
    localparam [COUNTER_WIDTH-1:0] LANE_10_SLOW_COUNT = 32'd8080340;   // Lane 10 (27 million)
    localparam [COUNTER_WIDTH-1:0] LANE_9_SLOW_COUNT  = 32'd5386430;   // Lane 9  (18 million)
    localparam [COUNTER_WIDTH-1:0] LANE_8_SLOW_COUNT  = 32'd4190000;   // Lane 8  (14 million)

    // Register arrays for car positions (10 cars)
    reg [4:0] r_Car_X [9:0];                              // 10 cars with 5-bit positions
    reg [4:0] r_Car_Y [9:0];                              // 10 cars with 5-bit positions
    reg [COUNTER_WIDTH-1:0] r_Counter[4:0];               // Separate counters for each lane

    integer i;

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
        // Lane 12 (slowest lane)
        r_Counter[0] <= r_Counter[0] + 1;
        if (r_Counter[0] >= LANE_12_SLOW_COUNT) begin
            r_Counter[0] <= 0;
            if (r_Car_X[0] + 1 < 20)
                r_Car_X[0] <= r_Car_X[0] + 1;
            else
                r_Car_X[0] <= 0;
            if (r_Car_X[2] + 1 < 20)
                r_Car_X[2] <= r_Car_X[2] + 1;
            else
                r_Car_X[2] <= 0;
        end

        // Lane 11
        r_Counter[1] <= r_Counter[1] + 1;
        if (r_Counter[1] >= LANE_11_SLOW_COUNT) begin
            r_Counter[1] <= 0;
            if (r_Car_X[1] >= 1)
                r_Car_X[1] <= r_Car_X[1] - 1;
            else
                r_Car_X[1] <= 20;
            if (r_Car_X[3] >= 1)
                r_Car_X[3] <= r_Car_X[3] - 1;
            else
                r_Car_X[3] <= 20;
        end

        // Lane 10
        r_Counter[2] <= r_Counter[2] + 1;
        if (r_Counter[2] >= LANE_10_SLOW_COUNT) begin
            r_Counter[2] <= 0;
            if (r_Car_X[4] + 1 < 20)
                r_Car_X[4] <= r_Car_X[4] + 1;
            else
                r_Car_X[4] <= 0;
            if (r_Car_X[6] + 1 < 20)
                r_Car_X[6] <= r_Car_X[6] + 1;
            else
                r_Car_X[6] <= 0;
        end

        // Lane 9
        r_Counter[3] <= r_Counter[3] + 1;
        if (r_Counter[3] >= LANE_9_SLOW_COUNT) begin
            r_Counter[3] <= 0;
            if (r_Car_X[5] >= 1)
                r_Car_X[5] <= r_Car_X[5] - 1;
            else
                r_Car_X[5] <= 20;
            if (r_Car_X[7] >= 1)
                r_Car_X[7] <= r_Car_X[7] - 1;
            else
                r_Car_X[7] <= 20;
        end

        // Lane 8
        r_Counter[4] <= r_Counter[4] + 1;
        if (r_Counter[4] >= LANE_8_SLOW_COUNT) begin
            r_Counter[4] <= 0;
            if (r_Car_X[8] + 1 < 20)
                r_Car_X[8] <= r_Car_X[8] + 1;
            else
                r_Car_X[8] <= 0;
            if (r_Car_X[10] + 1 < 20)
                r_Car_X[10] <= r_Car_X[10] + 1;
            else
                r_Car_X[10] <= 0;
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
