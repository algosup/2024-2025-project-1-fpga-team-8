module frogger_ctrl(
    input            i_Clk,
    input [6:0]      i_Score,
    input            i_Up_Mvt,
    input            i_Down_Mvt,
    input            i_Left_Mvt,
    input            i_Right_Mvt,
    input            i_Collided,
    input [5:0]      i_Col_Count_Div,
    input [5:0]      i_Row_Count_Div,
    input [3:0]      i_Bitmap_Data,  // Add input to get the bitmap data
    output reg [5:0] o_Frogger_X,
    output reg [5:0] o_Frogger_Y,
    output reg [6:0] o_Score
);

    reg r_Switch_1;
    reg r_Switch_2;
    reg r_Switch_3;
    reg r_Switch_4;

    // Initialize starting position of Frogger
    initial begin
        o_Frogger_X = 0;  // Initial column
        o_Frogger_Y = 14;  // Initial row (bottom of the screen)
        o_Score = 0;       // Initial score
    end

    always @(posedge i_Clk) begin
        r_Switch_1 <= i_Up_Mvt;
        r_Switch_2 <= i_Down_Mvt;
        r_Switch_3 <= i_Left_Mvt;
        r_Switch_4 <= i_Right_Mvt;

        // Reset Frogger position if a collision occurs
        if (i_Collided) begin
            o_Frogger_X <= 10;
            o_Frogger_Y <= 14;
            // TODO: Add all the death logic
        end

        // Check if Frogger reached the top row
        if (o_Frogger_Y == 0) begin
            // Check if current position is a lily pad
            if (i_Bitmap_Data == 4) begin
                o_Score <= i_Score + 1;  // Increment score if on a lily pad
            end
            // Reset Frogger to start position
            o_Frogger_X <= 10;
            o_Frogger_Y <= 14;
        end
        // Handle Frogger's movements
        else if (i_Up_Mvt == 1'b1 && r_Switch_1 == 1'b0) begin
            if (o_Frogger_Y > 0) begin
                o_Frogger_Y <= o_Frogger_Y - 1;  // Move up
            end
        end
        else if (i_Down_Mvt == 1'b1 && r_Switch_2 == 1'b0) begin
            if (o_Frogger_Y < 14) begin
                o_Frogger_Y <= o_Frogger_Y + 1;  // Move down
            end
        end
        else if (i_Left_Mvt == 1'b1 && r_Switch_3 == 1'b0) begin
            if (o_Frogger_X > 0) begin
                o_Frogger_X <= o_Frogger_X - 1;  // Move left
            end
        end
        else if (i_Right_Mvt == 1'b1 && r_Switch_4 == 1'b0) begin
            if (o_Frogger_X < 13) begin
                o_Frogger_X <= o_Frogger_X + 1;  // Move right
            end
        end
    end

endmodule