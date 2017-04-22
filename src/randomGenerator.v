// Binh Doan
// ECE 5440
// Module: randomGenerator
// inputs: request, clk, rst
// Outputs: numRand
// Description: generate a 4-bit random number from a 32-bit LFSR sequence

module randomGenerator(request, clk, rst, numRand);
	input clk, rst, request;
	output reg[15:0] numRand;
	reg [15:0] LFSR1, LFSR2;
	wire [15:0] num;
	
	always @(posedge clk, negedge rst)
	begin
		if(rst == 0)
		begin
			LFSR1 	<= 16'hFFFF;
			LFSR2	<= 16'h0000;
			numRand <= 4'd0;
		end
		else 
		if(request)
		begin
			numRand <= num;
		end
		else
		begin
			LFSR1[0] <= LFSR1[1] ^ LFSR1[2] ^ LFSR1[4] ^ LFSR1[15];
			LFSR1[15:1] <= LFSR1[14:0];

			LFSR2[0] <= ~LFSR2[1] ^ LFSR2[2] ^ LFSR2[4] ^ LFSR2[15];
    			LFSR2[15:1] <= LFSR2[14:0];
		end
	end

	assign num[0] = LFSR1[0];assign num[1] = LFSR1[1];assign num[2] = LFSR2[0];assign num[3] = LFSR2[1];
	assign num[4] = LFSR1[2];assign num[5] = LFSR1[5];assign num[6] = LFSR2[4];assign num[7] = LFSR2[11];
	assign num[8] = LFSR1[4];assign num[9] = LFSR1[9];assign num[10] = LFSR2[6];assign num[11] = LFSR2[13];
	assign num[12] = LFSR1[6];assign num[13] = LFSR1[11];assign num[14] = LFSR2[12];assign num[15] = LFSR2[15];
endmodule
