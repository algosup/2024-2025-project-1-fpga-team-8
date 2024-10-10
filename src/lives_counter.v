module lives_counter (
    input i_Clk,
    input i_Collided,
    output reg o_LED_2,     // Change to reg type
    output reg o_LED_3,     // Change to reg type
    output reg o_LED_4,     // Change to reg type
    output reg o_Game_Over, // Change to reg type
    output reg o_Lives      // Change to reg type
);

    // Declare lives as a register
    reg r_Collision_Handled;  // Flag to track collision handling

    initial begin
        o_Lives = 3;  // Initialize to 3 lives
        r_Collision_Handled = 0;  // Initialize collision handled flag
    end

    // Synchronous logic to initialize and update lives
    always @(posedge i_Clk) begin
        // Initialize lives at the start
        if (i_Collided && !r_Collision_Handled) begin
            // Decrement lives on collision if not already handled
            if (o_Lives > 0) begin
                o_Lives <= o_Lives - 1;
            end
            r_Collision_Handled <= 1;  // Mark collision as handled
        end else if (!i_Collided) begin
            r_Collision_Handled <= 0;  // Reset collision handled flag when no collision is present
        end

        // Set the LEDs based on remaining lives
        case (o_Lives)
            0: begin
                o_LED_2 <= 0;
                o_LED_3 <= 0;
                o_LED_4 <= 0;
            end
            1: begin
                o_LED_2 <= 0;
                o_LED_3 <= 0;
                o_LED_4 <= 1;
            end
            2: begin
                o_LED_2 <= 0;
                o_LED_3 <= 1;
                o_LED_4 <= 1;
            end
            3: begin
                o_LED_2 <= 1;
                o_LED_3 <= 1;
                o_LED_4 <= 1;
            end
            default: begin
                o_LED_2 <= 0;
                o_LED_3 <= 0;
                o_LED_4 <= 0;
            end
        endcase
    end

endmodule