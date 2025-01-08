// input frequecny : 40 MHz
`include "debouncer.v"
`include "frequency_divider.v"
`include "control_fsm.v"
`include "full_signal_control.v"
`include "door_open_signal_control.v"
`include "binary_bcd.v"
`include "bcd_seven_segment.v"
 
module manage_parking(entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
                selected_segment, slected_data, parkings, door_open_signal, full_signal);
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
    output door_open_signal, full_signal;
    output [3:0] parkings;
    output [3:0] selected_segment;
    output [7:0] slected_data; 

    wire clk_1khz, clk_100hz, clk_2hz, clk_1hz;

    frequency_divider freq_divider (CLK, RESET, clk_1hz, clk_2hz, clk_100hz, clk_1khz);

    wire deb_entry_sensor, deb_exit_sensor;
    wire [1:0] deb_vacant_parking;

    debouncer deb1 (clk_1khz, entry_sensor, deb_entry_sensor);
    debouncer deb2 (clk_1khz, exit_sensor, deb_exit_sensor);

    wire [2:0] capacity;
    wire [1:0] best_location;
    wire steady_door_open_signal, steady_full_signal;

    control_fsm fsm (deb_entry_sensor, deb_exit_sensor, vacant_parking,
				clk_1khz , RESET,
				capacity, best_location, parkings, steady_door_open_signal, steady_full_signal);

    // full_signal_control full_control (steady_full_signal, clk_1hz, full_signal);
    // door_open_signal_control door_open_control (steady_door_open_signal, clk_2hz, door_open_signal);
	assign door_open_signal = steady_door_open_signal & clk_2hz;
	assign full_signal = steady_full_signal & clk_1hz;
    wire [7:0] capacity_bcd;
    wire [7:0] best_location_bcd;

    binary_bcd conv1 ({4'b0000, capacity}, capacity_bcd);
    binary_bcd conv2 ({5'b00000, best_location}, best_location_bcd);

    bcd_seven_segment conv3 ({capacity_bcd, best_location_bcd}, clk_100hz, RESET, selected_segment, slected_data); 

endmodule
