// when startGameFlag == 0, game paused by setting the Game_clk = 0.
// setTimeMaxFlag is used to set the timeMax for the timer.
// _s means single pulse signal. Either posedge or negedge is used. Rule does not apply for clk and rst.
// without _s, the actual value of the signal (HIGH or LOW) is used. In other words, it depends on its value, not the edges. Rule does not apply for clk and rst.
// whoIsPlaying is the index of the array stored in RAM where we will trace and export the highestscore.
// whoIsPlaying is set by the switches, 4 bits are used, so we can display to the 7-seg easily
module GameController(
		//inputs
		clk, rst, timeOutFlag, accessFlag, blinkFlag, outOfAttemptsFlag,
		switches,
		hisCurrentScore, hisMaxScore, gameOverFlag, userIDfoundFlag, 
		KEY,
		userID_digit1, userID_digit2, userID_digit3, userID_digit4, 
		
		minDigit1, secDigit1, secDigit2, msDigit1,
		currentScore, RAM_score,
		//outputs
		LEDs, 
		setSpeed, scoreDisp, 
		setTimeMaxFlag, startGameFlag, enableSetTimeFlag, 
		enableSetUserIDFlag, enableSetPassFlag, enableStartButtonFlag, clearFlag,
		HEX0_s, HEX1_s, HEX2_s, HEX3_s, HEX4_s, HEX5_s, HEX6_s, HEX7_s,
		writeOrRead, maxScore);



	input clk, rst, timeOutFlag, accessFlag, gameOverFlag, userIDfoundFlag, blinkFlag, outOfAttemptsFlag;
	input[17:0] switches;
	input[3:0] hisCurrentScore, hisMaxScore, KEY;
	input[3:0]	userID_digit1, userID_digit2, userID_digit3, userID_digit4, 
		minDigit1, secDigit1, secDigit2, msDigit1;
	input[6:0] currentScore, RAM_score;

	output reg[6:0] maxScore;
	output reg setTimeMaxFlag, startGameFlag, enableSetTimeFlag, 
		enableSetUserIDFlag, enableSetPassFlag, enableStartButtonFlag, clearFlag, writeOrRead;
	output reg[2:0] setSpeed;
	output reg[3:0] scoreDisp;	
	output reg[17:0] LEDs; 
	output reg[3:0] HEX0_s, HEX1_s, HEX2_s, HEX3_s, HEX4_s, HEX5_s, HEX6_s, HEX7_s;
	reg[3:0] state;
	reg[21:0] blinkCnt;

	wire showCurrentOrMaxScore;
	assign showCurrenOrMaxScore = switches[14];

	parameter 	INIT		=	0,
			CHECKPASS	= 	1,
			SETTIME		=	2,
			GETREADY	=	3,
			START		=	4,	
			
			RESULT		=	5,
			WAIT1		= 	6,
			WAIT2		=	7,
			BLINK		= 	8;
				
	always @ (posedge clk, negedge rst)	begin
		if(rst == 0)
		begin
			setTimeMaxFlag <= 0;
			startGameFlag <= 0;
			setSpeed <= 0;
			clearFlag <= 0;
			state <= INIT;
			LEDs[17:0] <= 17'd0;
			HEX6_s <= 0; HEX7_s <= 0; HEX4_s <= 0; HEX5_s <= 0;
			HEX3_s <= 0; HEX2_s <= 0; HEX1_s <= 0; HEX0_s <= 0;	// display timer
			blinkCnt <= 0;
			
			
		end
		else
		begin
			case(state)
			INIT:	begin
				setTimeMaxFlag <= 0;startGameFlag <= 0;setSpeed <= 0;
				enableSetTimeFlag <= 0;enableSetPassFlag <= 0;enableStartButtonFlag <= 0;		// initialize
				LEDs[5] <= 1'b1 ;LEDs[3:0] <= 4'b1111;						// instruction LEDs
				HEX7_s <= switches[3:0];	// display inputs
				writeOrRead <= 0;		// read score only
				if(KEY[3])	begin
					enableSetUserIDFlag <= 1;
				end
				else	begin
					enableSetUserIDFlag <= 0;
				end
				if(userIDfoundFlag)	begin
					state <= CHECKPASS;
				end
				else	begin
					if(KEY[3] && switches[5])	begin
						state <= SETTIME;
					end
					else	begin
						state <= INIT;
					end
				end
			end
//			WAIT1: 	begin
//			// separate the loadButton for userID and loadButton for password
//				state <= CHECKPASS;
//			end
			CHECKPASS:	begin
				LEDs[5] <= 1'b1 ;
				enableSetUserIDFlag <= 0;
				HEX0_s <= userID_digit1; HEX1_s <= userID_digit2; HEX2_s <= userID_digit3; HEX3_s <= userID_digit4;	// display userID
				if(outOfAttemptsFlag)	begin
					LEDs[3:0] <= 4'b0000;	
				end
				else	begin
					LEDs[3:0] <= 4'b1111;	
					HEX7_s <= switches[3:0];	// display inputs
					if(KEY[3])	begin
						enableSetPassFlag <= 1;
					end
					else	begin
						enableSetPassFlag <= 0;
					end
				end
				if(accessFlag || (switches[5]&&KEY[3]))	begin
					state <= SETTIME;
				end
				else	if(blinkFlag)	begin
					state <= BLINK;
				end
				else	begin
					state <= CHECKPASS;
				end
			end
//			WAIT2: 	begin
//			// separate the loadButton for userID and loadButton for password
//				state <= SETTIME;
//			end
			SETTIME:	begin
				LEDs[5] <= 1'b0; LEDs[3:0] <= 4'b0000;	LEDs[17] <= 1;
				enableSetPassFlag <= 0;	clearFlag <= 0;
	//			//HEX4_s <= userID_digit1; HEX5_s <= userID_digit2; 
				HEX7_s <= ((RAM_score - RAM_score%10)%100)/10;
				HEX6_s <= RAM_score%10;	// display scores
				HEX4_s <= 0; HEX5_s <= 0;
				HEX3_s <= minDigit1; HEX2_s <= secDigit2; HEX1_s <= secDigit1; HEX0_s <= msDigit1;	// display timer
				if(KEY[1])	begin
					enableSetTimeFlag <= 1;
				end
				else	begin
					enableSetTimeFlag <= 0;
				end

				if(KEY[3])	begin
					state <= GETREADY;
				end
				else	begin
					state <= SETTIME;
				end
			end
			GETREADY:	begin
				LEDs[17] <= 0;
				enableSetTimeFlag <= 0;
				setTimeMaxFlag <= 1;
				if(switches[17])	begin
					setSpeed <= 3'd6;
				end
				else	begin
					setSpeed <= 3'd4;
				end
				state <= START;
			end
			START:	begin
				setTimeMaxFlag <= 0;	startGameFlag <= 1;
				HEX7_s <= ((RAM_score - RAM_score%10)%100)/10;
				HEX6_s <= RAM_score%10;	// display scores
				HEX5_s <= ((currentScore - currentScore%10)%100)/10;
				HEX4_s <= currentScore%10;
				HEX3_s <= minDigit1; HEX2_s <= secDigit2; HEX1_s <= secDigit1; HEX0_s <= msDigit1;	// display timer
				if(gameOverFlag || timeOutFlag)	begin
					state <= RESULT;
				end
				else	begin
					state <= START;
				end
			end
			RESULT:	begin
				startGameFlag <= 0;
				HEX7_s <= ((RAM_score - RAM_score%10)%100)/10;
				HEX6_s <= RAM_score%10;	// display scores
				HEX5_s <= ((currentScore - currentScore%10)%100)/10;
				HEX4_s <= currentScore%10;
				HEX3_s <= minDigit1; HEX2_s <= secDigit2; HEX1_s <= secDigit1; HEX0_s <= msDigit1;	// display timer
				if(currentScore > RAM_score)	begin
					maxScore <= currentScore;
					writeOrRead <= 1;
				end
				if(KEY[3])	begin
					clearFlag <= 1;
					state <= SETTIME;
				end	
				else	begin
					state <= RESULT;
				end
			end
			BLINK:	begin
				if(blinkCnt == 22'b111111111111111111111)	begin
					state <= CHECKPASS;
					blinkCnt <= 0;
				end
				else	begin
					LEDs[5] <= 1'b0 ;LEDs[3:0] <= 4'b0000;	
					blinkCnt <= blinkCnt + 1;
					state <= BLINK;
				end
			end
			default:	begin
				state <= INIT;
			end
			endcase
		end
	end
	
	always @ (showCurrentOrMaxScore)	begin
		if(showCurrentOrMaxScore)	begin
			scoreDisp = hisMaxScore;
		end
		else	begin
			scoreDisp = hisCurrentScore;
		end
	end
endmodule

