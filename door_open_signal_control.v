`timescale 1ns / 100ps

// clock frequency : 2Hz

module door_open_signal_control(in_signal, CLK, out_signal);
    input in_signal, CLK;
    output out_signal;

    assign out_signal = out_signal & CLK;

endmodule