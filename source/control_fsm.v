// clock frequency : 1 KHz
// RESET siganl is active high

module control_fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				left_dispaly, right_display, dispaly_mode,
                parkings, door_open_signal, full_signal);
    
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
	output reg door_open_signal, full_signal;
    output reg [6:0] left_dispaly, right_display;
	output reg [3:0] parkings;

    reg [2:0] state;
    parameter IDLE = 3'b000 , DOOR_OPEN = 3'b001 , FULL = 3'b010 , CAR_ENTERING = 3'b011 , CAR_EXITING = 3'b100;

    // with 1KHz clock frequency we can count at most 63s 
	reg [15:0] timer;
    reg [4:0] counter;
    parameter DOOR_OPEN_DELAY = 250;
    parameter FULL_DELAY = 500;

    output reg dispaly_mode;
    reg [13:0] dispaly_timer;
    parameter DISPLAY_TIMER = 1'b0, DISPLAY_INFO = 1'b1;

    reg [28:0] p0_timer, p1_timer, p2_timer, p3_timer;
    reg p0_timer_enablbe, p1_timer_enable, p2_timer_enable, p3_timer_enable;

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
        if (RESET) begin
            state = IDLE; // Initialize to IDLE
            parkings = 4'b0000;
            capacity = 3'b100;
            door_open_signal = 1'b0;
            full_signal = 1'b0;
            p0_timer = 0;
            p1_timer = 0;
            p2_timer = 0;
            p3_timer = 0;
            p0_timer_enable = 0;
            p1_timer_enable = 0;
            p2_timer_enable = 0;
            p3_timer_enable = 0;
            dispaly_timer = 0;
            exiting_car = 0;
        end 
        else begin
            case (state)
                IDLE : begin
                    timer = 0;
                    counter = 0;
                    if (entry_sensor & ~exit_sensor)
                        if (full) begin
                            state = FULL;
    						full_signal = 1'b1;
    					end
                        else begin
                            state = DOOR_OPEN;
                            temp_state = 1'b1; // Entering
	    					door_open_signal = 1'b1;
                        end
                    if (~entry_sensor & exit_sensor)
                        // Exiting car must exist!
                        if (~vacant_parking[1] & ~vacant_parking[0] & parkings[0] |
                            ~vacant_parking[1] & vacant_parking[0] & parkings[1] |
                            vacant_parking[1] & ~vacant_parking[0] & parkings[2] |
                            vacant_parking[1] & vacant_parking[0] & parkings[3])
                        begin
                            state = DOOR_OPEN;
                            temp_state = 1'b0; // Exiting
						    door_open_signal = 1'b1;
                        end
                end

                DOOR_OPEN : begin
			    	timer = timer + 1;
                    if (timer > DOOR_OPEN_DELAY) begin
                        timer = 0;
                        counter = counter + 1;
                        door_open_signal = ~door_open_signal;
                    end
				    if (counter > 38) begin
					    if (temp_state) begin
                            state = CAR_ENTERING;
                            case (best_location)
                                2'b00 : p0_timer_enable = 1'b1;
                                2'b01 : p1_timer_enable = 1'b1;
                                2'b10 : p2_timer_enable = 1'b1;
                                2'b11 : p3_timer_enable = 1'b1;
                            endcase
                        end
                        else begin
                            state = CAR_EXITING;
                            case (vacant_parking)
                                2'b00 : p0_timer_enable = 1'b0;
                                2'b01 : p1_timer_enable = 1'b0;
                                2'b10 : p2_timer_enable = 1'b0;
                                2'b11 : p3_timer_enable = 1'b0;
                            endcase
                            dispaly_mode = DISPLAY_TIMER;
                            dispaly_timer = 0;
                            exiting_car = vacant_parking;
                        end
    					door_open_signal = 1'b0;
	    			end
		    	end

                FULL : begin
                    timer = timer + 1;
                    if (timer > FULL_DELAY) begin
                        timer = 0;
                        counter = counter + 1;
                        full_signal = ~full_signal;
                    end
    				if (counter > 4) begin
	    				state = IDLE;
		    			full_signal = 1'b0;
			    	end
			    end

                CAR_ENTERING : begin 
		    		parkings[3] = parkings[3] | (parkings[0] & parkings[1] & parkings[2]);
			    	parkings[2] = parkings[2] | (parkings[0] & parkings[1]);
				    parkings[1] = parkings[1] | parkings[0];
					parkings[0] = 1'b1;

                    capacity = capacity - 1;

                    state = IDLE;
				end

                CAR_EXITING: begin
	    			parkings[0] = parkings[0] & ~(~vacant_parking[1] & ~vacant_parking[0]);
		    		parkings[1] = parkings[1] & ~(~vacant_parking[1] & vacant_parking[0]);
			    	parkings[2] = parkings[2] & ~(vacant_parking[1] & ~vacant_parking[0]);
				    parkings[3] = parkings[3] & ~(vacant_parking[1] & vacant_parking[0]);

                    capacity = capacity + 1;

                    state = IDLE;
				end
            endcase
            if (p0_timer_enable)    p0_timer = p0_timer + 1;
            if (p1_timer_enable)    p1_timer = p1_timer + 1;
            if (p2_timer_enable)    p2_timer = p2_timer + 1;
            if (p3_timer_enable)    p3_timer = p3_timer + 1; 

            if (dispaly_mode == DISPLAY_INFO) begin
                if (capacity == 0)
                   
                else begin
                    left_dispaly = {4'b0000, capacity};
                    right_display = {5'b00000, best_location};
                end
            end
            else if (dispaly_mode == DISPLAY_TIMER) begin
                dispaly_timer = dispaly_timer + 1;
                if (dispaly_timer > 15_000)
                    dispaly_mode = DISPLAY_INFO;
                    case (exiting_car)
                        2'b00 : p0_timer = 0;
                        2'b01 : p1_timer = 0;
                        2'b10 : p2_timer = 0;
                        2'b11 : p3_timer = 0;
                    endcase
                case (exiting_car)
                    2'b00 : begin
                        left_dispaly = p0_timer / 3600;
                        right_display = (p0_timer % 3600) / 60;
                    end
                    2'b01 : begin
                        left_dispaly = p1_timer / 3600;
                        right_display = (p1_timer % 3600) / 60;
                    end
                    2'b10 : begin
                        left_dispaly = p2_timer / 3600;
                        right_display = (p2_timer % 3600) / 60;
                    end
                    2'b11 : begin
                        left_dispaly = p3_timer / 3600;
                        right_display = (p3_timer % 3600) / 60;
                    end
                endcase

            end
        end
    end                            

endmodule