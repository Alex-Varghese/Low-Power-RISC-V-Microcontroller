module RAM (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    input wire [10:0] addr, // Change to 11-bit address
    output reg [7:0] data_out,
    output reg busy_mem,
    output reg full_mem,
    output reg empty_mem
);
    reg [7:0] mem [0:2047]; // 2048 x 8-bit memory
    reg [10:0] write_pointer; // Change to 11-bit pointer
    reg [10:0] read_pointer; // Change to 11-bit pointer
    reg [10:0] count; // Change to 11-bit count

    initial begin
        busy_mem = 0;
        full_mem = 0;
        empty_mem = 1;
        write_pointer = 0;
        read_pointer = 0;
        count = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy_mem <= 0;
            full_mem <= 0;
            empty_mem <= 1;
            write_pointer <= 0;
            read_pointer <= 0;
            count <= 0;
        end else begin
            busy_mem <= 0;
            if (wr_en && !full_mem) begin
                busy_mem <= 1;
                mem[write_pointer] <= data_in;
                write_pointer <= (write_pointer + 1) % 2048; // Update write pointer
                count <= count + 1;
                if (count == 2047) full_mem <= 1; // Check if memory is full
                empty_mem <= 0; // Memory is no longer empty
            end
            
            if (rd_en && !empty_mem) begin
                busy_mem <= 1;
                data_out <= mem[read_pointer];
                read_pointer <= (read_pointer + 1) % 2048; // Update read pointer
                count <= count - 1;
                if (count == 0) empty_mem <= 1; // Check if memory is empty
                full_mem <= 0; // Memory is no longer full
            end
        end
    end
endmodule
