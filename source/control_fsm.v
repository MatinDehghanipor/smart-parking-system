// clock frequency : 1 KHz
// RESET siganl is active high
`include "../source/hsm_timer.v"

module control_fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				left_binary, right_binary, display_mode,
                parkings, door_open_signal, full_signal);
    
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
	output reg door_open_signal, full_signal;
    output reg [6:0] left_binary, right_binary;
	output reg [3:0] parkings;

    reg [2:0] state;
    parameter IDLE = 3'b000 , DOOR_OPEN = 3'b001 , FULL = 3'b010 , CAR_ENTERING = 3'b011 , CAR_EXITING = 3'b100;

    // with 1KHz clock frequency we can count at most 63s 
	reg [15:0] timer;
    reg [5:0] counter;
    parameter DOOR_OPEN_DELAY = 250;
    parameter FULL_DELAY = 500;

    output reg display_mode;
    reg [13:0] display_timer;
    parameter DISPLAY_TIMER = 1'b0, DISPLAY_INFO = 1'b1;

    reg p0_timer_enable, p1_timer_enable, p2_timer_enable, p3_timer_enable;
    wire [6:0] p0_hours, p1_hours, p2_hours, p3_hours;
    wire [6:0] p0_minutes, p1_minutes, p2_minutes, p3_minutes;
    wire [6:0] p0_seconds, p1_seconds, p2_seconds, p3_seconds;
    
    // four timers for recording parking time
    // we control enables of these timer in always block
    hsm_timer p0_timer (p0_timer_enable, CLK, RESET, p0_hours, p0_minutes, p0_seconds);
    hsm_timer p1_timer (p1_timer_enable, CLK, RESET, p1_hours, p1_minutes, p1_seconds);
    hsm_timer p2_timer (p2_timer_enable, CLK, RESET, p2_hours, p2_minutes, p2_seconds);
    hsm_timer p3_timer (p3_timer_enable, CLK, RESET, p3_hours, p3_minutes, p3_seconds);

    reg [2:0] capacity;
	wire [1:0] best_location;
    reg [1:0] exiting_car;

    wire full;
    
    // 0 -> exiting
    // 1 -> entering
    reg temp_state;

    assign full = parkings[0] & parkings[1] & parkings[2] & parkings[3];

    // The case in which parkings is equal to 1111 is considered as don't care
    assign best_location[1] = parkings[0] & parkings[1];
    assign best_location[0] = ((~parkings[1]) & parkings[0]) |
                                (parkings[2] & parkings[0]);
   		                      
    always @ (posedge CLK or posedge RESET) begin
        // Initializing all regesters to default value
        if (RESET) begin
            state = IDLE; // Initializing to IDLE
            parkings = 4'b0000;
            capacity = 3'b100;
            door_open_signal = 1'b0;
            full_signal = 1'b0;
            p0_timer_enable = 0;
            p1_timer_enable = 0;
            p2_timer_enable = 0;
            p3_timer_enable = 0;
            display_timer = 0;
            display_mode = DISPLAY_INFO;
            exiting_car = 0;
        end 
        else begin
            case (state)
                IDLE : begin
                    timer = 0;
                    counter = 0;
                    if (entry_sensor & ~exit_sensor)
                        if (full) begin
                            state = FULL; // state change
    						full_signal = 1'b1;
    					end
                        else begin
                            state = DOOR_OPEN; // state change
                            temp_state = 1'b1; // entering
	    					door_open_signal = 1'b1;
                        end
                    if (~entry_sensor & exit_sensor)
                        // Exiting car must exist!
                        if (~vacant_parking[1] & ~vacant_parking[0] & parkings[0] |
                            ~vacant_parking[1] & vacant_parking[0] & parkings[1] |
                            vacant_parking[1] & ~vacant_parking[0] & parkings[2] |
                            vacant_parking[1] & vacant_parking[0] & parkings[3])
                        begin
                            state = DOOR_OPEN; // state change
                            temp_state = 1'b0; // exiting
						    door_open_signal = 1'b1; // turing door_open_signal on
                            case (vacant_parking) // disabling exiting car's timer
                                2'b00 : p0_timer_enable = 1'b0;
                                2'b01 : p1_timer_enable = 1'b0;
                                2'b10 : p2_timer_enable = 1'b0;
                                2'b11 : p3_timer_enable = 1'b0;
                            endcase
                            display_mode = DISPLAY_TIMER; // we must show the time when a car is exiting
                            // display_timer = 0;
                            exiting_car = vacant_parking;
                        end
                end

                DOOR_OPEN : begin
			    	timer = timer + 1;
                    if (timer > DOOR_OPEN_DELAY) begin
                        timer = 0;
                        counter = counter + 1;
                        door_open_signal = ~door_open_signal; // door_open_signal toggling
                    end
				    if (counter > 38) begin
					    if (temp_state) begin
                            state = CAR_ENTERING; // state change
                            case (best_location) // enabling entering car's timer. this discards previous saved time record 
                                2'b00 : p0_timer_enable = 1'b1;
                                2'b01 : p1_timer_enable = 1'b1;
                                2'b10 : p2_timer_enable = 1'b1;
                                2'b11 : p3_timer_enable = 1'b1;
                            endcase
                        end
                        else begin
                            state = CAR_EXITING; // state change
                        end
    					door_open_signal = 1'b0; // after 10 seconds door_open_signal must be turned off
                        timer = 0; // reseting timer for next cars
	    			end
		    	end

                FULL : begin
                    timer = timer + 1;
                    if (timer > FULL_DELAY) begin
                        timer = 0;
                        counter = counter + 1;
                        full_signal = ~full_signal; // full_signal toggling
                    end
    				if (counter > 4) begin
	    				state = IDLE; // state change
		    			full_signal = 1'b0; // after 3 seconds full_signal must be turned off
			    	end
			    end

                // in these two states we handle parkings when a car enters or exits
                CAR_ENTERING : begin 
		    		parkings[3] = parkings[3] | (parkings[0] & parkings[1] & parkings[2]);
			    	parkings[2] = parkings[2] | (parkings[0] & parkings[1]);
				    parkings[1] = parkings[1] | parkings[0];
					parkings[0] = 1'b1;

                    capacity = capacity - 1;

                    state = IDLE; // state change
				end

                CAR_EXITING: begin
	    			parkings[0] = parkings[0] & ~(~vacant_parking[1] & ~vacant_parking[0]);
		    		parkings[1] = parkings[1] & ~(~vacant_parking[1] & vacant_parking[0]);
			    	parkings[2] = parkings[2] & ~(vacant_parking[1] & ~vacant_parking[0]);
				    parkings[3] = parkings[3] & ~(vacant_parking[1] & vacant_parking[0]);

                    capacity = capacity + 1;

                    state = IDLE; // state change
				end
            endcase
            
            // in this case statement we handle displaying information and time with help of display_mode register
            case (display_mode)
                DISPLAY_INFO : begin
                    left_binary = {4'b0000, capacity};
                    right_binary = {5'b00000, best_location};
                end
                DISPLAY_TIMER : begin 
                    if (display_timer < 15_000) begin
                        case (exiting_car)
                            2'b00 : begin
                                left_binary = p0_hours;
                                right_binary = p0_minutes;
                            end
                            2'b01 : begin
                                left_binary = p1_hours;
                                right_binary = p1_minutes;
                            end
                            2'b10 : begin
                                left_binary = p2_hours;
                                right_binary = p2_minutes;
                            end
                            2'b11 : begin
                                left_binary = p3_hours;
                                right_binary = p3_minutes;
                            end
                        endcase
                        display_timer = display_timer + 1;
                    end
                    else begin
                        display_mode = DISPLAY_INFO; // back to displaying information
                        display_timer = 0; // reseting display_timer
                    end
                    // display_timer = display_timer + 1;
                end
            endcase
        end
    end                            
endmodule