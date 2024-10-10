module frogger_ctrl(
    input            i_Clk,
    input [6:0]      i_Score,
    input            i_Up_Mvt,
    input            i_Down_Mvt,
    input            i_Left_Mvt,
    input            i_Right_Mvt,
    input            i_Game_Active, // Game Active Signal
    input            i_Collided,
    input [5:0]      i_Col_Count_Div,
    input [5:0]      i_Row_Count_Div,
    input [3:0]      i_Bitmap_Data, // Add input to get the bitmap data
    output reg [5:0] o_Frogger_X,
    output reg [5:0] o_Frogger_Y,
    output reg [6:0] o_Score
);

    reg r_Switch_1;
    reg r_Switch_2;
    reg r_Switch_3;
    reg r_Switch_4;

    // ============================================================================
    // Initialization of Frogger's Position and Score
    // ============================================================================
    initial begin
        o_Frogger_X = 0;   // Initial column position
        o_Frogger_Y = 14;  // Initial row position (bottom of the screen)
        o_Score     = 0;   // Initial score
    end

    // ============================================================================
    // Main Control Logic for Frogger's Movements
    // ============================================================================
    always @(posedge i_Clk) begin
        // Capture the current state of movement signals
        r_Switch_1 <= i_Up_Mvt;
        r_Switch_2 <= i_Down_Mvt;
        r_Switch_3 <= i_Left_Mvt;
        r_Switch_4 <= i_Right_Mvt;

        // Reset Frogger's position if a collision occurs
        if (i_Collided) begin
            o_Frogger_X <= 10; // Reset X position
            o_Frogger_Y <= 14; // Reset Y position
        end

        // Check if Frogger reached the top row
        if (o_Frogger_Y == 0) begin
            // If on a lily pad, increment the score
            if (i_Bitmap_Data == 4) begin
                o_Score <= i_Score + 1;  // Increment score
            end
            // Reset Frogger to start position
            o_Frogger_X <= 10;
            o_Frogger_Y <= 14;
        end
        // Allow movement only if the game is in PLAY mode
        else if (i_Game_Active) begin
            // Handle Up Movement
            if (i_Up_Mvt == 1'b1 && r_Switch_1 == 1'b0) begin
                if (o_Frogger_Y > 0) begin
                    o_Frogger_Y <= o_Frogger_Y - 1;  // Move up
                end
            end
            // Handle Down Movement
            else if (i_Down_Mvt == 1'b1 && r_Switch_2 == 1'b0) begin
                if (o_Frogger_Y < 14) begin
                    o_Frogger_Y <= o_Frogger_Y + 1;  // Move down
                end
            end
            // Handle Left Movement
            else if (i_Left_Mvt == 1'b1 && r_Switch_3 == 1'b0) begin
                if (o_Frogger_X > 0) begin
                    o_Frogger_X <= o_Frogger_X - 1;  // Move left
                end
            end
            // Handle Right Movement
            else if (i_Right_Mvt == 1'b1 && r_Switch_4 == 1'b0) begin
                if (o_Frogger_X < 13) begin
                    o_Frogger_X <= o_Frogger_X + 1;  // Move right
                end
            end
        end
    end

endmodule