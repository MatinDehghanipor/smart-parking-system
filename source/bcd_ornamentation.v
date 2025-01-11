module bcd_ornamentation(left_bcd, right_bcd, display_mode, out);
    input [7:0] left_bcd, right_bcd;
    input display_mode;
    output [15:0] reg out;

    always (*) begin
        if (display_mode)
            if (left_bcd == 8'b00111111)
                
    end
endmodule