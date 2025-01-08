module timer (enable, CLK, RESET, time_seconds);

    input enable, CLK, RESET;
    output reg [6:0] time_seconds;

    always @ (posedge CLK or posedge RESET) begin
        if (RESET)
            time_seconds = 0;
        else begin
            if (enable)
                time_seconds = time_seconds + 1;
        end
    end

endmodule