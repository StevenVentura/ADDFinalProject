// Binh Doan
// ECE5540
// Inputs: loadButton_s, passInput, rst, clk
// Outputs: accessFlag
/* Description: Access Control
User is required to enter a password, 1 bit at a time x 6 times. Each bit is loaded by the input loadButton_s.
The result returns a YES if the password is matched, and NO if it is not matched.
The result is only given after the user enters all 6 bits.
*/ 

module accessControl (userIDfoundFlag, loadButton_s, PASSWORD, passInput, clk, rst, accessFlag, blinkFlag, outOfAttemptsFlag);
	input loadButton_s, rst, clk, userIDfoundFlag;
	input[3:0] passInput;
	input[15:0] PASSWORD;
	output reg accessFlag, blinkFlag, outOfAttemptsFlag;
	reg[2:0] state;
	reg isFlagRed;
	reg[1:0] attemptCnt;

	parameter	BIT0	= 3'b000,				// 7 States
			BIT1	= 3'b001,
		 	BIT2	= 3'b010,
			BIT3	= 3'b011,
			BIT4	= 3'b100,
			BIT5	= 3'b101,
		   VERIFICATION = 3'b110,
			END	= 3'b111;

	parameter	PRESSED	= 1'b0,					
			YES 	= 1'b1,
			NO	= 1'b0;


	always @ (posedge clk, negedge rst)	begin	
		if(~rst)	begin
			state <= BIT0;
			attemptCnt <= 0;
			outOfAttemptsFlag <= NO;
		end
		else	begin
			case(state)
				BIT0: begin
					accessFlag <= NO;
					isFlagRed <= NO;
					blinkFlag <= 0;
					if(userIDfoundFlag)	begin
						if(loadButton_s == YES)	begin
							if(passInput != PASSWORD[15:12])	begin
								isFlagRed <= YES;
							end
							if(attemptCnt == 2'b111)	begin
								state <= END;
							end
							else	begin
								attemptCnt <= attemptCnt + 1;
								state <= BIT1;
							end
						end
						else begin
							state <= BIT0;
						end
					end
					else	begin
						state <= BIT0;
					end
				end
				
				BIT1: begin
					accessFlag <= NO;
					if(loadButton_s == YES)	begin
						
						if(passInput != PASSWORD[11:8])	begin
							isFlagRed = YES;
						end
						state <= BIT2;
					end
					else begin
						state <= BIT1;
					end
				end
				
				BIT2: begin
					accessFlag <= NO;
					if(loadButton_s == YES)	begin
						
						if(passInput != PASSWORD[7:4])	begin
							isFlagRed <= YES;
						end
						state <= BIT3;
					end
					else begin
						state <= BIT2;
					end
				end
				BIT3: begin
					accessFlag <= NO;
					if(loadButton_s == YES)	begin
						
						if(passInput != PASSWORD[3:0])	begin
							isFlagRed <= YES;
						end
						state <= VERIFICATION;
					end
					else begin
						state <= BIT3;
					end
				end
				VERIFICATION:	begin
					if(isFlagRed == NO)	begin
						accessFlag <= YES;
						state <= VERIFICATION;
					end
					else begin
						accessFlag <= NO;
						blinkFlag <= 1;
						state <= BIT0;
					end
				end
				END:	begin
					outOfAttemptsFlag <= YES;
					accessFlag <= NO;
					state <= END;
				end
				default:	begin
					isFlagRed <= NO;
					state <= BIT0;
				end
			endcase
		end
	end
endmodule
