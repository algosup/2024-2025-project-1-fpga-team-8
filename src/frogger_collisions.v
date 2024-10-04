module frogger_collisions (
    input i_Clk,
    input i_Game_Active, // Add this input to check if the game is active
    input [5:0] i_Frogger_X,
    input [5:0] i_Frogger_Y,
    input [5:0] i_Frogger_Orig_x,
    input [5:0] i_Frogger_Orig_y,
    input [5:0] i_Car_X_1, i_Car_Y_1, i_Car_X_2, i_Car_Y_2, i_Car_X_3, i_Car_Y_3, i_Car_X_4, i_Car_Y_4, i_Car_X_5, i_Car_Y_5,
    output reg [5:0] o_Frogger_X, o_Frogger_Y
);

    reg reset;

    // Initial position assignment
    initial begin
        o_Frogger_X = i_Frogger_Orig_x;
        o_Frogger_Y = i_Frogger_Orig_y;
    end

    always @(posedge i_Clk) begin
        if (i_Game_Active) begin // Check if the game is active before detecting collisions
            case (i_Frogger_Y)
                i_Car_Y_1: if (i_Frogger_X == i_Car_X_1) reset <= 1;
                i_Car_Y_2: if (i_Frogger_X == i_Car_X_2) reset <= 1;
                i_Car_Y_3: if (i_Frogger_X == i_Car_X_3) reset <= 1;
                i_Car_Y_4: if (i_Frogger_X == i_Car_X_4) reset <= 1;
                i_Car_Y_5: if (i_Frogger_X == i_Car_X_5) reset <= 1;
                default: reset <= 0;
            endcase

            if (reset) begin
                o_Frogger_X <= i_Frogger_Orig_x;
                o_Frogger_Y <= i_Frogger_Orig_y;
            end
        end
        else begin
            // Keep the original Frogger position when the game is not active
            o_Frogger_X <= i_Frogger_Orig_x;
            o_Frogger_Y <= i_Frogger_Orig_y;
            reset <= 0; // Ensure reset is not triggered unintentionally
        end
    end
endmodule