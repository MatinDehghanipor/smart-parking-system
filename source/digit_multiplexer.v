// clock frequency : 250 Hz

module digit_multiplexer(bcd_digits, CLK, RESET, selected_bcd, selected_segment);
    input [15:0] bcd_digits;
    input CLK, RESET;
    output reg [3:0] selected_bcd;
    output reg [3:0] selected_segment;

    reg [1:0] counter;

    always @ (posedge CLK or posedge RESET) begin
        if (RESET)
            counter = 0;
        else begin
            case (counter)
                2'b00 : begin
                    selected_bcd = bcd_digits[3:0];
                    selected_segment =  4'b0001;
                end 
                2'b01 : begin
                    selected_bcd = bcd_digits[7:4];
                    selected_segment = 4'b0010;
                end
                2'b10 : begin
                    selected_bcd = bcd_digits[11:8];
                    selected_segment = 4'b0100;
                end
                2'b11 : begin
                    selected_bcd = bcd_digits[15:12];
                    selected_segment = 4'b1000;
                end
            endcase
            counter = counter + 1;
        end
    end
endmodule