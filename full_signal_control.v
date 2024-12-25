// clock frequency : 1 Hz

module full_signal_control (in_signal, CLK, out_signal);

    input in_signal, CLK;
    output reg out_signal;

    reg [3:0] step;

    // It should alternate only three times
    always @ (posedge in_signal) begin
        step = 4'b0000;
    end

    always @ (CLK) begin
        if (step == 4'b0000) begin
            out_signal = in_signal;
            step = step + 1;
        end
        if (step < 8) begin
            out_signal = ~out_signal;
            step = step + 1;
        end
    end
endmodule