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
        repeat (1000) // 500 milisecond. 
            #500 CLK = ~CLK;
    end

    initial begin
        $dumpfile("control_fsm_test.vcd");
        $dumpvars(0, control_fsm_test);

        RESET = 1'b1; #10
        RESET = 1'b0; #10

        // first car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #12000;
        
        // second car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #12000;
        
        // third car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #12000;

        // forth car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #12000;

        // another car can not enter
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #12000;

        // one car exits
        entry_sensor = 1'b0;
        exit_sensor = 1'b1;
        vacant_parking = 2'b10; #1500

        exit_sensor = 1'b0;

        #12000;

        // one car exits
        entry_sensor = 1'b0;
        exit_sensor = 1'b1;
        vacant_parking = 2'b00; #1500

        exit_sensor = 1'b0;

        #12000;

        // one car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500

        entry_sensor = 1'b0;

        #12000;


    end

endmodule