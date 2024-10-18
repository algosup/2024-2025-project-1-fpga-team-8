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
)(
    /// Inputs
        // Clock input
        input i_Clk,
        // Column count divider
        input [5:0] i_Col_Count_Div,
        // Row count divider
        input [5:0] i_Row_Count_Div,

         input [3:0]      i_Sprites_Data,

    /// Outputs
        // X position of the car
        output reg [5:0] o_Car_X,
        // Y position of the car
        output reg [5:0] o_Car_Y
);

    /// Internal signals
        // Counter for slowing down the car movement
        reg [31:0] r_Counter = 0;      // 32-bit counter for slowing down the car movement

    // Initialize starting position of the car (horizontal movement only)
initial begin
    o_Car_X = c_INIT_X;  // Start at the initial X position
    o_Car_Y = c_INIT_Y;  // Fixed Y position
end

// In your car movement logic, ensure only X moves and Y stays fixed
always @(posedge i_Clk) begin
    // Increment the slow down counter
    r_Counter <= r_Counter + 1;

    // When the counter reaches the threshold, update the car position
    if (r_Counter >= c_SLOW_COUNT) begin
        // Reset the counter
        r_Counter <= 0;

        // Update car's X position (move horizontally)
        if (o_Car_X < c_MAX_X - 1) begin
            o_Car_X <= (o_Car_X + c_CAR_SPEED);
        end
        else begin
            // Wrap around when the car reaches the end of the grid
            o_Car_X <= 0;
        end
    end
end

endmodule
