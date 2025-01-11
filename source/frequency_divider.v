module frequency_divider(clk_in, RESET, clk_1hz, clk_2hz, clk_250hz, clk_1khz);
    input clk_in, RESET;
    output reg clk_1hz, clk_2hz, clk_250hz, clk_1khz;

    reg [20 : 0] cntr_1hz;
    reg [19 : 0] cntr_2hz;
    reg [17 : 0] cntr_250hz;
    reg [14 : 0] cntr_1khz;

    parameter INPUT_FREQUENCY = 1_000; // expected to be 40 000 000
    parameter TOGGLING_POINT_1HZ = (INPUT_FREQUENCY / (1 * 2)) - 1;
    parameter TOGGLING_POINT_2HZ = (INPUT_FREQUENCY / (2 * 2)) - 1;
    parameter TOGGLING_POINT_250HZ = (INPUT_FREQUENCY / (250 * 2)) - 1;
    parameter TOGGLING_POINT_1KHZ = (INPUT_FREQUENCY / (1000 * 2)) - 1;
    
    always @ (posedge clk_in or posedge RESET) begin 
        if (RESET) begin
            cntr_1hz = 0;
            cntr_2hz = 0;
            cntr_250hz = 0;
            cntr_1khz = 0;
            clk_1hz = 1'b0;
            clk_2hz = 1'b0;
            clk_250hz = 1'b0;
            clk_1khz = 1'b0;
        end
        else begin
            if (cntr_1hz > TOGGLING_POINT_1HZ) begin
                clk_1hz = ~clk_1hz;
                cntr_1hz = 0;
            end 
            cntr_1hz = cntr_1hz + 1;

            if (cntr_2hz > TOGGLING_POINT_2HZ) begin
                clk_2hz = ~clk_2hz;
                cntr_2hz = 0;
            end
            cntr_2hz = cntr_2hz + 1;

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