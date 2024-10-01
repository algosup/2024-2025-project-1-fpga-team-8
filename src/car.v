module car_ctrl #(
    // Parameters for car movement
    // c_MAX_X: Maximum X position (grid width)
    // c_CAR_SPEED: How much to move the car in one step
    // c_SLOW_COUNT: Slow down counter threshold (adjust based on clock speed)
    parameter c_MAX_X = 20,
    parameter c_CAR_SPEED = 1,
    parameter c_SLOW_COUNT = 4000000,
    parameter c_INIT_X = 0,
    parameter c_INIT_Y = 13,
)(
    input i_Clk,
    input [5:0] i_Col_Count_Div,
    input [5:0] i_Row_Count_Div,

    output reg o_Draw_Car,
    output reg [5:0] o_Car_X,
    output reg [5:0] o_Car_Y
);

    reg [31:0] r_Counter = 0;      // 32-bit counter for slowing down the car movement

    initial begin
        o_Car_X = c_INIT_Y;  // Start position
        o_Car_Y = c_INIT_Y; // Starting Y position
    end

    // Car movement logic
    always @(posedge i_Clk) begin

        // Increment the slow down counter
        r_Counter <= r_Counter + 1;

        // When the counter reaches the threshold, update the car position
        if (r_Counter >= c_SLOW_COUNT) begin
            
            // Reset the counter
            r_Counter <= 0;

            // Update car's X position (move car)
            if (o_Car_X < c_MAX_X - 1) begin
                o_Car_X <= (o_Car_X + c_CAR_SPEED);
            end

            // Wrap around when the car reaches the end of the grid
            else begin
                o_Car_X <= 0;
            end
        end

        // Draw the car
        if (i_Col_Count_Div == o_Car_X && i_Row_Count_Div == o_Car_Y) begin
            // change this to 1 to draw the car
            o_Draw_Car <= 1;
        end
        else begin
            o_Draw_Car <= 0;
        end
    end

endmodule
