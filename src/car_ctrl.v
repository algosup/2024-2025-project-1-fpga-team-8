module car #(
    parameter CAR_INIT_X = 0,          
    parameter BASE_SPEED = 24'd1000,  
    parameter CAR_DIRECTION = 1       
) (
    input wire i_Clk,                 
    input wire [3:0] level,           
    output reg [4:0] o_car_x          
);
    
    reg [4:0] car_x = CAR_INIT_X;      
    
    reg [2:0] speed_counter;
    
    reg [19:0] adjusted_speed;
    
    always @(*) begin
        case (level)
            1: adjusted_speed = BASE_SPEED;             
            2: adjusted_speed = BASE_SPEED - 1;  
            3: adjusted_speed = BASE_SPEED - 2;  
            4: adjusted_speed = BASE_SPEED - 3;  
            5: adjusted_speed = BASE_SPEED - 4;  
            6: adjusted_speed = BASE_SPEED - 5;  
            7: adjusted_speed = BASE_SPEED - 6;  
            8: adjusted_speed = BASE_SPEED - 7;  
            9: adjusted_speed = BASE_SPEED - 8;  
            10: adjusted_speed = BASE_SPEED - 9; 
            11: adjusted_speed = BASE_SPEED - 10; 
            12: adjusted_speed = BASE_SPEED - 11; 
            13: adjusted_speed = BASE_SPEED - 12; 
            14: adjusted_speed = BASE_SPEED - 13; 
            15: adjusted_speed = BASE_SPEED - 15; 
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
