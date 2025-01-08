`timescale 1us / 100ns
`include "binary_bcd.v"

module binary_bcd_test ();
    wire [7:0] bcd;
    reg [6:0] bin;

    binary_bcd conv (bin, bcd);

    initial begin
        $monitor("bin: %d\nbcd: %b %b\n", bin, bcd[7:4], bcd[3:0]);
    end

    initial begin
        bin = 87; #10
        bin = 45; #10
        bin = 34; #10
        bin = 99; #10
        bin = 10; #10
        bin = 9; #10
        bin = 17; #10
        bin = 78; #10
        bin = 68; #10
        bin = 59; #10
        $finish;
    end
    
endmodule