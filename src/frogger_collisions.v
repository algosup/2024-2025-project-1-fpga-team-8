module frogger_collisions (
    input            i_Clk,
    input [5:0]      i_Frogger_X,
    input [5:0]      i_Frogger_Y,
    input [5:0]      i_Frogger_Orig_x,
    input [5:0]      i_Frogger_Orig_y,
    input [5:0]      i_Car_X_1, i_Car_Y_1,
    input [5:0]      i_Car_X_2, i_Car_Y_2,
    input [5:0]      i_Car_X_3, i_Car_Y_3,
    input [5:0]      i_Car_X_4, i_Car_Y_4,
    input [5:0]      i_Car_X_5, i_Car_Y_5,
    input [1:0]      i_Lives,
    output reg [1:0] o_Lives,
    output reg       o_Collided
);

  // Internal register to hold the lives value
  reg [1:0] r_Lives;

  initial begin
    o_Collided = 0;
  end

  always @(posedge i_Clk) begin
    if ((i_Frogger_Y == i_Car_Y_1 && (i_Frogger_X == i_Car_X_1 || i_Frogger_X + 1 == i_Car_X_1 || i_Frogger_X == i_Car_X_1 + 1)) ||
        (i_Frogger_Y == i_Car_Y_2 && (i_Frogger_X == i_Car_X_2 || i_Frogger_X + 1 == i_Car_X_2 || i_Frogger_X == i_Car_X_2 + 1)) ||
        (i_Frogger_Y == i_Car_Y_3 && (i_Frogger_X == i_Car_X_3 || i_Frogger_X + 1 == i_Car_X_3 || i_Frogger_X == i_Car_X_3 + 1)) ||
        (i_Frogger_Y == i_Car_Y_4 && (i_Frogger_X == i_Car_X_4 || i_Frogger_X + 1 == i_Car_X_4 || i_Frogger_X == i_Car_X_4 + 1)) ||
        (i_Frogger_Y == i_Car_Y_5 && (i_Frogger_X == i_Car_X_5 || i_Frogger_X + 1 == i_Car_X_5 || i_Frogger_X == i_Car_X_5 + 1))) begin
      o_Collided <= 1;  // Set collision flag

      // Decrement lives only if the value is greater than zero
      if (r_Lives > 0) begin
        r_Lives <= r_Lives - 1;
      end
    end
    else begin
      o_Collided <= 0;  // Clear collision flag if no collision is detected
    end

    // Update the output lives value
    o_Lives <= r_Lives;
  end

endmodule