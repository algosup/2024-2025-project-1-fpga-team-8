module clock_divider #(
    parameter DIV_FACTOR = 23'd2200000  // Adjust this value to slow down the clock as needed
)(
    input wire i_Clk,
    output reg o_Divided_Clk
);
    reg [22:0] counter = 0;
    
    always @(posedge i_Clk) begin
        if (counter == DIV_FACTOR) begin
            counter <= 0;
            o_Divided_Clk <= ~o_Divided_Clk;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
