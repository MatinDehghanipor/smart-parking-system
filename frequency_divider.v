// input clock frequency : 40KHz

module frequency_divider(clk_in, RESET, clk_1hz, clk_2hz, clk_100hz, clk_1khz);
    input clk_in, RESET;
    output reg clk_1hz, clk_2hz, clk_100hz, clk_1khz;
    reg [20 : 0] cntr_1hz;
    reg [19 : 0] cntr_2hz;
    reg [17 : 0] cntr_100hz;
    reg [14 : 0] cntr_1khz;

    always @(posedge clk_in or posedge RESET) begin 
        if (RESET) begin
            cntr_1hz = 0;
            cntr_2hz = 0;
            cntr_100hz = 0;
            cntr_1khz = 0;
            clk_1hz = 1'b0;
            clk_2hz = 1'b0;
            clk_100hz = 1'b0;
            clk_1khz = 1'b0;
        end
        else begin
            if (cntr_1hz > 2000000) begin
                clk_1hz = ~clk_1hz;
                cntr_1hz = 0;
            end
            cntr_1hz = cntr_1hz + 1;

            if (cntr_2hz > 1000000) begin
                clk_2hz = ~clk_2hz;
                cntr_2hz = 0;
            end
            cntr_2hz = cntr_2hz + 1;

            if (cntr_100hz > 10000) begin
                clk_100hz = ~clk_100hz;
                cntr_100hz = 0;
            end
            cntr_100hz = cntr_100hz + 1;

            if (cntr_1khz > 1000) begin
                clk_1khz = ~clk_1khz;
                cntr_1khz = 0;     
            end
            cntr_1khz = cntr_1khz + 1;
        end     
    end
endmodule