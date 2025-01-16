module baud_clock (
    input wire clk,          
    input wire rst,        // Asynchronous reset
    output reg baud_clk      // Output baud clock
);

    parameter CLOCK_FREQ = 50000000;  // Input clock frequency in Hz (e.g., 50 MHz)
    parameter BAUD_RATE = 9600;       // Desired baud rate (e.g., 9600 baud)
    parameter OVERSAMPLING = 16;      // Oversampling factor (typically 16 for UART)

    // counter limit
    parameter COUNTER_LIMIT = (CLOCK_FREQ / (BAUD_RATE * OVERSAMPLING)) - 1;

    reg [31:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            baud_clk <= 0;
        end else begin
            if (counter == COUNTER_LIMIT) begin
                counter <= 0;
                baud_clk <= ~baud_clk;  
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
