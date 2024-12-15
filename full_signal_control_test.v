`include "full_signal_control.v"
`timescale 1us / 100ns

module full_signal_control_test();

    reg in_signal, CLK;
    wire out_signal;

    full_signal_control test (in_signal, CLK, out_signal);

    initial begin
        CLK = 1'b1;
        repeat (100)
            #500 CLK = ~CLK;
    end

    initial begin
        $dumpfile("full_signal_control_test.vcd");
        $dumpvars(0, full_signal_control_test);
        in_signal = 1'b0;
        #900
        in_signal = 1'b1;
        #3000
        in_signal = 1'b0;
        #2000
        in_signal = 1'b1;
        #3000
        in_signal = 1'b0;
    end

endmodule