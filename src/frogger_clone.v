module frogger_clone(
    input wire CLK,              // System clock input
    input wire SW1,              // Button input to move the square to the right
    input wire SW2,              // 
    input wire SW3,
    input wire SW4,
    output wire VGA_HS,          // Horizontal sync output (active low)
    output wire VGA_VS,          // Vertical sync output (active low)
    output reg VGA_R0,           // Red channel bit 0
    output reg VGA_R1,           // Red channel bit 1
    output reg VGA_R2,           // Red channel bit 2
    output reg VGA_G0,           // Green channel bit 0
    output reg VGA_G1,           // Green channel bit 1
    output reg VGA_G2,           // Green channel bit 2
    output reg VGA_B0,           // Blue channel bit 0
    output reg VGA_B1,           // Blue channel bit 1
    output reg VGA_B2            // Blue channel bit 2
);

    // VGA timing parameters for 640x480 @ 60Hz
    parameter H_ACTIVE = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_TOTAL = H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    parameter TILE_BORDER = 32;
    parameter V_ACTIVE = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    reg r_Switch_1;
    reg r_Switch_2;
    reg r_Switch_3;
    reg r_Switch_4;

    // Counters for pixel position
    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    // Pixel clock generation
    wire pixel_clk = CLK;

    // Generate synchronization signals
    always @(posedge pixel_clk) begin
        if (h_counter == H_TOTAL - 1) begin
            h_counter <= 0;
            if (v_counter == V_TOTAL - 1) begin
                v_counter <= 0;
            end else begin
                v_counter <= v_counter + 1;
            end
        end else begin
            h_counter <= h_counter + 1;
        end
    end

    // Generate VGA horizontal and vertical sync pulses (active low)
    assign VGA_HS = (h_counter >= H_ACTIVE + H_FRONT_PORCH && h_counter < H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE) ? 1'b0 : 1'b1;
    assign VGA_VS = (v_counter >= V_ACTIVE + V_FRONT_PORCH && v_counter < V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE) ? 1'b0 : 1'b1;

    // Video enable signal
    wire display_area = (h_counter < H_ACTIVE) && (v_counter < V_ACTIVE);

    // Registers to store the square's horizontal position
    reg [9:0] square_start_x = 0; // Start at the center initially
    reg [9:0] square_start_y = 0; // Center vertically (remains constant)
    
    wire [9:0] square_end_x = square_start_x + TILE_BORDER - 1; // Calculate square's end x-coordinate
    wire [9:0] square_end_y = square_start_y + TILE_BORDER - 1; // Fixed square end y-coordinate

    // Move square to the right when SW1 is pressed
    always @(posedge CLK) begin
        r_Switch_1 <= SW1;
        r_Switch_2 <= SW2;
        r_Switch_3 <= SW3;
        r_Switch_4 <= SW4;
        if (r_Switch_1 == 1 && SW1 == 0) begin
            if (square_start_x < H_ACTIVE - TILE_BORDER) begin
                square_start_x <= square_start_x + TILE_BORDER;  // Move square to the right
            end
        end
        else if(r_Switch_2 == 1 && SW2 == 0) begin
            if(square_start_x > 0) begin
                square_start_x <= square_start_x - TILE_BORDER;
            end
        end
        else if(r_Switch_3 == 1 && SW3 == 0) begin
            if(square_start_y < V_ACTIVE - TILE_BORDER) begin
                square_start_y <= square_start_y + TILE_BORDER;
            end
        end
        else if(r_Switch_4 == 1 && SW4 == 0) begin
            if(square_start_y > 0) begin
                square_start_y <= square_start_y - TILE_BORDER;
            end
        end
    end

    // Generate a black screen with a moving white square
    always @(posedge pixel_clk) begin
        if (display_area) begin
            if (h_counter >= square_start_x && h_counter <= square_end_x && v_counter >= square_start_y && v_counter <= square_end_y) begin
                // Display white square (set RGB to maximum)
                VGA_R0 <= 1'b0;
                VGA_R1 <= 1'b0;
                VGA_R2 <= 1'b0;

                VGA_G0 <= 1'b1;
                VGA_G1 <= 1'b1;
                VGA_G2 <= 1'b1;

                VGA_B0 <= 1'b0;
                VGA_B1 <= 1'b0;
                VGA_B2 <= 1'b0;
            end else if(h_counter < 2 || h_counter > H_ACTIVE - 2 || v_counter < 2 || v_counter > V_ACTIVE - 2) begin
                // Display white outside the square
                VGA_R0 <= 1'b1;
                VGA_R1 <= 1'b1;
                VGA_R2 <= 1'b1;

                VGA_G0 <= 1'b0;
                VGA_G1 <= 1'b0;
                VGA_G2 <= 1'b0;

                VGA_B0 <= 1'b0;
                VGA_B1 <= 1'b0;
                VGA_B2 <= 1'b0;
            end
             else begin
                // Display black outside the square
                VGA_R0 <= 1'b0;
                VGA_R1 <= 1'b0;
                VGA_R2 <= 1'b0;

                VGA_G0 <= 1'b0;
                VGA_G1 <= 1'b0;
                VGA_G2 <= 1'b0;

                VGA_B0 <= 1'b0;
                VGA_B1 <= 1'b0;
                VGA_B2 <= 1'b0;
            end
        end else begin
            // Blank the RGB outputs outside the display area
            VGA_R0 <= 1'b0;
            VGA_R1 <= 1'b0;
            VGA_R2 <= 1'b0;
            VGA_G0 <= 1'b0;
            VGA_G1 <= 1'b0;
            VGA_G2 <= 1'b0;
            VGA_B0 <= 1'b0;
            VGA_B1 <= 1'b0;
            VGA_B2 <= 1'b0;
        end
    end

endmodule
