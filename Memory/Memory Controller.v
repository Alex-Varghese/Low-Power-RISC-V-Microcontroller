module MemoryController (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire [10:0] addr, // Change to 11-bit address
    input wire wr_req,
    input wire rd_req,
    output reg [7:0] data_out,
    output wire busy_mem,
    output wire full_mem,
    output wire empty_mem
);
    reg [7:0] buffer_data;
    wire ram_busy, ram_full, ram_empty;
    wire [7:0] ram_data_out;

    RAM ram_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_req && !ram_full && !ram_busy),
        .rd_en(rd_req && !ram_empty && !ram_busy),
        .data_in(buffer_data),
        .addr(addr), // Connect 11-bit addr
        .data_out(ram_data_out),
        .busy_mem(ram_busy),
        .full_mem(ram_full),
        .empty_mem(ram_empty)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            buffer_data <= 0;
            data_out <= 0;
        end else begin
            if (wr_req && !ram_busy && !ram_full) begin
                buffer_data <= data_in;
            end
            
            if (rd_req && !ram_busy && !ram_empty) begin
                data_out <= ram_data_out;
            end
        end
    end

    assign busy_mem = ram_busy;
    assign full_mem = ram_full;
    assign empty_mem = ram_empty;
endmodule
