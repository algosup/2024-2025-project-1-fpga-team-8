module frogger_ctrl(
    input i_Clk,
    input i_Score,
    input i_Up_Mvt,
    input i_Down_Mvt,
    input i_Left_Mvt,
    input i_Right_Mvt,
    input i_Game_Active,
    input [5:0]      i_Col_Count_Div,
    input [5:0]      i_Row_Count_Div,
    output reg       o_Draw_Frogger,
    output reg [5:0] o_Frogger_X,
    output reg [5:0] o_Frogger_Y,
    // output reg [6:0] o_Score,
);

    reg r_Switch_1;
    reg r_Switch_2;
    reg r_Switch_3;
    reg r_Switch_4;

    initial begin
        o_Frogger_X = 0;
        o_Frogger_Y = 0;
    end

always @(posedge i_Clk) begin
    // if (o_Frogger_Y / TILE_BORDER == 0) begin
    //         o_Frogger_Y <= 448;
    //         o_Score <= i_Score + 1;
    //     end
    if (i_Up_Mvt == 1'b1) begin
            if (o_Frogger_X < 20) begin
                o_Frogger_X <= o_Frogger_X + 1;  // Move square to the right
            end
        end
    else if(i_Down_Mvt == 1'b1) begin
        if(o_Frogger_X >= 0) begin
            o_Frogger_X <= o_Frogger_X - 1;
        end
    end
    else if(i_Left_Mvt == 1'b1) begin
        if(o_Frogger_Y < 15) begin
            o_Frogger_Y <= o_Frogger_Y + 1;
        end
    end
    else if(i_Right_Mvt == 1'b1) begin
            if(o_Frogger_Y >= 0) begin
                o_Frogger_Y <= o_Frogger_Y - 1;
            end
    end
end

// Draws a ball at the location determined by X and Y indexes.
  always @(posedge i_Clk)
  begin
    if (i_Col_Count_Div == o_Frogger_X && i_Row_Count_Div == o_Frogger_Y)
      o_Draw_Frogger <= 1'b1;
    else
      o_Draw_Frogger <= 1'b0;
  end

endmodule