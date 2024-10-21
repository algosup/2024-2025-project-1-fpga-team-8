//Testbench to paste in the testbench.sv part of EDA playground

module tb_debounce_filter;

  // Inputs
  reg i_Clk;
  reg i_Bouncy;

  // Outputs
  wire o_Debounced;

  // Parameters
  localparam DEBOUNCE_LIMIT = 20;  // Adjust this for different debounce limits

  // Instantiate the Unit Under Test (UUT)
  debounce_filter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) uut (
    .i_Clk(i_Clk),
    .i_Bouncy(i_Bouncy),
    .o_Debounced(o_Debounced)
  );

  // Clock generation: 100 MHz clock (period of 10ns)
  always #5 i_Clk = ~i_Clk;

  initial begin
    // Initialize inputs
    i_Clk = 0;
    i_Bouncy = 0;

    $dumpfile("debounce_dump.vcd"); $dumpvars;

    // Test case: initial stable state
    i_Bouncy = 0; #100;  // Ensure stable low input
    
    // Test case: simulate a bouncing input (rapid toggling)
    i_Bouncy = 1; #20;
    i_Bouncy = 0; #10;
    i_Bouncy = 1; #10;
    i_Bouncy = 0; #30;
    i_Bouncy = 1; #40;
    
    // Test case: stable high input for long enough to debounce
    i_Bouncy = 1; #(DEBOUNCE_LIMIT * 10);  // Hold high input for debounce time

    // Test case: stable low input for long enough to debounce
    i_Bouncy = 0; #(DEBOUNCE_LIMIT * 10);  // Hold low input for debounce time

    // Test case: simulate another bouncing sequence
    i_Bouncy = 1; #15;
    i_Bouncy = 0; #10;
    i_Bouncy = 1; #10;
    i_Bouncy = 0; #15;
    i_Bouncy = 1; #(DEBOUNCE_LIMIT * 10);  // Final stable high

    // End the simulation
    $finish;
  end

endmodule
