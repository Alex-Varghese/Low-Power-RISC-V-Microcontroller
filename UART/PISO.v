module piso #(parameter WIDTH = 8) (
    input wire clk,          // Clock signal
    input wire rst,        // Asynchronous reset
    input wire load,         // Load signal to load parallel data
    input wire [WIDTH-1:0] parallel_in, // Parallel input data
    output reg serial_out    // Serial output
);

    // Internal shift register
    reg [WIDTH-1:0] shift_reg;

    // Shift register logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0; 
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            shift_reg <= {1'b0, shift_reg[WIDTH-1:1]};
        end
    end

    // Serial output logic
    always @(*) begin
        serial_out = shift_reg[0]; // Output the LSB
    end

endmodule
