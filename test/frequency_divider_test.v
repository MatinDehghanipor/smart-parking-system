`include "frequency_divider.v"
`timescale 1ns / 100ps

module frequency_divider_test();
    wire clk_1hz, clk_2hz, clk_100hz, clk_1khz;

    reg clk_in, RESET;

    frequency_divider divider(clk_in, RESET, clk_1hz, clk_2hz, clk_100hz, clk_1khz);

    initial begin
        clk_in = 1'b1;
        repeat (60000)
            # 12.5 clk_in = ~clk_in;
        $finish;
    end

    initial begin
        $dumpfile("frequency_divider_test.vcd");
        $dumpvars(0, frequency_divider_test);

        RESET = 1'b0; #10
        RESET = 1'b1; #10
        RESET = 1'b0; #10;
    end
endmodule