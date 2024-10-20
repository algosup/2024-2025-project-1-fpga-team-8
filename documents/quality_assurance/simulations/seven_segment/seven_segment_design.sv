//Design to paste in the design.sv part of EDA playground
module score_control(
    input wire i_Clk,
    input [6:0] i_Score,
    output reg [6:0] o_Segment1,
    output reg [6:0] o_Segment2
);

// Depemding on the score, display the corresponding value on the 7-segment display
always @(posedge i_Clk) begin
    case (i_Score / 10)
        0: o_Segment1 = 7'b1000000;  // Display 0
        1: o_Segment1 = 7'b1111001;  // Display 1
        2: o_Segment1 = 7'b0100100;  // Display 2
        3: o_Segment1 = 7'b0110000;  // Display 3
        4: o_Segment1 = 7'b0011001;  // Display 4
        5: o_Segment1 = 7'b0010010;  // Display 5
        6: o_Segment1 = 7'b0000010;  // Display 6
        7: o_Segment1 = 7'b1111000;  // Display 7
        8: o_Segment1 = 7'b0000000;  // Display 8
        9: o_Segment1 = 7'b0010000;  // Display 9
        default: o_Segment1 = 7'b1000000;  // Blank display
    endcase

    case (i_Score % 10)
        0: o_Segment2 = 7'b1000000;  // Display 0
        1: o_Segment2 = 7'b1111001;  // Display 1
        2: o_Segment2 = 7'b0100100;  // Display 2
        3: o_Segment2 = 7'b0110000;  // Display 3
        4: o_Segment2 = 7'b0011001;  // Display 4
        5: o_Segment2 = 7'b0010010;  // Display 5
        6: o_Segment2 = 7'b0000010;  // Display 6
        7: o_Segment2 = 7'b1111000;  // Display 7
        8: o_Segment2 = 7'b0000000;  // Display 8
        9: o_Segment2 = 7'b0010000;  // Display 9
        default: o_Segment2 = 7'b1000000;  // Blank display
    endcase
end


endmodule