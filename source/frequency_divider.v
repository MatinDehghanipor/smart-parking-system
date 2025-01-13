module frequency_divider(clk_in, RESET, clk_250hz, clk_1khz);
    input clk_in, RESET;
    output reg clk_250hz, clk_1khz;

    reg [17 : 0] cntr_250hz;
    reg [14 : 0] cntr_1khz;

    parameter INPUT_FREQUENCY = 40_000_000; // expected to be 40 000 000
    parameter TOGGLING_POINT_250HZ = (INPUT_FREQUENCY / (250 * 2)) - 1;
    parameter TOGGLING_POINT_1KHZ = (INPUT_FREQUENCY / (1000 * 2)) - 1;
    
    always @ (posedge clk_in or posedge RESET) begin 
        if (RESET) begin
            cntr_250hz = 0;
            cntr_1khz = 0;
            clk_250hz = 1'b0;
            clk_1khz = 1'b0;
        end
        else begin
            if (cntr_250hz > TOGGLING_POINT_250HZ) begin
                clk_250hz = ~clk_250hz;
                cntr_250hz = 0;
            end
            cntr_250hz = cntr_250hz + 1;

            if (cntr_1khz > TOGGLING_POINT_1KHZ) begin
                clk_1khz = ~clk_1khz;
                cntr_1khz = 0;     
            end
            cntr_1khz = cntr_1khz + 1;
        end     
    end
endmodule