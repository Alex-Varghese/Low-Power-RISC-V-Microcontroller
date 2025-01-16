// Working LCD Code

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2024 12:24:09
// Design Name: 
// Module Name: lcd
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


module lcd(clk,rst,key_out,data,lcd_e,lcd_rw,lcd_rs);
input clk,rst;
input wire key_out;
output [7:0] data; 	// LCD 4 bit data
output reg lcd_e,lcd_rw,lcd_rs;		// LCD Enable,Read_Write,Register select

    reg [7:0] lcd_cmd;	//LCD Command 8 bits
    reg [5:0] state = 0;	//LCD states
    reg [2:0] state_2;
    reg next_state,next_state_m;
    reg init_done;
    reg [19:0]count=0;	// state counter
    reg [2:0] main_state;
    
    reg state_machine;
   
       parameter ins0 = 8'h30; // Sets the LCD in 8-bit mode
       parameter ins1 = 8'h80; // Force cursor to the beginning
       parameter ins2 = 8'h01; // Clear display
       parameter ins3 = 8'h06; // Cursor moves to the right
       parameter ins4 = 8'h02; // Return Home
       parameter ins5 = 8'h0F; // Display ON, cursor blinking
       parameter ins6 = 8'h08; // Display OFF
       parameter ins7 = 8'h09; // Cursor blinking
       parameter ins8 = 8'h10; // Shift cursor left
       parameter ins9 = 8'h14; // Shift cursor right
       parameter ins10 = 8'h14;
       parameter ins11 = 8'h0C; // Display ON, no cursor
       parameter ins12 = 8'h18; // Shift display left
       parameter ins13 = 8'h1C; // Shift display right
   

    
    parameter lcd_init = 0;
    parameter lcd_read_write = 1;
    
    assign data = lcd_cmd;
       
    always @(*) begin
        case (state_machine)
            lcd_init: next_state_m = init_done ? lcd_read_write : lcd_init;
            lcd_read_write: next_state_m = init_done ? lcd_read_write : lcd_init;
            default: next_state_m = lcd_init;
        endcase
    end
    
    always@(posedge clk)
        count <= count +1;
      
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            lcd_e<=0;
            init_done<=0;
            lcd_rs<=0;
            lcd_rw<=0;
            main_state<=lcd_init;	
            next_state_m<=init_done;
            next_state<=0;
            state_2<=0;
            state<=0;
            lcd_cmd<=0;
        end
        else
            begin
            case(main_state)
                lcd_init: // initialization of instructions
                    case(state)
                        0:begin // start of initialization state
                            lcd_e<=0;
                            lcd_rw<=0;
                            lcd_rs<=0;
                            if( count==2 )	// Wait 40 ms ( power on )
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        1:begin
                            lcd_e<=1;	// pulsing enable	
                            if(count==2)	// Wait 12 clk cycles
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        2:begin
                            lcd_e<=0;	// begin giving instructions
                            lcd_cmd<=ins0;		
                            if(count==4)	// Wait 39 us
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        3:begin
                            lcd_e<=1;	// LCD enable=1	
                            if(count==2)	// Wait 12 clk cycles
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        4:begin
                            lcd_e<=0;	
                            lcd_cmd<=ins1;		
                            if(count==4)	// Wait 39 us
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        5:begin
                            lcd_e<=1;	// LCD enable=1	
                            if(count==2)	
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        6:begin
                            lcd_e<=0;	// LCD enable=0
                            lcd_cmd<=ins2;	
                            if(count==4)	// Wait 37 us
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        7:begin
                            lcd_e<=1;	// LCD enable=1
                            if(count==2)	// Wait 12 clk cycles
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        8:begin
                            lcd_e<=0;	// LCD enable=0
                            lcd_cmd<=ins3;	
                            if(count==4)	// Wait 2000 clk cycles
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        9:begin
                            lcd_e<=1;	// LCD enable=1
                            if(count==2)	
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        10:begin
                            lcd_e<=0;	
                            lcd_cmd<=ins4;
                            if(count==4)	
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        11:begin
                            lcd_e<=0;	
                            if(count==2)	// Wait 12 clk cycles 
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        12:begin
                            lcd_e<=1;
                            lcd_cmd<=ins5;
                            if(count==4) 	// wait for 2000 clock cycles
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                            
                        13:begin
                            lcd_e<=1;
                            if(count==2)	
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        14:begin
                            lcd_e<=0;	
                            lcd_cmd<=ins6;
                            if(count==4)	// Wait 50 clk cycles ( at least )
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        15:begin	
                            lcd_e<=1;
                            if(count==2)	
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        16:begin	
                            lcd_e<=0;
                            lcd_cmd<=ins7;
                            if(count==4)	
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        
                        
                        17:begin
                            lcd_e<=1;	
                            if(count==2)	// Wait 12 clk cycles for lcd_e=1
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        
                        
                        18:begin
                            lcd_e<=0;
                            lcd_cmd<=ins8;	
                            if(count==4)	// Wait 50 clk cycles 
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        19:begin	
                            lcd_e<=1;
                            if(count==2)	
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        20:begin
                            lcd_e<=0;
                            lcd_cmd<=ins9;
                            if(count==4)	// Wait 2000 clk cycles
                            begin	
                            count<=0;
                            state<=state+1;
                            end
                        end
                        
                        21:begin
                            lcd_e<=1;
                            if(count==2)	
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        22:begin
                            lcd_e<=0;
                            lcd_cmd<=ins10;
                            if(count==4)	// Wait 50 clk cycles
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        23:begin
                            lcd_e<=1;
                            if(count==2)	
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        24:begin
                            lcd_e<=0;
                            lcd_cmd<=ins11;	// set address = 80h , move cursor to first row----1000_0000
                            if(count==4)	// Wait 12 clk cycles
                            begin	
                                count<=0;
                                state<=state+1;
                            end
                        end
                       
                        25:begin
                            lcd_e<=1;
                            if(count==2)
                            begin
                                count<=0;
                                state<=state+1;
                            end
                        end
                        
                        26:begin
                           lcd_e<=0;
                           lcd_cmd<=ins12;
                           if(count==4)	// Wait 12 clk cycles
                           begin
                               count<=0;
                               state<=state+1;
                           end
                        end
                        
                        
                        
                        27:begin
                        if(count==2)	// Wait 2000 clk cycles
                            begin	
                                count<=0;
                                init_done<=1;
                                state_2 <= 0;
                                main_state<=lcd_read_write;
                                state_machine <= lcd_read_write;
                                lcd_e <= 0;
                                next_state_m <= lcd_read_write;
                            end
                        end
                        endcase
                        
                    lcd_read_write:
                        begin
                        lcd_rs<=1;
                        case(state_2)
                            0:begin
                                lcd_e<=1;
                                	// data read or write operation 
                                lcd_cmd<=key_out;	
                                if(count==4)	// Wait 12 clk cycles
                                begin	
                                    count<=0;
                                    state_2<=state_2+1;
                                end
                            end
                            
                            // wait for 1 ms after 4 bit is sent 
                            
                            1:begin
                                lcd_e<=0;
                                if(count==2)	
                                begin	
                                    count<=0;
                                    state_2<=state_2+1;
                                end
                            end
                            
                            // wait for 230 ms when lcd_e=1 during 4 bit sending
                            
                            2:begin
                                if(count==2)	// Wait 12 clk cycles
                                begin	
                                    lcd_e<=0;
                                    count<=0;
                                    state_2<=state_2+1;
                                end
                            end
                            
                            // wait for 40 ms
                            
                            3:begin
                                if(count==2)	// Wait 2000 clk cycles
                                begin	
                                    count<=0;
                                    state_2<=state_2+1;
                                end
                            end
                        
                        // end of code
                            4:begin
                                  if(count==2)    // Wait 2000 clk cycles
                                  begin    
                                        count<=0;
                                        state_2<=0;
                                  end
                            end
                        endcase 
                        end
            endcase
            end 
        end
endmodule









