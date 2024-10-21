//Testbench to paste in the testbench.sv part of EDA playground

module tb_score_control;
  // Inputs
  reg i_Clk;
  reg [6:0] i_Score;

  // Outputs
  wire [6:0] o_Segment1;
  wire [6:0] o_Segment2;

  // Instantiate the Unit Under Test (UUT)
  score_control uut (
    .i_Clk(i_Clk),
    .i_Score(i_Score),
    .o_Segment1(o_Segment1),
    .o_Segment2(o_Segment2)
  );
  


  // Clock generation
  always #5 i_Clk = ~i_Clk;  // 100 MHz clock (period of 10ns)
  initial begin
    // Initialize inputs
    i_Clk = 0;
    i_Score = 0;
    
      $dumpfile("dump.vcd"); $dumpvars;

    // Apply test cases
    i_Score = 7'd00; #10;
    i_Score = 7'd01; #10;
    i_Score = 7'd12; #10;
    i_Score = 7'd23; #10;
    i_Score = 7'd34; #10;
    i_Score = 7'd45; #10;
    i_Score = 7'd56; #10;
    i_Score = 7'd67; #10;
    i_Score = 7'd78; #10;
    i_Score = 7'd89; #10;
    i_Score = 7'd99; #10;
    
    // End the simulation
    $finish;
  end

endmodule
