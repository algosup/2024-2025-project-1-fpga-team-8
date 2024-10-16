module car_ctrl #(
/// This module is responsible for controlling the movement of the car in the game.
    /// Parameters
        // Maximum X position (grid width)
        parameter c_MAX_X = 20,
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
