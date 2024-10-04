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
    output reg o_Collided
);

initial begin
    o_Collided = 0;
end

    always @(posedge i_Clk) begin
            if ((i_Frogger_Y == i_Car_Y_1 && i_Frogger_X == i_Car_X_1) ||
                (i_Frogger_Y == i_Car_Y_2 && i_Frogger_X == i_Car_X_2) ||
                (i_Frogger_Y == i_Car_Y_3 && i_Frogger_X == i_Car_X_3) ||
                (i_Frogger_Y == i_Car_Y_4 && i_Frogger_X == i_Car_X_4) ||
                (i_Frogger_Y == i_Car_Y_5 && i_Frogger_X == i_Car_X_5)) begin
                o_Collided <= 1;  // Set reset to 1 if any collision is detected
            end
            else begin
                o_Collided <= 0;  // Clear reset if no collision is detected
            end

            if (o_Collided == 1) begin
                // If a collision occurs, reset Frogger's position
                o_Frogger_X <= i_Frogger_Orig_x;
                o_Frogger_Y <= i_Frogger_Orig_y;
                o_Collided <= 0;  // Clear reset after updating position
            end
    end
endmodule