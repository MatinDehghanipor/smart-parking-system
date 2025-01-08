`timescale 1us / 100ns

`include "../source/timer.v"
`include "../source/frequency_divider.v"

module timer_frequency_divider_test;
    reg clk_1khz;
    reg RESET;
    wire clk_1hz;
    wire clk_2hz;
    wire clk_250hz;
    wire clk_1khz_out;
    wire [6:0] time_seconds;

    frequency_divider freq_divider (clk_1khz, RESET, clk_1hz, clk_2hz, clk_250hz, clk_1khz_out);
    timer t1 (1'b1, clk_1hz, RESET, time_seconds);

    initial begin
        clk_1khz = 1'b1;
        repeat (10000) begin
            clk_1khz = ~clk_1khz; #500;
        end
    end

    initial begin
        $dumpfile("timer_frequency_divider_test.vcd");
        $dumpvars(0, timer_frequency_divider_test);
        RESET = 1'b0; #10
        RESET = 1'b1; #10
        RESET = 1'b0; #10
        $monitor("%d", time_seconds);
        // $monitor("%b", clk_1hz);
        
    end
endmodule   