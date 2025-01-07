`include "control_fsm.v"
`timescale 1us / 100ns

module control_fsm_file_test();

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

    integer infile, outfile, scan_status;
    reg [3:0] inp;
    reg d ,f;

    initial begin
        $dumpfile("control_fsm_file_test.vcd");
        $dumpvars(0, control_fsm_file_test);

        infile = $fopen("input.txt", "r");
        if (infile == 0) begin
            $display("Error: Could not open input file");
            $finish;
        end

        outfile = $fopen("output.txt", "w");
        if (outfile == 0) begin
            $display("Error : Could not open output file");
            $finish;
        end

        RESET = 1'b1; #10
        RESET = 1'b0; #10

        while (!$feof(infile)) begin
            scan_status = $fscanf(infile, "%b\n", inp);
            if (scan_status == 1) begin
                entry_sensor = inp[3];
                exit_sensor = inp[2];
                vacant_parking = inp[1:0];
                #1000;
                if (entry_sensor)
                    entry_sensor = 1'b0;
                if (exit_sensor)
                    exit_sensor = 1'b0;
                if (full_signal)
                    f = 1'b1;
                if (door_open_signal) 
                    d = 1'b1;
                #12000;
                $fwrite(outfile, "%b [%d,%d] ", parkings, capacity, best_location);
                if (f) begin
                    $fwrite(outfile, " full");
                    f = 1'b0;
                end
                if (d) begin
                    $fwrite(outfile, " door");
                    d = 1'b0;
                end
                $fwrite (outfile, "\n"); 
            end else begin
                $display("Error : Failed to read data from file");
            end
        end

        $fclose(infile);
        $fclose(outfile);

        end

endmodule