`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2024 10:31:00
// Design Name: 
// Module Name: lcd_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lcd_ctrl(
    input clk, rst,
    input [7:0] key_out,
    output reg [7:0] data,   // LCD 8-bit data
    output reg lcd_e, lcd_rw, lcd_rs
);

// State Definitions
parameter lcd_init = 2'd0;
parameter lcd_read_write = 2'd1;

reg state, next_state;
reg current_count, count; // Counters
reg init_done,count_done;

// Instruction Array
reg [7:0] instruction[13:0];
initial begin
    instruction[0] = 8'h30; // Sets the LCD in 8-bit mode
    instruction[1] = 8'h80; // Force cursor to the beginning
    instruction[2] = 8'h01; // Clear display
    instruction[3] = 8'h06; // Cursor moves to the right
    instruction[4] = 8'h02; // Return Home
    instruction[5] = 8'h0F; // Display ON, cursor blinking
    instruction[6] = 8'h08; // Display OFF
    instruction[7] = 8'h09; // Cursor blinking
    instruction[8] = 8'h10; // Shift cursor left
    instruction[9] = 8'h14; // Shift cursor right
    instruction[10] = 8'h14;
    instruction[11] = 8'h0C; // Display ON, no cursor
    instruction[12] = 8'h18; // Shift display left
    instruction[13] = 8'h1C; // Shift display right
end

// counter logic
always @( posedge clk)
begin
    if (rst) begin
            current_count <= 0;
            count_done <= 0;
     end else begin
          if (current_count < count) begin
                current_count <= current_count + 1; 
                count_done <= 0; 
           end else begin
                count_done <= 1;
                current_count <= 0;
           end
        end
end

// State Transition Logic
always @(*) begin
    case (state)
        lcd_init: next_state = init_done ? lcd_read_write : lcd_init;
        lcd_read_write: next_state = rst ? lcd_init : lcd_read_write;
        default: next_state = lcd_init;
    endcase
end

// Sequential Logic
always @(posedge clk) begin
    if (rst) begin
        state <= lcd_init;
        lcd_rs <= 0;
        lcd_rw <= 0;
        lcd_e <= 0;
        data <= 8'b0;
        init_done <= 0;
        current_count <= 0;
        count <= 0;
        count_done <= 0;
    end else begin
        state <= next_state;
        case (state)
            lcd_init: begin // include instructions to lcd
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                        data <= instruction[0];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[1];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[2];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[3];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[4];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[5];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[6];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[7];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[8];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[9];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[10];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[11];
                        lcd_e <= 1;
                        lcd_rs <= 0;
                        lcd_rw <= 0;
                        count_done <= 0;
                        count <= 153000;
                        if( count_done )       
                            data <= instruction[12];
                        init_done <= 1;
                end
            lcd_read_write: begin// include cursor shifting instructions
                lcd_rs <= 1;
                lcd_rw <= 0;
                data <= key_out; // Placeholder for data input
            end
        endcase
    end
end

endmodule
