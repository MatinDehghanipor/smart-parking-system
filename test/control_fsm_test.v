`include "../source/control_fsm.v"
`timescale 1us / 100ns

module control_fsm_test();
    wire door_open_signal, full_signal;
	wire [6:0] left_binary, right_binary;
    wire display_mode;
    wire [3:0] parkings;

    reg entry_sensor, exit_sensor, CLK, RESET;
	reg [1:0] vacant_parking;

    control_fsm fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				left_binary, right_binary, display_mode,
                parkings, door_open_signal, full_signal);

    initial begin
        // $monitor("parkings : %b", parkings);
        $monitor ("left_binary : %b  right_binary : %b  display_mode : %b", left_binary, right_binary, display_mode);
    end

    initial begin
        // $monitor("door_open_signal : %b", door_open_signal);
    end

    initial begin
        CLK = 1'b1;
        repeat (2_000_000) // 1000 second. 
            #500 CLK = ~CLK;
    end


    initial begin
        RESET = 1'b1; #10
        RESET = 1'b0; #10

        // first car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #130_000_000;

        // one car exits
        entry_sensor = 1'b0;
        exit_sensor = 1'b1;
        vacant_parking = 2'b00; #1500

        exit_sensor = 1'b0;

        #16_000_000;

        // second car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #1500;

        entry_sensor = 1'b0;

        #70_000_000;

        // one car exits
        entry_sensor = 1'b0;
        exit_sensor = 1'b1;
        vacant_parking = 2'b00; #1500

        exit_sensor = 1'b0;

        #16_000_000;
        
        // // third car enters
        // entry_sensor = 1'b1;
        // exit_sensor = 1'b0; #1500;

        // entry_sensor = 1'b0;

        // #16_000_000;

        // // forth car enters
        // entry_sensor = 1'b1;
        // exit_sensor = 1'b0; #1500;

        // entry_sensor = 1'b0;

        // #16_000_000;

        // // another car can not enter
        // entry_sensor = 1'b1;
        // exit_sensor = 1'b0; #1500;

        // entry_sensor = 1'b0;

        // #16_000_000;

        // // one car exits
        // entry_sensor = 1'b0;
        // exit_sensor = 1'b1;
        // vacant_parking = 2'b10; #1500

        // exit_sensor = 1'b0;

        // #16_000_000;

        // // one car exits
        // entry_sensor = 1'b0;
        // exit_sensor = 1'b1;
        // vacant_parking = 2'b00; #1500

        // exit_sensor = 1'b0;

        // #16_000_000;

        // // one car enters
        // entry_sensor = 1'b1;
        // exit_sensor = 1'b0; #1500

        // entry_sensor = 1'b0;

        // #16_000_000;

        $finish;

    end

endmodule