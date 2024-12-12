`timescale 1ns/1ps  // Set the time unit and precision

module thunderbird_tb;

    // Testbench signals
    reg clk, rst, left, right;
    wire LC, LB, LA, RC, RB, RA;

    // Additional signals for module connections
    wire is_left, is_right;
    wire [2:0] output_left, output_right;

    // Assign left and right mode indicators
    assign is_left = 1'b1;  // Indicates the left module
    assign is_right = 1'b0; // Indicates the right module

    // Instantiate the Left Thunderbird Module
    thunderbird_Left left_module (
        .clk(clk),
        .rst(rst),
        .isLeft(is_left),
        .enable(left),
        .output_state(output_left)
    );

    // Instantiate the Right Thunderbird Module
    thunderbird_Left right_module (
        .clk(clk),
        .rst(rst),
        .isLeft(is_right),
        .enable(right),
        .output_state(output_right)
    );

    // Map output states to individual LEDs
    assign LC = output_left[2];
    assign LB = output_left[1];
    assign LA = output_left[0];
    assign RC = output_right[2];
    assign RB = output_right[1];
    assign RA = output_right[0];

    // Generate clock signal
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Clock period of 20ns (50MHz)
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        left = 0;
        right = 0;

        // Apply reset
        #20 rst = 0;  // Release reset after 20ns

        // Test left signal
        #20 left = 1;  // Turn on left signal
        #200 left = 0; // Turn off left after 200ns

        // Test right signal
        #20 right = 1; // Turn on right signal
        #200 right = 0; // Turn off right after 200ns

        // Test simultaneous left and right signals
        #20 left = 1; right = 1; // Turn on both signals
        #200 left = 0; right = 0; // Turn off both signals

        // End simulation
        #100 $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time: %0dns | clk: %b | rst: %b | left: %b | right: %b | LC: %b | LB: %b | LA: %b | RA: %b | RB: %b | RC: %b",
                 $time, clk, rst, left, right, LC, LB, LA, RA, RB, RC);
    end

endmodule