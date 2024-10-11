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
        // Car 2 X position
        input [5:0] i_Car_X_2, i_Car_Y_2,
        // Car 3 X position
        input [5:0] i_Car_X_3, i_Car_Y_3,
        // Car 4 X position
        input [5:0] i_Car_X_4, i_Car_Y_4,
        // Car 5 X position
        input [5:0] i_Car_X_5, i_Car_Y_5,
        // Log 1 X position
        input [5:0] i_Log_X_1, i_Log_Y_1,
        // Log 2 X position
        input [5:0] i_Log_X_2, i_Log_Y_2,
        // Log 3 X position
        input [5:0] i_Log_X_3, i_Log_Y_3,

    /// Outputs
        // Collision with cars signal
        output reg o_Collided,
        // Collision with logs signal
        output reg o_On_Log
);
    /// Initialize collision signals
    initial begin
        o_Collided = 0;
        o_On_Log = 0;
    end

       // Main collision detection logic
    always @(posedge i_Clk) begin
        // Default to no collision
        o_Collided <= 0;
        o_On_Log <= 0;

        // Handle collisions with cars
        if ((i_Frogger_Y == i_Car_Y_1 && (i_Frogger_X + 1 == i_Car_X_1 || i_Frogger_X == i_Car_X_1 + 1)) ||
            (i_Frogger_Y == i_Car_Y_2 && (i_Frogger_X + 1 == i_Car_X_2 || i_Frogger_X == i_Car_X_2 + 1)) ||
            (i_Frogger_Y == i_Car_Y_3 && (i_Frogger_X + 1 == i_Car_X_3 || i_Frogger_X == i_Car_X_3 + 1)) ||
            (i_Frogger_Y == i_Car_Y_4 && (i_Frogger_X + 1 == i_Car_X_4 || i_Frogger_X == i_Car_X_4 + 1)) ||
            (i_Frogger_Y == i_Car_Y_5 && (i_Frogger_X + 1 == i_Car_X_5 || i_Frogger_X == i_Car_X_5 + 1)))
            
            begin
                o_Collided <= 1;
            end

        // Handle collision with Logs
        /*
        else if ((i_Frogger_X == i_Log_X_1 && i_Frogger_Y == i_Log_Y_1) ||
                (i_Frogger_X == i_Log_X_2 && i_Frogger_Y == i_Log_Y_2) ||
                (i_Frogger_X == i_Log_X_3 && i_Frogger_Y == i_Log_Y_3))
        */
        // Three tile wide variant
        else if ((i_Frogger_Y == i_Log_Y_1 && (i_Frogger_X == i_Log_X_1 || i_Frogger_X == i_Log_X_1 - 1 || i_Frogger_X == i_Log_X_1 - 2)) ||
        (i_Frogger_Y == i_Log_Y_2 && (i_Frogger_X == i_Log_X_2 || i_Frogger_X == i_Log_X_2 - 1 || i_Frogger_X == i_Log_X_2 - 2)) ||
        (i_Frogger_Y == i_Log_Y_3 && (i_Frogger_X == i_Log_X_3 || i_Frogger_X == i_Log_X_3 - 1 || i_Frogger_X == i_Log_X_3 - 2)))
                 
                begin
                    o_On_Log <= 1;
                end

        // No collision
        else
        
            begin
                o_Collided <= 0;
                o_On_Log <= 0;
            end
    end

endmodule