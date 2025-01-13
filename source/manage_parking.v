// input frequecny : 40 MHz
`include "debouncer.v"
`include "frequency_divider.v"
`include "control_fsm.v"
`include "binary_bcd.v"
`include "bcd_seven_segment.v"
 
module manage_parking(entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
                selected_segment, selected_data,
                parkings, door_open_signal, full_signal);
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
    output door_open_signal, full_signal;
    output [3:0] parkings;
    output [3:0] selected_segment;
    output [7:0] selected_data; 

    wire clk_1khz, clk_250hz, clk_2hz, clk_1hz;

    frequency_divider freq_divider (CLK, RESET, clk_250hz, clk_1khz);

    wire n_entry_sensor, n_exit_sensor;
    not n1 (n_entry_sensor, entry_sensor);
    not n2 (n_exit_sensor, exit_sensor);

    wire deb_entry_sensor, deb_exit_sensor;
    debouncer deb1 (clk_1khz, n_entry_sensor, deb_entry_sensor);
    debouncer deb2 (clk_1khz, n_exit_sensor, deb_exit_sensor);

    wire [6:0] left_binary, right_binary;
    wire display_mode;

    control_fsm fsm (deb_entry_sensor, deb_exit_sensor, vacant_parking,
				clk_1khz , RESET,
				left_binary, right_binary, display_mode,
                parkings, door_open_signal, full_signal);

    wire [7:0] left_bcd, right_bcd;

    binary_bcd conv1 (left_binary, left_bcd);
    binary_bcd conv2 (right_binary, right_bcd);

    bcd_seven_segment conv3 ({left_bcd, right_bcd}, clk_250hz, RESET, selected_segment, selected_data); 

endmodule
