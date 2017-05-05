// when startCount = 0, we can set the timeMax.
// then we set setTimeMaxFlag_s = 1 to update the timeMax to the counter
// then we set setTimeMaxFlag_s = 0 to get the counter ready
// set startCount = 1 to start the counter.


module CountDownTimer(rst, startCount, gameOverFlag, setTimeMaxFlag_s, KEY1_s, in_100ms_s, 
		secDigit2_out, secDigit1_out, msDigit1_out, minDigit1_out, timeOutFlag, minOutFlag, secOutFlag);
	input rst, in_100ms_s, setTimeMaxFlag_s, KEY1_s, startCount, gameOverFlag;
	output reg[3:0] secDigit2_out, secDigit1_out, msDigit1_out, minDigit1_out;
	output reg timeOutFlag, minOutFlag, secOutFlag;
	reg flag1s, flag1min;
	reg[3:0] secMax, minMax, secDigit2, minDigit1;

	always @ (secMax, secDigit2, gameOverFlag, minDigit1)	begin
		if(gameOverFlag||timeOutFlag)	begin
			minDigit1_out = 0;
			secDigit2_out = 0;
		end
		else	if(~startCount)	begin
			minDigit1_out = minMax;
			secDigit2_out = secMax;
		end
		else 	begin
			minDigit1_out = minDigit1;
			secDigit2_out = secDigit2;
		end
	end
	always@(posedge in_100ms_s, negedge rst)	begin
		if(~rst)	begin
			msDigit1_out <= 4'd0;
			flag1s <= 0;
			timeOutFlag <= 0;
		end
		else	begin
			if(msDigit1_out == 4'd0)	begin
				if(secOutFlag)	begin
					timeOutFlag <= 1;
					msDigit1_out <= 4'd0;
				end
				else	begin
					msDigit1_out <= 4'd9;
					flag1s <= 1;
				end
			end
			else	begin
				msDigit1_out <= msDigit1_out - 4'd1;
				flag1s <= 0;
			end
		end
	end

	always @ (negedge rst, posedge setTimeMaxFlag_s, posedge flag1s)	begin
		if(!rst)	begin
			secDigit2 <= secMax;
			secDigit1_out <= 4'd0;
			flag1min <= 0;
			secOutFlag <= 0;
		end
		else	begin
			if(setTimeMaxFlag_s)	begin
				secDigit2 <= secMax;
			end			
			else	begin
				if(secDigit2 == 0)	begin
					if(secDigit1_out == 0)	begin
						flag1min <= 1;
						secDigit2 <= 4'd5;
						secDigit1_out <= 4'd9;			
					end
					else if((minOutFlag || (minDigit1 == 0))&&secDigit1_out==4'd1)	begin
						secOutFlag <= 1;
						secDigit2 <= 4'd0;
						secDigit1_out <= 4'd0;
					end
					else	begin
						secDigit1_out <= secDigit1_out - 4'd1;
					end
				end
				else	begin
					if(secDigit1_out == 0)	begin
						secDigit2 <= secDigit2 - 4'd1;
						secDigit1_out <= 4'd9;
					end
					else	begin
						secDigit1_out <= secDigit1_out - 4'd1;
						flag1min <= 0;
					end
				end
			end
		end
	end

	always @(posedge flag1min, posedge setTimeMaxFlag_s, negedge rst)	begin
		if(~rst)	begin
			minOutFlag <= 0;
			minDigit1 <= minMax;
		end
		else	begin
			if(setTimeMaxFlag_s)	begin
				minDigit1 <= minMax;
			end
			else	begin
				if(minDigit1 == 4'd1)	begin
					minOutFlag <= 1;
					minDigit1 <= 4'd0;
				end
				else	begin
					minDigit1 <= minDigit1 - 4'd1;
				end
			end
		end
	end

	always @(posedge KEY1_s, negedge rst)	begin
		if(~rst)	begin
			//the default starting time
			secMax <= 4'd2;
			minMax <= 4'd0;
		end
		else	begin
			if(~startCount)	begin
				if(minMax == 4'd9 && secMax == 4'd5)	begin
					minMax <= 4'd0;
					secMax <= 4'd1;
				end
				else	begin
					if(secMax == 4'd5)	begin
						secMax <= 4'd0;
						minMax <= minMax + 4'd1;
					end
					else	begin
						secMax <= secMax + 4'd1;
					end
				end
			end
		end
	end
endmodule	
				
