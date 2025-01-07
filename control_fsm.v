// clock frequency : 1 KHz
// RESET siganl is active high

module control_fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				capacity, best_location, parkings, door_open_signal, full_signal);
    
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
	output reg door_open_signal, full_signal;
	output reg [2:0] capacity;
	output [1:0] best_location;
	output reg [3:0] parkings;

    // with 1KHz clock frequency we can count at most 63s 
	reg [15:0] timer;

    reg [2:0] state;
    parameter IDLE = 3'b000 , DOOR_OPEN = 3'b001 , FULL = 3'b010 , CAR_ENTERING = 3'b011 , CAR_EXITING = 3'b100;

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
        end 
        else begin
            case (state)
                IDLE : begin
                    timer <= 16'b0000000000000000;
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
				    if (timer > 10 /*FOR TEST*/ /*IT MUST BE 10000*/) begin
					    if (temp_state)
                            state = CAR_ENTERING;
                        else
                            state = CAR_EXITING;
    					door_open_signal = 1'b0;
	    			end
		    	 end

                FULL : begin 
				    timer = timer + 1;
    				if (timer > 3 /*FOR TEST*/ /*IT MUST BE 3000*/) begin
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
        end
    end                            

endmodule