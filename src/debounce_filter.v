module debounce_filter #(parameter DEBOUNCE_LIMIT = 20) (
  input  i_Clk,
  input  i_Bouncy,
  output o_Debounced);
 
  
  reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count = 0;
  reg r_State = 1'b0;
  
  always @(posedge i_Clk)
  begin
    
    
    if (i_Bouncy !== r_State && r_Count < DEBOUNCE_LIMIT-1)
    begin
      r_Count <= r_Count + 1;
      
    end
    
    else if (r_Count == DEBOUNCE_LIMIT-1)
    begin
      r_State <= i_Bouncy;
      r_Count <= 0;
    end 
    
    else
    begin
      r_Count <= 0;
    end
  end
  
  
  assign o_Debounced = r_State;
  
endmodule

module multi_button_debouncer (
    input wire i_Clk,
    input wire [3:0] i_Buttons,      
    output reg [3:0] o_Debounced    
);

    reg [1:0] r_Current_Button = 0;  
    reg [3:0] r_Button_State = 4'b0000; 
    reg [3:0] r_Button_Debounced = 4'b0000; 

    wire w_Debounced_Signal;         
    reg [$clog2(25000)-1:0] r_Debounce_Counter = 0; 

    
    debounce_filter #(25000) debounce_filter_inst (
        .i_Clk(i_Clk),
        .i_Bouncy(i_Buttons[r_Current_Button]),
        .o_Debounced(w_Debounced_Signal)
    );

    
    always @(posedge i_Clk) begin
        
        if (r_Debounce_Counter < 25000) begin
            r_Debounce_Counter <= r_Debounce_Counter + 1;
        end else begin
            
            r_Button_State[r_Current_Button] <= w_Debounced_Signal;

            
            r_Debounce_Counter <= 0;
            r_Current_Button <= r_Current_Button + 1;
        end
    end

    
    always @(posedge i_Clk) begin
        o_Debounced <= r_Button_State;
    end

endmodule
