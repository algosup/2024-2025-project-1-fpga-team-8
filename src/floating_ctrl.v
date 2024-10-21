module floating_ctrl #(

    
        
        parameter c_MIN_X = 0,
        
        parameter c_FLOATING_SPEED = 1,
        
        parameter c_SLOW_COUNT = 39000000,
        
        parameter c_INIT_X = 13,
        
        parameter c_INIT_Y = 5,
)(
    
        
        input i_Clk,
        
        input [5:0] i_Col_Count_Div,
        
        input [5:0] i_Row_Count_Div,

    
        
        output reg [5:0] o_Floating_X,
        
        output reg [5:0] o_Floating_Y
);

    
        
        reg [31:0] r_Counter = 0;

    
    initial begin

        
        o_Floating_X = c_INIT_X;
        
        o_Floating_Y = c_INIT_Y;
    end

    
    always @(posedge i_Clk) begin

        
        r_Counter <= r_Counter + 1;

        
        if (r_Counter >= c_SLOW_COUNT) begin
            
            
            r_Counter <= 0;

            
            if (o_Floating_X > c_MIN_X) begin
                o_Floating_X <= (o_Floating_X - c_FLOATING_SPEED);
            end

            
            else begin
                o_Floating_X <= 13;
            end

        end
    end

endmodule
