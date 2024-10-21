module car #(
    parameter CAR_INIT_X = 0,          
    parameter BASE_SPEED = 25'd1000,   
    parameter CAR_DIRECTION = 1        
) (
    input wire i_Clk,                  
    input wire [6:0] level,            
    output reg [4:0] o_car_x           
);
    
    reg [4:0] car_x = CAR_INIT_X;      
    reg [2:0] speed_counter;           
    reg [24:0] adjusted_speed;

    // Couldn't progressively increase the speed because not enough LUTs to fix overflow :(
    always @(*) begin
        case (level)
            // 7'd1: adjusted_speed = BASE_SPEED;             
            // 7'd2: adjusted_speed = BASE_SPEED - 1;  
            // 7'd3: adjusted_speed = BASE_SPEED - 1;  
            // 7'd4: adjusted_speed = BASE_SPEED - 1;  
            // 7'd5: adjusted_speed = BASE_SPEED - 1;  
            // 7'd6: adjusted_speed = BASE_SPEED - 1;  
            // 7'd7: adjusted_speed = BASE_SPEED - 1;  
            // 7'd8: adjusted_speed = BASE_SPEED - 1;  
            // 7'd9: adjusted_speed = BASE_SPEED - 1;  
            // 7'd10: adjusted_speed = BASE_SPEED - 1; 
            // 7'd11: adjusted_speed = BASE_SPEED - 1; 
            // 7'd12: adjusted_speed = BASE_SPEED - 1; 
            // 7'd13: adjusted_speed = BASE_SPEED - 1; 
            // 7'd14: adjusted_speed = BASE_SPEED - 1; 
            // 7'd15: adjusted_speed = BASE_SPEED - 1; 
            // 7'd16: adjusted_speed = BASE_SPEED - 1; 
            default: adjusted_speed = BASE_SPEED;       
        endcase
    end

    
    always @(posedge i_Clk) begin
        if (speed_counter == 0) begin
            speed_counter <= adjusted_speed[6:2];  

            
            if (CAR_DIRECTION == 1) begin
                if (car_x < 19)
                    car_x <= car_x + 1;
                else
                    car_x <= 0;
            end else begin
                if (car_x > 0)
                    car_x <= car_x - 1;
                else
                    car_x <= 19;
            end
        end else begin
            speed_counter <= speed_counter - 1;
        end

        
        o_car_x <= car_x;
    end
endmodule