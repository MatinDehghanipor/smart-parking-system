`timescale 1ns / 1ps

module control_fsm (entry_sensor, exit_sensor, vacant_parking,
				CLK , RESET,
				capacity, best_location, parkings, door_open_signal, full_signal);
    
    input entry_sensor, exit_sensor, CLK, RESET;
	input [1:0] vacant_parking;
	output door_open_signal, full_signal;
	output reg [2:0] capacity;
	output reg [1:0] best_location;
	output reg [3:0] parkings;

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

    always @ (posedge CLK or posedge RESET) begin
        if (RESET) begin
            state = 2'b00;
            parkings = 4'b0000;
            capacity = 2'b00;
            best_location = 2'b00;
            full = 1'b0;
            empty = 1'b0;
        end

        case (state)
            IDLE : begin end

            DOOR_OPEN : begin end

            FULL : begin end

            ASSIGN_PARKING : begin end

        endcase
    end                            
    

endmodule