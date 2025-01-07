// clock frequency : 1 KHz
`include "d_flip_flop.v"

module debouncer(sig, CLK, deb_sig);
    input sig, CLK;
    output deb_sig;
    wire [2:0] Q;
    d_flip_flop d_ff1 (sig, CLK, Q[0]);
    d_flip_flop d_ff2 (Q[0], CLK, Q[1]);
    d_flip_flop d_ff3 (Q[1], CLK, Q[2]);

    assign deb_sig = Q[0] & Q[1] & ~Q[2];

endmodule