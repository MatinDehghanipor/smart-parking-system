// input clock : 1KHz

module hsm_timer (enable, CLK, RESET, hours, minutes, seconds);

    input enable, CLK, RESET;
    output reg [6:0] hours, minutes, seconds;

    reg [9:0] counter;

    // always @ (posedge enable) begin
    //     hours = 0;
    //     minutes = 0;
    //     seconds = 0;
    //     counter = 0;
    // end

    always @ (posedge CLK or posedge RESET or posedge enable) begin
        if (~CLK & ~RESET & enable) begin
            hours = 0;
            minutes = 0;
            seconds = 0;
            counter = 0;
        end

        if (RESET) begin
            hours = 0;
            minutes = 0;
            seconds = 0;
            counter = 0;
        end
        else begin
            if (enable) begin
                if (counter > 999)
                    seconds = seconds + 1;
                if (seconds > 59)
                    minutes = minutes + 1;
                if (minutes > 59)
                    hours = hours + 1;
                counter = counter + 1;
            end
        end
    end

endmodule