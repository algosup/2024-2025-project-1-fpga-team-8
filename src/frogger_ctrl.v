module frogger_ctrl(
/// This module is responsible for controlling the movement of the frogger character in the game.
    /// Inputs
        // Clock input
        input            i_Clk,
        // Current score
        input [6:0]      i_Score,
        // Up movement switch
        input            i_Up_Mvt,
        // Down movement switch
        input            i_Down_Mvt,
        // Left movement switch
        input            i_Left_Mvt,
        // Right movement switch
        input            i_Right_Mvt,
        // Game active signal
        input            i_Game_Active,
        // Collision signal
        input            i_Collided,
        // Column count divider
        input [5:0]      i_Col_Count_Div,
        // Row count divider
        input [5:0]      i_Row_Count_Div,
        // Bitmap data input
        input [3:0]      i_Bitmap_Data,
        // Frogger is on a log signal
        input            i_On_Log,

    /// Outputs
        // X position of the frogger
        output reg [5:0] o_Frogger_X,
        // Y position of the frogger
        output reg [5:0] o_Frogger_Y,
        // Score output
        output reg [6:0] o_Score
);

    /// Internal signals
        // Up movement switch
        reg r_Switch_1;
        // Down movement switch
        reg r_Switch_2;
        // Left movement switch
        reg r_Switch_3;
        // Right movement switch
        reg r_Switch_4;

    // Parameters and registers for log movement
        parameter c_LOG_SLOW_COUNT = 39000000;
        parameter c_FROGGER_ORIG_X = 10;
        parameter c_FROGGER_ORIG_Y = 14;
        reg [31:0] r_Log_Movement_Counter = 0;

    /// Initialize starting position of Frogger
    initial begin
        // Initial column
        o_Frogger_X = 10;
        // Initial row (bottom of the screen)
        o_Frogger_Y = 12;
        // Initial score
        o_Score = 0;
    end

    /// Main Frogger control logic
    always @(posedge i_Clk) begin

        r_Switch_1 <= i_Up_Mvt;
        r_Switch_2 <= i_Down_Mvt;
        r_Switch_3 <= i_Left_Mvt;
        r_Switch_4 <= i_Right_Mvt;

        if (i_Game_Active) begin

        /// Handle Frogger's movements
            // Move up
            if (i_Up_Mvt == 1'b1 && r_Switch_1 == 1'b0) begin
                if (o_Frogger_Y > 0) begin
                    o_Frogger_Y <= o_Frogger_Y - 1;
                end
            end

            // Move down
            else if (i_Down_Mvt == 1'b1 && r_Switch_2 == 1'b0) begin
                if (o_Frogger_Y < 14) begin
                    o_Frogger_Y <= o_Frogger_Y + 1;
                end
            end

            // Move left
            else if (i_Left_Mvt == 1'b1 && r_Switch_3 == 1'b0) begin
                if (o_Frogger_X > 0) begin
                    o_Frogger_X <= o_Frogger_X - 1;
                end
            end

            // Move right
            else if (i_Right_Mvt == 1'b1 && r_Switch_4 == 1'b0) begin
                if (o_Frogger_X < 13) begin
                    o_Frogger_X <= o_Frogger_X + 1;
                end
            end

            // Reset Frogger position if a collision occurs
            if (i_Collided) begin
                o_Frogger_X <= 10;
                o_Frogger_Y <= 12;
                // TODO: Add all the death logic
            end

            /// Check if Frogger reached the top row
            if (o_Frogger_Y == 0) begin

                // Check if current position is a lily pad
                if (i_Bitmap_Data == 4) begin
                    o_Score <= i_Score + 1;  // Increment score if on a lily pad
                end

                // Reset Frogger to start position
                o_Frogger_X <= 10;
                o_Frogger_Y <= 14;
            end

            // Move frog with log if on log
            if (i_On_Log) begin
                r_Log_Movement_Counter <= r_Log_Movement_Counter + 1;
                if (r_Log_Movement_Counter >= c_LOG_SLOW_COUNT) begin
                    r_Log_Movement_Counter <= 0;
                    // Move frog left with log
                    if (o_Frogger_X > 0)
                        o_Frogger_X <= o_Frogger_X - 1;
                    else
                        o_Frogger_X <= c_GAME_WIDTH - 1; // Wrap around
                        
                end
            end else begin
                r_Log_Movement_Counter <= 0; // Reset counter if not on log
            end

            // Handle drowning if in water and not on log
            if (i_Bitmap_Data == 4'd2 && !i_On_Log) begin
                o_Frogger_X <= c_FROGGER_ORIG_X;
                o_Frogger_Y <= c_FROGGER_ORIG_Y;
                // Decrement lives or other penalty
            end


        end // Game active

    end // Main Frogger control logic

endmodule