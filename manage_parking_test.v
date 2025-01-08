`timescale 1us / 100ns
`include "manage_parking.v"

module manage_parking_test();
    reg entry_sensor, exit_sensor, CLK, RESET;
	reg [1:0] vacant_parking;
    
    wire door_open_signal, full_signal;
    wire [3:0] parkings;
    wire [3:0] selected_segment;
    wire [7:0] slected_data;

    manage_parking manager (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
                selected_segment, slected_data, parkings, door_open_signal, full_signal);

    initial begin
        CLK = 1'b0;
        repeat (300)
            repeat (1000)
                #12.5  CLK = ~CLK;
    end

    initial begin
        $monitor("parkings : %b", parkings);
    end

    initial begin
        RESET = 1'b1; #10
        RESET = 1'b0; #10

        // first car enters
        entry_sensor = 1'b1; 
        exit_sensor = 1'b0; #4000;

        entry_sensor = 1'b0;

        #12000;
        
        // second car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #4000;

        entry_sensor = 1'b0;

        #12000;
        
        // third car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #4000;

        entry_sensor = 1'b0;

        #12000;

        // forth car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #4000;

        entry_sensor = 1'b0;

        #12000;

        // another car can not enter
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #4000;

        entry_sensor = 1'b0;

        #12000;

        // one car exits
        entry_sensor = 1'b0;
        exit_sensor = 1'b1;
        vacant_parking = 2'b10; #4000;

        exit_sensor = 1'b0;

        #12000;

        // one car exits
        entry_sensor = 1'b0;
        exit_sensor = 1'b1;
        vacant_parking = 2'b00; #4000;

        exit_sensor = 1'b0;

        #12000;

        // one car enters
        entry_sensor = 1'b1;
        exit_sensor = 1'b0; #4000;

        entry_sensor = 1'b0;

        #12000;

        $finish;
    end


endmodule