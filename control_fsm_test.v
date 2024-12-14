`include "control_fsm.v"
`timescale 1us / 100ns

module control_fsm_test();

    wire door_open_signal, full_signal;
	wire [2:0] capacity;
	wire [1:0] best_location;
	wire [3:0] parkings;

    reg entry_sensor, exit_sensor, CLK, RESET;
	reg [1:0] vacant_parking;

    control_fsm fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				capacity, best_location, parkings, door_open_signal, full_signal);

    initial begin
        CLK = 1'b1;
        repeat (100) // 50 milisecond. 
            #500 CLK = ~CLK;
    end

    initial begin
        $dumpfile("control_fsm_test.vcd");
        $dumpvars(0, control_fsm_test);

        RESET = 1'b1; #10
        RESET = 1'b0; #10

        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;
        exit_sensor = 1'b0;


        

    end

endmodule