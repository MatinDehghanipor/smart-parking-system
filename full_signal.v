`timescale 1ns / 100ps

// clock frequency : 1 Hz

module full_signal (in_signal, CLK, out_signal);

    input in_signal, CLK;
    output reg out_signal;

    assign out_signal = in_signal & CLK;

    reg [1:0] step;

    // It should alternate only three times

    always @ (posedge CLK) begin
        if (step > 0) begin
            step = step - 1;
            out_signal = ~ out_signal; 
        end

    end

    always @ (posedge in_signal) begin
        step = 1'd3;
        out_signal = in_signal;
    end

endmodule