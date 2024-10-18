module frogger_collisions (
/// This Module is responsible for detecting collisions between the frogger, the cars and the logs.
    /// Inputs
        // Clock input
        input i_Clk,
        // Frogger X position
        input [5:0] i_Frogger_X,
        // Frogger Y position
        input [5:0] i_Frogger_Y,
        // Frogger original X position
        input [5:0] i_Frogger_Orig_x,
        // Frogger original Y position
        input [5:0] i_Frogger_Orig_y,
        // Car 1 X position
        input [5:0] i_Car_X_1, i_Car_Y_1,
 
    /// Outputs
        // Collision with cars signal
        output reg o_Collided,
        // Collision with logs signal
);

    // Parameter for game width (number of tiles in X direction)
    parameter c_GAME_WIDTH = 20;

    // Function to handle coordinate wrapping
    function [5:0] subtract_modulo;
        input [5:0] x;
        input [5:0] y;
        begin
            if (x >= y)
                subtract_modulo = x - y;
            else
                subtract_modulo = c_GAME_WIDTH - (y - x);
        end
    endfunction

       // Main collision detection logic
    always @(*) begin
        // Default to no collision
        o_Collided = 0;

        // Handle collisions with cars
        if ((i_Frogger_Y == i_Car_Y_1 && (i_Frogger_X + 1 == i_Car_X_1 || i_Frogger_X == i_Car_X_1 + 1)))
            
            begin
                o_Collided <= 1;
            end
    
    end

endmodule