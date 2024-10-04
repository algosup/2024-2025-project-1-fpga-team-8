module frogger_collisions (
    input i_Clk,
    input [5:0] i_Frogger_X,
    input [5:0] i_Frogger_Y,
    input [5:0] i_Frogger_Orig_x,
    input [5:0] i_Frogger_Orig_y,
    input [5:0] i_Car_X_1, i_Car_Y_1,
    input [5:0] i_Car_X_2, i_Car_Y_2,
    input [5:0] i_Car_X_3, i_Car_Y_3,
    input [5:0] i_Car_X_4, i_Car_Y_4,
    input [5:0] i_Car_X_5, i_Car_Y_5,
    output reg [5:0] o_Frogger_X,
    output reg [5:0] o_Frogger_Y
);

    wire w_Reset = 0;  // Use a register for reset to hold the value until reset condition is met

    always @(posedge i_Clk) begin
        if (!i_Game_Active) begin
            // Game is active: Check for collisions
            if ((i_Frogger_Y == i_Car_Y_1 && i_Frogger_X == i_Car_X_1) ||
                (i_Frogger_Y == i_Car_Y_2 && i_Frogger_X == i_Car_X_2) ||
                (i_Frogger_Y == i_Car_Y_3 && i_Frogger_X == i_Car_X_3) ||
                (i_Frogger_Y == i_Car_Y_4 && i_Frogger_X == i_Car_X_4) ||
                (i_Frogger_Y == i_Car_Y_5 && i_Frogger_X == i_Car_X_5)) begin
                w_Reset <= 1;  // Set reset to 1 if any collision is detected
            end
            else begin
                w_Reset <= 0;  // Clear reset if no collision is detected
            end

            if (w_Reset) begin
                // If a collision occurs, reset Frogger's position
                o_Frogger_X <= i_Frogger_Orig_x;
                o_Frogger_Y <= i_Frogger_Orig_y;
                w_Reset <= 0;  // Clear reset after updating position
            end
        end
    end
endmodule