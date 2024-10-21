module score_control(
    input wire i_Clk,
    input [6:0] i_Score,
    output reg [6:0] o_Segment1,
    output reg [6:0] o_Segment2,
);


always @(posedge i_Clk) begin
    case (i_Score / 10)
        0: o_Segment1 <= 7'b1000000;  
        1: o_Segment1 <= 7'b1111001;  
        2: o_Segment1 <= 7'b0100100;  
        3: o_Segment1 <= 7'b0110000;  
        4: o_Segment1 <= 7'b0011001;  
        5: o_Segment1 <= 7'b0010010;  
        6: o_Segment1 <= 7'b0000010;  
        7: o_Segment1 <= 7'b1111000;  
        8: o_Segment1 <= 7'b0000000;  
        9: o_Segment1 <= 7'b0010000;  
        default: o_Segment1 <= 7'b1000000;  
    endcase

    case (i_Score % 10)
        0: o_Segment2 <= 7'b1000000;  
        1: o_Segment2 <= 7'b1111001;  
        2: o_Segment2 <= 7'b0100100;  
        3: o_Segment2 <= 7'b0110000;  
        4: o_Segment2 <= 7'b0011001;  
        5: o_Segment2 <= 7'b0010010;  
        6: o_Segment2 <= 7'b0000010;  
        7: o_Segment2 <= 7'b1111000;  
        8: o_Segment2 <= 7'b0000000;  
        9: o_Segment2 <= 7'b0010000;  
        default: o_Segment2 = 7'b1000000;  
    endcase
end


endmodule