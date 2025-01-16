module lcd(clk,rst,data,lcd_e,lcd_rw,lcd_rs,SF_CE0);
input clk,rst;
output [3:0]data; 	// LCD 4 bit data
output reg SF_CE0;	//Strata flash enable signal ( need to disable it )
output reg lcd_e,lcd_rw,lcd_rs;		// LCD Enable,Read_Write,Register select

reg [3:0]lcd_cmd;	//LCD Command // 4 bits
reg [5:0]state=0;	//LCD states

reg init_done,disp_done;

reg [19:0]count=0;	// state counter

assign data=lcd_cmd;	// assigning lcd command to 4'b lcd data

always@(posedge clk or posedge rst)
begin
if(rst)
begin
lcd_e<=0;
init_done<=0;
lcd_rs<=0;
lcd_rw<=0;
SF_CE0<=1'b1;	// Disable Strata enable signal
end

else

begin
case(state)

0:begin // IDLE state
lcd_e<=0;
lcd_rw<=0;
lcd_rs<=0;
if(count==750000)	// Wait 750000 clk or 15 ms
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

1:begin
lcd_e<=1;	// must be high for 12 clock cycles
lcd_cmd<=4'h3;	// write O3h	
if(count==12)	// Wait 12 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

2:begin
lcd_e<=0;	
// lcd_cmd<=4'h3;		
if(count==205000)	// Wait 205000 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

3:begin
lcd_e<=1;	// LCD enable=1
lcd_cmd<=4'h3;	// write O3h	
if(count==12)	// Wait 12 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

4:begin
lcd_e<=0;	
// lcd_cmd<=4'h3;		
if(count==5000)	// Wait 5000 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

5:begin
lcd_e<=1;	// LCD enable=1
lcd_cmd<=4'h3;	// write 03h	
if(count==12)	// Wait 12 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

6:begin
lcd_e<=0;	// LCD enable=0
// lcd_cmd<=4'h3;	// write 03h	
if(count==2000)	// Wait 2000 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

7:begin
lcd_e<=1;	// LCD enable=1
lcd_cmd<=4'h2;	// write 02h	
if(count==12)	// Wait 12 clk cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

8:begin
lcd_e<=0;	// LCD enable=0
// lcd_cmd<=4'h2;	// write 02h	
if(count==2000)	// Wait 2000 clk cycles
begin
count<=0;
state<=state+1;
init_done<=1;
end
else
count<=count+1;
end


//	End of Initialization---------------- power initialization

//	Display Configuration

//	Start of function set commands

9:begin
lcd_e<=1;	// LCD enable=1
lcd_cmd<=4'h2;	// function set ----Command = 28h---- write 02h as 4 bit data	
if(count==12)	// Wait 12 clk cycles for lcd_enable to be 1
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

//	LCD_enable = 0 and wait for 1 micro sec for next 4 bits

10:begin
lcd_e<=0;	
if(count==50)	// Wait at least 50 clk cycles i.e... 1 micro sec after 4 bit data write for every 8 bit command write
begin
// 	LCD_E=1 ,lower 4 bit
lcd_e<=1;
lcd_cmd<=4'h8;
count<=0;
state<=state+1;
end
else
count<=count+1;
end

//	wait for 230 ns when lcd_e=1 during 4 bit sending

11:begin	
if(count==12)	// Wait 12 clk cycles 
begin
lcd_e<=0;
count<=0;
state<=state+1;
end
else
count<=count+1;
end

//	End of 8 bit function set command

12:begin
if(count==2000) 	// wait for 2000 clock cycles
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// START of new entry mode set command=06h

13:begin
lcd_e<=1;	// LCD enable=1
lcd_cmd<=4'h6;	// write 06h	
if(count==12)	// Wait 12 clk cycles for lcd_enable to be 1
begin
count<=0;
state<=state+1;
end
else
count<=count+1;
end

14:begin
lcd_e<=0;	// LCD enable=0
if(count==50)	// Wait 50 clk cycles ( at least )
begin
// lcd_e=1 lower 4 bit
lcd_e<=1;
lcd_cmd<=4'h6;	// write 06h	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 230 ns when lcd_e=1 during 4 bit sending

15:begin	
if(count==12)	// Wait 12 clk cycles
begin
lcd_e<=0;	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// End of 8 bit entry mode set command

// wait for 40 ms after 8 bit is sent

16:begin	
if(count==2000)	// Wait 2000 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// Start of display on/off commands = 0Ch

17:begin
lcd_e<=1;
lcd_cmd<=4'h0;	// Set display=0Ch	
if(count==12)	// Wait 12 clk cycles for lcd_e=1
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// LCD_enable=0 and wait for 1 ms for next 4 bits

18:begin
lcd_e<=0;	
if(count==50)	// Wait 50 clk cycles 
begin	
// lcd_e=1 , lower 4 bit
lcd_e<=1;
lcd_cmd<=4'hc;	// Set display=0Ch
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 230 ns when lcd_e=1 during 4 bit sending

19:begin
if(count==12)	// Wait 12 clk cycles for lcd_e=1
begin	
lcd_e<=0;
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// End of display on/off commands

// wait for 40 ms after 8 bit is sent

20:begin
if(count==2000)	// Wait 2000 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// Start of clear display command=01h

21:begin
lcd_e<=1;
lcd_cmd<=4'h0;	// clear display=01h
if(count==12)	// Wait 12 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// LCD_e=0 and wait for 1 ms for next 4 bits

22:begin
lcd_e<=0;
if(count==50)	// Wait 50 clk cycles
begin	
// lcd_e=1 , lower 4 bits
lcd_cmd<=4'h1;	// write=01h
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 230 ms when lcd_e=1 during 4 bit sending

23:begin
if(count==12)	// Wait 12 clk cycles
begin	
lcd_e<=0;
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// End of 8 bit clear display command

// wait for 1.64 ms or 82000 clock cycles

24:begin
if(count==82000)	// Wait 82000 clk cycles=1.64 ms for end of initialization 
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// Writing data into LCD
// issue command = 80h to move cursor to first row

25:begin
lcd_e<=1;
lcd_cmd<=4'h8;	// set address = 80h , move cursor to first row----1000_0000
if(count==12)	// Wait 12 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// LCD_e=0 and wait for 1 ms for next 4 bits

26:begin
lcd_e<=0;
if(count==50)	// Wait 50 clk cycles=1ms
begin
// lcd_e =1 , lower 4 bits	
lcd_e<=1;
lcd_cmd<=4'h0;	// write 0h
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 230 ms when lcd_e=1 during 4 bit sending

27:begin
if(count==12)	// Wait 12 clk cycles
begin	
lcd_e<=0;
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 40 ms after 8 bits are sent

28:begin
if(count==2000)	// Wait 2000 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// writing data into lcd
// displaying character

29:begin
lcd_e<=1;
lcd_rs<=1;	// data read or write operation 
lcd_cmd<=4'h4;	// write 'I' from CGROM address = 49h into LCD (  take whatever is there from the register  )---------here im taking i as ex
if(count==12)	// Wait 12 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 1 ms after 4 bit is sent 

30:begin
lcd_e<=0;
if(count==50)	// Wait 50 clk cycles
begin

// writing lower bit

lcd_rs<=1;	// data read or write operation 
lcd_cmd<=4'h9;	// here i is 49 hence 
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 230 ms when lcd_e=1 during 4 bit sending

31:begin
if(count==12)	// Wait 12 clk cycles
begin	
lcd_e<=0;
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// wait for 40 ms

32:begin
if(count==2000)	// Wait 2000 clk cycles
begin	
count<=0;
state<=state+1;
end
else
count<=count+1;
end

// end of code

endcase 
end 
end
endmodule








