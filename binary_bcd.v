module binary_bcd (bin, bcd);
    input [6:0] bin;
    output reg [7:0] bcd;

    reg [6:0] temp;

    always @ (bin) begin
        if (bin >= 0 & bin < 10) begin
            temp = bin;
            bcd = {4'b0000, temp[3:0]};
        end
        if (bin >= 10 & bin < 20) begin
            temp = bin - 10;
            bcd = {4'b0001, temp[3:0]}; 
        end
        if (bin >= 20 & bin < 30) begin
            temp = bin - 20;
            bcd = {4'b0010, temp[3:0]}; 
        end
        if (bin >= 30 & bin < 40) begin
            temp = bin - 30;
            bcd = {4'b0011, temp[3:0]}; 
        end
        if (bin >= 40 & bin < 50) begin
            temp = bin - 40;
            bcd = {4'b0100, temp[3:0]}; 
        end
        if (bin >= 50 & bin < 60) begin
            temp = bin - 50;
            bcd = {4'b0101, temp[3:0]}; 
        end
        if (bin >= 60 & bin < 70) begin
            temp = bin - 60;
            bcd = {4'b0110, temp[3:0]}; 
        end
        if (bin >= 70 & bin < 80) begin
            temp = bin - 70;
            bcd = {4'b0111, temp[3:0]}; 
        end
        if (bin >= 80 & bin < 90) begin
            temp = bin - 80;
            bcd = {4'b1000, temp[3:0]}; 
        end
        if (bin >= 90 & bin < 100) begin
            temp = bin - 90;
            bcd = {4'b1001, temp[3:0]}; 
        end
    end

endmodule