`timescale 1ns / 1ps

module manage_parking(entry_sensor, exit_sensor, vacant_parking,
				CLK ,
				parkings);
	
	input entry_sensor, exit_sensor, CLK;
	input [1:0] vacant_parking;
	output reg [2:0] capacity;
	
	reg inp;
	
	initial begin
		parkings = 4'b0000;
		
	end
	
	assign inp = {entry_sensor, exit_sensor};
	
	always @ (posedge CLK) begin
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


endmodule
