`timescale 1us / 100ns
`include "../source/hsm_timer.v"

module hsm_timer_test;
    wire [6:0] hours, minutes, seconds;
    reg enable, RESET, CLK;

    hsm_timer uut (enable, CLK, RESET, hours, minutes, seconds);


    initial begin
        CLK = 1'b1;
        repeat (2_000_000) // 1000 second. 
            #500 CLK = ~CLK;
    end

    initial begin
        $monitor("%d : %d : %d", hours, minutes, seconds);
    end

    initial begin
        RESET = 1'b0; #10
        RESET = 1'b1; #10
        RESET = 1'b0; #10
        enable = 1'b1; #10_000_000
        enable = 1'b0; #10
        enable = 1'b1; #100_000_000
        enable = 1'b0; #10
        enable = 1'b1; #30_000_000;
        
        $finish;
    end
endmodule