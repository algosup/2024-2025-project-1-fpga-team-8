module debounce_filter #(parameter DEBOUNCE_LIMIT = 20) (
  input  i_Clk,
  input  i_Bouncy,
  output o_Debounced);
 
  // Will set the width of this counter based on the input parameter
  reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count = 0;
  reg r_State = 1'b0;
  
  always @(posedge i_Clk)
  begin
    // Bouncy input is different than internal state value, so an input is
    // changing.  Increase the counter until it is stable for enough time.  
    if (i_Bouncy !== r_State && r_Count < DEBOUNCE_LIMIT-1)
    begin
      r_Count <= r_Count + 1;
      
    end
    // End of counter reached, switch is stable, register it, reset counter
    else if (r_Count == DEBOUNCE_LIMIT-1)
    begin
      r_State <= i_Bouncy;
      r_Count <= 0;
    end 
    // Switches are the same state, reset the counter
    else
    begin
      r_Count <= 0;
    end
  end
  
  // Assign internal register to output (debounced!)
  assign o_Debounced = r_State;
  
endmodule

module multi_button_debouncer (
    input wire i_Clk,
    input wire [3:0] i_Buttons,      // Four button inputs
    output reg [3:0] o_Debounced    // Four debounced outputs
);

    reg [1:0] r_Current_Button = 0;  // Select button to debounce
    reg [3:0] r_Button_State = 4'b0000; // Debounced state storage
    reg [3:0] r_Button_Debounced = 4'b0000; // Final debounced outputs

    wire w_Debounced_Signal;         // Debounced result for current button
    reg [$clog2(25000)-1:0] r_Debounce_Counter = 0; // Counter for debounce timing

    // Single debouncer instance
    debounce_filter #(25000) debounce_filter_inst (
        .i_Clk(i_Clk),
        .i_Bouncy(i_Buttons[r_Current_Button]),
        .o_Debounced(w_Debounced_Signal)
    );

    // Time-multiplex the buttons and store their debounced results
    always @(posedge i_Clk) begin
        // Increment debounce counter
        if (r_Debounce_Counter < 25000) begin
            r_Debounce_Counter <= r_Debounce_Counter + 1;
        end else begin
            // Debounce for the current button is done, store its debounced result
            r_Button_State[r_Current_Button] <= w_Debounced_Signal;

            // Reset debounce counter and move to the next button
            r_Debounce_Counter <= 0;
            r_Current_Button <= r_Current_Button + 1;
        end
    end

    // Output the debounced states
    always @(posedge i_Clk) begin
        o_Debounced <= r_Button_State;
    end

endmodule
