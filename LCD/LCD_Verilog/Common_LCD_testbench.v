`timescale 1ns/1ps

module tb_lcd_ctrl;
    reg clk, rst;
    wire [7:0] data;
    wire lcd_e, lcd_rw, lcd_rs;
    
    // Assuming these signals are outputs from the lcd_ctrl module
    wire count_done;      // Add this if it's an output from lcd_ctrl
    wire init_done;       // Add this if it's an output from lcd_ctrl
    wire [3:0] current_count; // Add this if it's an output from lcd_ctrl

    // Instantiate the lcd_ctrl module
    lcd_ctrl uut (
        .clk(clk),
        .rst(rst),
        .data(data),
        .lcd_e(lcd_e),
        .lcd_rw(lcd_rw),
        .lcd_rs(lcd_rs),
        .count_done(count_done),      // Connect count_done
        .init_done(init_done),        // Connect init_done
        .current_count(current_count)  // Connect current_count
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        rst = 1; // Assert reset
        #10;     // Wait for 10 ns
        rst = 0; // Release reset
        #200;    // Run simulation for some time
        #600;    // Additional wait time
        #100;    // Additional wait time
        $finish; // End simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | rst: %b | state: %b | data: %h | lcd_e: %b | lcd_rw: %b | lcd_rs: %b | count_done: %b | init_done: %b | current_count: %b",
            $time, rst, uut.state, data, lcd_e, lcd_rw, lcd_rs, count_done, init_done, current_count);
    end
endmodule
