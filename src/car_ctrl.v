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

    
    always @(posedge i_Clk) begin
        adjusted_speed <= BASE_SPEED;
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