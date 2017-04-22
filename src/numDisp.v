// ECE 5440
// Binh Doan - 1377079
// ECE 5440
// Input: num
// Output: seg
// Description: Show a 1-digit number in hex on the 7-segment display

module numDisp (num, seg);
	input[3:0] num;
	output[6:0] seg;
	reg[6:0] seg;

	always @ (num)	begin
		case(num)
			4'd0: begin seg = 7'b1000000;	end	// 0
			4'd1: begin seg = 7'b1111001;	end	// 1
			4'd2: begin seg = 7'b0100100;	end	// 2
			4'd3: begin seg = 7'b0110000;	end	// 3
			4'd4: begin seg = 7'b0011001;	end	// 4
			4'd5: begin seg = 7'b0010010;	end	// 5
			4'd6: begin seg = 7'b0000010;	end	// 6
			4'd7: begin seg = 7'b1111000;	end	// 7		
			4'd8: begin seg = 7'b0000000;	end	// 8
			4'd9: begin seg = 7'b0010000;	end	// 9
			4'd10: begin seg = 7'b0001000;	end	// A 
			4'd11: begin seg = 7'b0000000;	end	// B 
			4'd12: begin seg = 7'b1000110;	end	// C 
			4'd13: begin seg = 7'b1000000;	end	// D 
			4'd14: begin seg = 7'b0000110;	end	// E 
			4'd15: begin seg = 7'b0001110;	end	// F 
			default: begin seg = 7'b0000000;	end	// black out 
		endcase
	end
endmodule
