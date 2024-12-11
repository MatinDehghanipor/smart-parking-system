`timescale 1ns / 100ps

// clock frequency : 1 KHz

module control_fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				capacity, best_location, parkings, door_open_signal, full_signal);
    
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
	output door_open_signal, full_signal;
	output reg [2:0] capacity;
	output reg [1:0] best_location;
	output reg [3:0] parkings;

	reg [15:0] timer;

    reg [1:0] state;
    parameter IDLE = 2'b00 , DOOR_OPEN = 2'b01 , FULL = 2'b10 , ASSIGN_PARKING = 2'b11;

    reg full, empty;

    assign full = parkings[0] & parkings[1] & parkings[2] & parkings[3];
	assign empty = ~(parkings[0] | parkings[1] | parkings[2] | parkings[3]);

    assign capacity[2] = empty;
    assign capacity[1] = (~parkings[0] & ~parkings[1] & parkings[2]) |
                        (~parkings[1] & ~parkings[2] & parkings[3]) |
                        (parkings[0] & ~parkings[1] & ~parkings[3]) |
                        (parkings[1] & ~parkings[2] & ~parkings[3]) |
                        (~parkings[0] & parkings[1] & ~parkings[3]) |
                        (~parkings[0] & parkings[1] & ~parkings[2]);

    assign capacity[0] = (parkings[1] ^ parkings[3]) | 
                        (parkings[0] ^ parkings[2]);

    // The case in which parkings is equal to 1111 is considered don't care
    assign best_location[1] = parkings[0] & parkings[1];
    assign best_location[0] = ((~parkings[1]) & parkings[0]) |
                                (parkings[2] & parkings[0]);

    reg inp;
	
	assign inp = {entry_sensor, exit_sensor};    
		                      
    always @ (posedge CLK or posedge RESET) begin
        if (RESET) begin
            state = 2'b00; // Initialize to IDLE
            parkings = 4'b0000;
            capacity = 2'b00;
            best_location = 2'b00;
            full = 1'b0;
            empty = 1'b0;
        end

        case (state)
            IDLE : begin
				timer = 16'b0000000000000000;
                if (entery_sensor & ~exit_sensor)
                    if (full)
                        state = FULL;
						full_signal = 1'b1;
                    else begin
                        state = DOOR_OPEN;
						door_open_signal = 1'b1;
                    end
                if (~entery_sensor & exit_sensor)
                    if (~empty) begin
                        state = DOOR_OPEN;
						door_open_signal = 1'b1;
                    end
             end

            DOOR_OPEN : begin
				timer = timer + 1;
				if (timer > 10000) begin
					state = IDLE;
					door_open_signal = 1'b0;
				end

			 end

            FULL : begin 
				timer = timer + 1;
				if (timer > 3000) begin
					state = IDLE;
					full_signal = 1'b0;
				end
			end

            ASSIGN_PARKING : begin 
                case (parkings)
					4'b0000:
					begin
						if (inp == 2'b10)
							parkings = 4'b0001;
					end
					4'b0001: 
					begin
						if (inp == 2'b10)
							parkings = 4'b0011;
						if (inp == 2'b01 & vacant_parking == 2'b00)
							parkings = 4'b0000;
					end	
					4'b0010: 
					begin
						if (inp == 2'b10)
							parkings = 4'b0011;
						if (inp == 2'b01 & vacant_parking == 2'b01)
							parkings = 4'b0000;
					end
					4'b0011: 
					begin
						if (inp == 2'b10)
							parkings = 4'b0111;
						if (inp == 2'b01 & vacant_parking == 2'b01)
							parkings = 4'b0001;
						if (inp == 2'b01 & vacant_parking == 2'b00)
							parkings = 4'b0010;
					end	
					4'b0100: 
					begin
						if (inp == 2'b10)
							parkings = 4'b0101;
						if (inp == 2'b01 & vacant_parking == 2'b10)
							parkings = 4'b0000;
					end
					4'b0101: 
					begin
						if (inp == 2'b10)
							parkings = 4'b0111;
						if (inp == 2'b01 & vacant_parking == 2'b00)
							parkings = 4'b0100;
						if (inp == 2'b01 & vacant_parking == 2'b10)
							parkings = 4'b0001;
					end
					4'b0110: 
					begin
						if (inp == 2'b10)
							parkings = 4'b0111;
						if (inp == 2'b01 & vacant_parking == 2'b01)
							parkings = 4'b0100;
						if (inp == 2'b01 & vacant_parking == 2'b10)
							parkings = 4'b0010;
					end
					4'b0111: 
					begin
						if (inp == 2'b10)
							parkings = 4'b1111;
						if (inp == 2'b01 & vacant_parking == 2'b00)
							parkings = 4'b0110;
						if (inp == 2'b01 & vacant_parking == 2'b10)
							parkings = 4'b0011;
						if (inp == 2'b01 & vacant_parking == 2'b01)
							parkings = 4'b0101;
				end	
			4'b1000: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1001;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0000;
				end
			4'b1001: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1011;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0001;
				if (inp == 2'b01 & vacant_parking == 2'b00)
					parkings = 4'b1000;
				end	
			4'b1010: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1011;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0010;
				if (inp == 2'b01 & vacant_parking == 2'b01)
					parkings = 4'b1000;
				end
			4'b1011: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1111;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0011;
				if (inp == 2'b01 & vacant_parking == 2'b01)
					parkings = 4'b1001;
				if (inp == 2'b01 & vacant_parking == 2'b00)
					parkings = 4'b1010;
				end	
			4'b1100: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1101;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0100;
				if (inp == 2'b01 & vacant_parking == 2'b10)
					parkings = 4'b1000;
				end
			4'b1101: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1111;
				if (inp == 2'b01 & vacant_parking == 2'b10)
					parkings = 4'b0101;
				if (inp == 2'b01 & vacant_parking == 2'b10)
					parkings = 4'b1001;
				if (inp == 2'b01 & vacant_parking == 2'b00)
					parkings = 4'b1100;
				end
			4'b1110: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1111;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0110;
				if (inp == 2'b01 & vacant_parking == 2'b10)
					parkings = 4'b1010;
				if (inp == 2'b01 & vacant_parking == 2'b01)
					parkings = 4'b1100;
				end
			4'b1111: 
				begin
				if (inp == 2'b10)
					parkings = 4'b1111;
				if (inp == 2'b01 & vacant_parking == 2'b11)
					parkings = 4'b0111;
				if (inp == 2'b01 & vacant_parking == 2'b10)
					parkings = 4'1011;
				if (inp == 2'b01 & vacant_parking == 2'b01)
					parkings = 4'b1101;
				if (inp == 2'b01 & vacant_parking == 2'b00)
					parkings = 4'b1110;
				end						
		endcase
            end

        endcase
    end                            
    

endmodule