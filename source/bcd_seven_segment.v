// clock frequency : 250 Hz
`include "digit_multiplexer.v"

module bcd_seven_segment(bcd_digits, CLK, RESET, selected_segment, selected_data);
    input [15:0] bcd_digits; 
    input CLK, RESET;
    output [3:0] selected_segment;
    output reg [7:0] selected_data;

    wire [3:0] selected_bcd;

    digit_multiplexer multiplexer(bcd_digits, CLK, RESET, selected_bcd, selected_segment);

    always @ (selected_bcd)  begin
        case (selected_bcd)
            4'b0000 : selected_data = 8'b00111111; // 0
            4'b0001 : selected_data = 8'b00000110; // 1
            4'b0010 : selected_data = 8'b01011011; // 2
            4'b0011 : selected_data = 8'b01001111; // 3
            4'b0100 : selected_data = 8'b01100110; // 4
            4'b0101 : selected_data = 8'b01101101; // 5
            4'b0110 : selected_data = 8'b01111101; // 6
            4'b0111 : selected_data = 8'b00000111; // 7
            4'b1000 : selected_data = 8'b01111111; // 8
            4'b1001 : selected_data = 8'b01101111; // 9
            4'b1010 : selected_data = 8'b00000000; // -
        endcase 
    end
endmodule