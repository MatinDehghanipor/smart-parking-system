module d_flip_flop(D, CLK, Q);
    input D, CLK;
    output reg Q;
    
    always @ (posedge CLK)
        Q <= D;

endmodule