`timescale 1ns / 100ps

// clock frequency : 1 KHz
// RESET siganl is active high

module control_fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				capacity, best_location, parkings, door_open_signal, full_signal);
    
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
	output reg door_open_signal, full_signal;
	output [2:0] capacity;
	output [1:0] best_location;
	output reg [3:0] parkings;

    // with 1KHz clock frequency we can count at most 63s 
	reg [15:0] timer;

    reg [1:0] state;
    parameter IDLE = 2'b00 , DOOR_OPEN = 2'b01 , FULL = 2'b10 , ASSIGN_PARKING = 2'b11;

    wire full, empty;

    assign full = parkings[0] & parkings[1] & parkings[2] & parkings[3];
	assign empty = ~(parkings[0] | parkings[1] | parkings[2] | parkings[3]);

    assign capacity[2] = empty;
    assign capacity[1] = ((~parkings[0] & ~parkings[1] & parkings[2]) |
                        (~parkings[1] & ~parkings[2] & parkings[3]) |
                        (parkings[0] & ~parkings[1] & ~parkings[3]) |
                        (parkings[1] & ~parkings[2] & ~parkings[3]) |
                        (~parkings[0] & parkings[1] & ~parkings[3]) |
                        (~parkings[0] & parkings[1] & ~parkings[2]));

    assign capacity[0] = ((parkings[1] ^ parkings[3]) | 
                        (parkings[0] ^ parkings[2]));

    // The case in which parkings is equal to 1111 is considered don't care
    assign best_location[1] = parkings[0] & parkings[1];
    assign best_location[0] = (((~parkings[1]) & parkings[0]) |
                                (parkings[2] & parkings[0]));
   		                      
    always @ (posedge CLK or posedge RESET) begin
        if (RESET) begin
            state = IDLE; // Initialize to IDLE
            parkings = 4'b0000;
            door_open_signal = 1'b0;
            full_signal = 1'b0;
        end 
        else begin
            // timer <= timer;  // Default assignments to prevent latches
            // state <= state;  // Default assignments to prevent latches
            case (state)
                IDLE : begin
    				timer <= 16'b0000000000000001;
                    if (entry_sensor & ~exit_sensor)
                        if (full) begin
                            state = FULL;
    						full_signal = 1'b1;
    					end
                        else begin
                            state = DOOR_OPEN;
	    					door_open_signal = 1'b1;
                        end
                    if (~entry_sensor & exit_sensor)
                        if (~empty) begin
                            state = DOOR_OPEN;
						    door_open_signal = 1'b1;
                        end
                end

                DOOR_OPEN : begin
			    	timer = timer + 1;
				    if (timer > 10 /*IT MUST BE 10000*/) begin
					    state = ASSIGN_PARKING;
    					door_open_signal = 1'b0;
	    			end
		    	 end

                FULL : begin 
				    timer = timer + 1;
    				if (timer > 3 /*IT MUST BE 3000*/) begin
	    				state = IDLE;
		    			full_signal = 1'b0;
			    	end
			    end

                ASSIGN_PARKING : begin 
	    			if (entry_sensor & ~exit_sensor) begin
		    			parkings[3] = parkings[3] |  (parkings[0] & parkings[1] & parkings[2]);
			    		parkings[2] = parkings[2] | (parkings[0] & parkings[1]);
				    	parkings[1] = parkings[1] | parkings[2];
					    parkings[0] = 1'b1;
				    end

    				if (~entry_sensor & exit_sensor) begin
	    				parkings[3] = parkings[3] & (~vacant_parking[0] | ~vacant_parking[1]);
		    			parkings[2] = parkings[2] & (~vacant_parking[0] | vacant_parking[1]);
			    		parkings[1] = parkings[1] & (vacant_parking[0] | ~vacant_parking[1]);
				    	parkings[0] = parkings[0] & (vacant_parking[0] | vacant_parking[1]);
				    end
                    state = IDLE;
			    end
            endcase
        end
    end                            

endmodule