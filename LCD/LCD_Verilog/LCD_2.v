`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2024 13:03:10
// Design Name: 
// Module Name: clkDiv
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


module lcd(clk,rst,data,lcd_e,lcd_rw,lcd_rs);
input clk,rst;
output reg [7:0]data; 	// LCD 8 bit data
output reg lcd_e,lcd_rw,lcd_rs;		



wire [2:0]state=0;	//LCD states
wire [7:0]instruction[13:0]; // LCD instructions
reg [31:0] counter;        // Internal counter to track time
reg [31:0] target_count;   // Target number of cycles to count 
reg count_done;
//  reg [7:0]keypad; // keypad output

reg next_state,mode;
reg count_value,init_done;

parameter lcd_init = 2'd0;
parameter lcd_read_write = 2'd1;
parameter lcd_idle = 2'd2; // ( for power saving purpose only )

assign state = next_state;

assign instruction[0] = 8'h30; // Sets the LCD in 8-bit mode, with one display line, and 5x8 dot font
assign instruction[1] = 8'h80; // Force cursor to the beginning
assign instruction[2] = 8'h01; // Clear display
assign instruction[4] = 8'h02; // Return Home 
assign instruction[3] = 8'h06;  // Sets the cursor to move to the right (increment) after each character is written. No display shift
assign instruction[5] = 8'h0F; // Turns the display ON, with the cursor visible and blinking
assign instruction[6] = 8'h08; // Turns the display OFF, no cursor visible, no blinking.
assign instruction[7] = 8'h09; // Turns the display OFF, no cursor visible but cursor position is blinking.
assign instruction[8] = 8'h10; // Shifts the cursor to the left by one position without changing the display content.
assign instruction[9] = 8'h14; // Shifts the cursor to the right by one position without changing the display content.
assign instruction[10] = 8'h14; // Shifts the entire display to the left by one position.
assign instruction[11] = 8'h0C; // Turns the display ON, with no cursor visible and no blinking.
assign instruction[12] = 8'h18; // Shift all display to left cursor moves according to display 
assign instruction[13] = 8'h1C; // Shifts the entire display to the right by one position.

    
always @ (*)
begin
      case(state)
          lcd_init :
          begin
              if( init_done )
                next_state <= lcd_read_write;
              else
                next_state <= lcd_init;
          end
          lcd_read_write :
          begin
             if( init_done )
                 next_state <= lcd_init; 
             else if( data[0] || data[1] || data[2] || data[3] || data[4] || data[5] || data[6] || lcd_e || lcd_rw || lcd_rs )
                 next_state <= lcd_idle;
             else
                  next_state <= lcd_read_write;
           end
           lcd_idle :
           begin
              if( data[0] || data[1] || data[2] || data[3] || data[4] || data[5] || data[6] || lcd_e || lcd_rw || lcd_rs )
                   next_state <= lcd_idle;
              else
                   next_state <= lcd_read_write;
           end
   endcase
end

        
always@(posedge clk or negedge rst)
     begin
     if(rst)
         begin
             lcd_rs <= 0;
             lcd_rw <= 0;
             lcd_e <= 0;
             data <= 8'b0;
      end
      else
      begin
      case(state)
           lcd_init:
           begin // Initialization
                    lcd_rs <= 0;
                    lcd_rw <= 0;
                    mode <= 0;
                    count_value <= {16'd0, 16'd40};
                    count(mode, count_value, count_done, counter, target_count);
                    if(count_done)
                    begin
                        lcd_e <= 1;	
                        data <= instruction[0]; //  8 bit mode and single line
                        mode <= 1;
                        count_value <= {16'd0,16'd39};
                    end
                    lcd_e <= 0;
                    count(mode, count_value, count_done, counter, target_count);
                    if(count_done)
                    begin
                       lcd_e <= 1;	
                       data <= instruction[1]; //  force cursor to the beginning
                       mode <= 1;
                       count_value <= {16'd0,16'd39};
                    end
                    lcd_e <= 0;
                    count(mode, count_value, count_done, counter, target_count);
                    if(count_done)
                    begin
                       lcd_e <= 1;    
                       data <= instruction[2]; //  clears display 
                       mode <= 1;
                       count_value <= {16'd0,16'd39};
                    end
                    lcd_e <= 0;
                    count(mode, count_value, count_done, counter, target_count);
                    if(count_done)
                    begin
                       lcd_e <= 1;    
                       data <= instruction[3]; //  shifting cursor after each input to right
                       mode <= 1;
                       count_value <= {16'd0,16'd39};
                    end
                    lcd_e <= 0;
                    count(mode, count_value, count_done, counter, target_count);
                    if(count_done)
                    begin
                       lcd_e <= 1;    
                       data <= instruction[4]; //   returns home
                       mode <= 1;
                       count_value <= {16'd0,16'd39};
                    end
                    lcd_e <= 0;
                    count(mode, count_value, count_done, counter, target_count);
                    if(count_done)
                    begin
                       lcd_e <= 1; 
                       data <= instruction[5]; //  Turns the display ON, with the cursor visible and blinking
                    end
                  init_done <= 1;
                  end
            lcd_read_write:
            begin // Read / write  operation
                     lcd_rs <= 1;
                     lcd_rw <= 0;
                     data <= 8'h09; // keypad value
                     mode <= 1;
                     count_value <= {16'd0,16'd43};
                     count(mode, count_value, count_done, counter, target_count);
            end         
        endcase
    end
    end          
endmodule
