module car_collisions (
    input i_Clk,
    input [5:0] i_Frogger_X,
    input [5:0] i_Frogger_Y,
    input [5:0] i_Frogger_Orig_x,
    input [5:0] i_Frogger_Orig_y,
    input [5:0] i_Car_X_1, i_Car_Y_1,
    input [5:0] i_Car_X_2, i_Car_Y_2,
    input [5:0] i_Car_X_3, i_Car_Y_3,
    input [5:0] i_Car_X_4, i_Car_Y_4,
    input [5:0] i_Car_X_5, i_Car_Y_5,
    output reg o_Collided
);

// Register arrays to store car positions
reg [5:0] car_x [4:0];
reg [5:0] car_y [4:0];
reg r_Previous_Collision;

always @(posedge i_Clk) begin
    // Update car positions on each clock cycle
    car_x[0] <= i_Car_X_1; car_y[0] <= i_Car_Y_1;
    car_x[1] <= i_Car_X_2; car_y[1] <= i_Car_Y_2;
    car_x[2] <= i_Car_X_3; car_y[2] <= i_Car_Y_3;
    car_x[3] <= i_Car_X_4; car_y[3] <= i_Car_Y_4;
    car_x[4] <= i_Car_X_5; car_y[4] <= i_Car_Y_5;

    // Detect collisions with cars or predefined X positions
    if (detect_car_collision(i_Frogger_X, i_Frogger_Y) || detect_wall_collision(i_Frogger_X, i_Frogger_Y)) begin
        if (!r_Previous_Collision) begin
            o_Collided <= 1;  // Set collision flag
        end
        r_Previous_Collision <= 1;  // Store that a collision is active
    end
    else begin
        o_Collided <= 0;  // Clear collision flag
        r_Previous_Collision <= 0;  // Reset collision state
    end
end

// Function to check for collisions with cars
function detect_car_collision;
    input [5:0] frog_x;
    input [5:0] frog_y;
    integer i;
    begin
        detect_car_collision = 0;  // Default to no collision
        for (i = 0; i < 5; i = i + 1) begin
            if ((frog_y == car_y[i] && (frog_x + 1 == car_x[i] || frog_x == car_x[i] + 1))) begin
                detect_car_collision = 1;  // Collision detected
            end
        end
    end
endfunction

// Function to check for collisions with walls
function detect_wall_collision;
    input [5:0] frog_x;
    input [5:0] frog_y;
    begin
        if (frog_y == 0) begin
            case (frog_x)
                0, 2, 3, 5, 6, 8, 9, 11, 12: detect_wall_collision = 1;  // Frogger's X position matches a collision X value
                default: detect_wall_collision = 0;
            endcase
        end else begin
            detect_wall_collision = 0;  // No collision in other rows
        end
    end
endfunction

endmodule