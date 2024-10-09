module floating_ctrl #(
/// This module is responsible for controlling the movement of the floating element in the game.
    /// Parameters
        // Maximum X position (grid width)
        parameter c_MIN_X = 0,
        // How much to move the floating element in one step
        parameter c_FLOATING_SPEED = 1,
        // Slow down counter threshold (adjust based on clock speed)
        parameter c_SLOW_COUNT = 4000000,
        // Initial X position
        parameter c_INIT_X = 13,
        // Initial Y position
        parameter c_INIT_Y = 5,
)(
    /// Inputs
        // Clock input
        input i_Clk,
        // Column count divider
        input [5:0] i_Col_Count_Div,
        // Row count divider
        input [5:0] i_Row_Count_Div,

    /// Outputs
        // X position of the floating element
        output reg [5:0] o_Floating_X,
        // Y position of the floating element
        output reg [5:0] o_Floating_Y
);

    /// Internal signals
        // 32-bit counter for slowing down the floating element movement
        reg [31:0] r_Counter = 0;

    /// Initialize starting position of the floating element
    initial begin

        // Start X position
        o_Floating_X = c_INIT_X;
        // Starting Y position
        o_Floating_Y = c_INIT_Y;
    end

    /// Main floating element control logic
    always @(posedge i_Clk) begin

        // Increment the slow down counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update the floating element position
        if (r_Counter >= c_SLOW_COUNT) begin
            
            // Reset the counter
            r_Counter <= 0;

            // Update floating element's X position (move floating element)
            if (o_Floating_X > c_MIN_X) begin
                o_Floating_X <= (o_Floating_X - c_FLOATING_SPEED);
            end

            // Wrap around when the floating element reaches the end of the grid
            else begin
                o_Floating_X <= 13;
            end

        end
    end

endmodule
