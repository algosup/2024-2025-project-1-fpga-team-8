




module sync_to_count 
 #(parameter TOTAL_COLS = 800,
   parameter TOTAL_ROWS = 525)
  (input            i_Clk,
   input            i_HSync,
   input            i_VSync, 
   output reg       o_HSync = 0,
   output reg       o_VSync = 0,
   output reg [9:0] o_Col_Count = 0,
   output reg [9:0] o_Row_Count = 0);
   
   wire w_Frame_Start;
   
  

  always @(posedge i_Clk)
  begin
    o_VSync <= i_VSync;
    o_HSync <= i_HSync;
  end

  
  always @(posedge i_Clk)
  begin
    if (w_Frame_Start == 1'b1)
    begin
      o_Col_Count <= 0;
      o_Row_Count <= 0;
    end
    else
    begin
      if (o_Col_Count == TOTAL_COLS-1)
      begin
        if (o_Row_Count == TOTAL_ROWS-1)
        begin
          o_Row_Count <= 0;
        end
        else
        begin
          o_Row_Count <= o_Row_Count + 1;
        end
        o_Col_Count <= 0;
      end
      else
      begin
        o_Col_Count <= o_Col_Count + 1;
      end
    end
  end

  
  
  
  
  
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
    
  
  assign w_Frame_Start = (~o_VSync & i_VSync);

endmodule