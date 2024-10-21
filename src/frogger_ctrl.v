module frogger_ctrl(

    
        
        input            i_Clk,
        
        input [6:0]      i_Score,
        
        input            i_Up_Mvt,
        
        input            i_Down_Mvt,
        
        input            i_Left_Mvt,
        
        input            i_Right_Mvt,
        
        input            i_Collided,
        
        input [5:0]      i_Col_Count_Div,
        
        input [5:0]      i_Row_Count_Div,
        
        input [3:0]      i_Bitmap_Data,
        
        input            i_On_Log,

    
        
        output reg [5:0] o_Frogger_X,
        
        output reg [5:0] o_Frogger_Y,
        
        output reg [6:0] o_Score
);

    
        
        reg r_Switch_1;
        
        reg r_Switch_2;
        
        reg r_Switch_3;
        
        reg r_Switch_4;

    
        parameter c_LOG_SLOW_COUNT = 39000000;
        parameter c_FROGGER_ORIG_X = 10;
        parameter c_FROGGER_ORIG_Y = 14;
        parameter c_GAME_WIDTH = 20;

        // reg [31:0] r_Log_Movement_Counter = 0;

    
    initial begin
        
        o_Frogger_X = 10;
        
        o_Frogger_Y = 14;
        
        o_Score = 0;
    end

    
    always @(posedge i_Clk) begin

        r_Switch_1 <= i_Up_Mvt;
        r_Switch_2 <= i_Down_Mvt;
        r_Switch_3 <= i_Left_Mvt;
        r_Switch_4 <= i_Right_Mvt;

        
            
            if (i_Up_Mvt == 1'b1 && r_Switch_1 == 1'b0) begin
                if (o_Frogger_Y > 0) begin
                    o_Frogger_Y <= o_Frogger_Y - 1;
                end
            end

            
            else if (i_Down_Mvt == 1'b1 && r_Switch_2 == 1'b0) begin
                if (o_Frogger_Y < 14) begin
                    o_Frogger_Y <= o_Frogger_Y + 1;
                end
            end

            
            else if (i_Left_Mvt == 1'b1 && r_Switch_3 == 1'b0) begin
                if (o_Frogger_X > 0) begin
                    o_Frogger_X <= o_Frogger_X - 1;
                end
            end

            
            else if (i_Right_Mvt == 1'b1 && r_Switch_4 == 1'b0) begin
                if (o_Frogger_X < 19) begin
                    o_Frogger_X <= o_Frogger_X + 1;
                end
            end

            
            if (i_Collided) begin
                o_Frogger_X <= 10;
                o_Frogger_Y <= 14;
                
            end

            
            if (o_Frogger_Y == 0) begin

                
                if (i_Bitmap_Data == 4) begin
                    o_Score <= i_Score + 1;  
                end

                
                o_Frogger_X <= 10;
                o_Frogger_Y <= 14;
            end

            
            // if (i_On_Log) begin
            //     r_Log_Movement_Counter <= r_Log_Movement_Counter + 1;
            //     if (r_Log_Movement_Counter >= c_LOG_SLOW_COUNT) begin
            //         r_Log_Movement_Counter <= 0;
                    
            //         if (o_Frogger_X > 0)
            //             o_Frogger_X <= o_Frogger_X - 1;
            //         else
            //             o_Frogger_X <= c_GAME_WIDTH - 1; 
                        
            //     end
            // end else begin
            //     r_Log_Movement_Counter <= 0; 
            // end

            
            // if (i_Bitmap_Data == 4'd2 && !i_On_Log) begin
            //     o_Frogger_X <= c_FROGGER_ORIG_X;
            //     o_Frogger_Y <= c_FROGGER_ORIG_Y;
                
            // end

    end 

endmodule