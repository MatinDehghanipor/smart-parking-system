// input clock : 1KHz
// the timer retain its value until enabling for new record
module hsm_timer (enable, CLK, RESET, hours, minutes, seconds);

    input enable, CLK, RESET;
    output reg [6:0] hours, minutes, seconds;

    reg [9:0] counter;
    reg inner_enbale;

    always @ (posedge CLK or posedge RESET or enable) begin
        if (RESET) begin
            hours = 0;
            minutes = 0;
            seconds = 0;
            counter = 0;
            inner_enbale = 0;
        end
        if (enable & ~inner_enbale) begin
            inner_enbale = 1'b1; 
            hours = 0;
            minutes = 0;
            seconds = 0;
            counter = 0;
        end
        if (~enable)    inner_enbale = 1'b0;
        if (inner_enbale) begin
            if (counter > 999) begin
                seconds = seconds + 1;
                counter = 0;
            end
            if (seconds > 59) begin
                minutes = minutes + 1;
                seconds = 0;
            end
            if (minutes > 59) begin
                hours = hours + 1;
            end
            counter = counter + 1;
        end
    end

endmodule