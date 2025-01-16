module sipo #(parameter WIDTH = 8) (
    input wire clk,          // Clock signal
    input wire reset,        // Asynchronous reset
    input wire serial_in,    // Serial input
    output reg [WIDTH-1:0] parallel_out // Parallel output
);

    // Internal shift register
    reg [WIDTH-1:0] shift_reg;

    // Shift register logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 0;  // Reset the shift register
        end else begin
            // Shift the register left and insert the new bit
            shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
        end
    end

    // Assign the shift register to the parallel output
    always @(*) begin
        parallel_out = shift_reg;
    end

endmodule
