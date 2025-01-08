`include "door_open_signal_control.v"
`timescale 1us / 100ns

module door_open_signal_control_test();

    reg in_signal, CLK;
    wire out_signal;

    door_open_signal_control control (in_signal, CLK, out_signal);

    initial begin
        CLK = 1'b1;
        repeat (1000) // 250 milisecond. 
            #250 CLK = ~CLK;
    end

    initial begin
        $dumpfile("door_open_signal_control_test.vcd");
        $dumpvars(0, door_open_signal_control_test);
        in_signal = 1'b0;
        #1000
        in_signal = 1'b1; 
        #10000
        in_signal = 1'b0;       
    end

endmodule