// Binh Doan
// ECE 5440
// Module: scoreCounter
// Inputs: scoreFlag, rst
// Outputs: scoreDigitR
// Description: count the total score earned by the player
module scoreCounter(scoreFlag, rst, score);
	input scoreFlag, rst;
	output reg[6:0] score;

	always @(posedge scoreFlag, negedge rst)
	begin
		if(rst == 0)
		begin
			score	<= 0;
		end
		else
		begin
			if(scoreFlag)
			begin
				score <= score + 1;	// run out of digits?
							// no worry, no one can't beat over 99 points;
			end
		end
	end
endmodule