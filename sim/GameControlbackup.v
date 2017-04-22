// when startGameFlag == 0, game paused by setting the Game_clk = 0.
// setTimeMaxFlag is used to set the timeMax for the timer.
// _s means single pulse signal. Either posedge or negedge is used. Rule does not apply for clk and rst.
// without _s, the actual value of the signal (HIGH or LOW) is used. In other words, it depends on its value, not the edges. Rule does not apply for clk and rst.
// whoIsPlaying is the index of the array stored in RAM where we will trace and export the highestscore.
// whoIsPlaying is set by the switches, 4 bits are used, so we can display to the 7-seg easily
module GameController(
		//inputs
		clk, rst, timeOutFlag, accessFlag,
		startButton_s, chooseLevel_SW0, switch14,
		hisCurrentScore, hisMaxScore, gameOverFlag, userIDfoundFlag, 

		//outputs
		setSpeed, scoreDisp, 
		setTimeMaxFlag, startGameFlag, enableSetTimeFlag, 
		enableSetUserIDFlag, enableSetPassFlag, enableStartButtonFlag, clearFlag);



	input clk, rst, timeOutFlag, accessFlag, startButton_s, chooseLevel_SW0, switch14, gameOverFlag, userIDfoundFlag;
	input[3:0] hisCurrentScore, hisMaxScore;
	output reg setTimeMaxFlag, startGameFlag, enableSetTimeFlag,  
		enableSetUserIDFlag, enableSetPassFlag, enableStartButtonFlag, clearFlag;
	output reg[2:0] setSpeed;
	output reg[3:0] scoreDisp;	 
	reg[3:0] state;

	wire showCurrentOrMaxScore;
	assign showCurrenOrMaxScore = switch14;

	parameter 	INIT		=	0,
			CHECKPASS	= 	5,
			SETTIME		=	6,
			GETREADY	=	1,
			START		=	2,	
			
			RESULT		=	3,
			WAIT1		= 	4,
			WAIT2		=	7;
				
	always @ (posedge clk, negedge rst)	begin
		if(rst == 0)
		begin
			setTimeMaxFlag <= 0;
			startGameFlag <= 0;
			setSpeed <= 0;
			clearFlag <= 0;
			state <= INIT;
			
		end
		else
		begin
			case(state)
			INIT:	begin
				setTimeMaxFlag <= 0;
				startGameFlag <= 0;
				setSpeed <= 0;
				enableSetTimeFlag <= 0;
				enableSetPassFlag <= 0;
				enableStartButtonFlag <= 0;
				if(userIDfoundFlag)	begin
					enableSetUserIDFlag <= 0;
					state <= WAIT1;
				end
				else	begin
					enableSetUserIDFlag <= 1;
					state <= INIT;
				end
			end
			WAIT1: 	begin
			// separate the loadButton for userID and loadButton for password
				state <= CHECKPASS;
			end
			CHECKPASS:	begin
				enableSetPassFlag <= 1;
				if(accessFlag)	begin
					state <= WAIT2;
				end
				else	begin
					state <= CHECKPASS;
				end
			end
			WAIT2: 	begin
			// separate the loadButton for userID and loadButton for password
				state <= SETTIME;
			end
			SETTIME:	begin
				clearFlag <= 0;
				enableSetTimeFlag <= 1;
				enableStartButtonFlag <= 1;
				if(startButton_s)	begin
					state <= GETREADY;
				end
				else	begin
					state <= SETTIME;
				end
			end
			GETREADY:	begin
				enableSetPassFlag <= 0;
				setTimeMaxFlag <= 1;
				if(chooseLevel_SW0)	begin
					setSpeed <= 3'd6;
				end
				else	begin
					setSpeed <= 3'd4;
				end
				state <= START;
			end
			START:	begin
				enableSetTimeFlag <= 0;
				setTimeMaxFlag <= 0;
				startGameFlag <= 1;
				
				if(gameOverFlag || timeOutFlag)	begin
					state <= RESULT;
				end
				else	begin
					state <= START;
				end
			end
			RESULT:	begin
				startGameFlag <= 0;
				if(startButton_s)	begin
					clearFlag <= 1;
					state <= SETTIME;
				end	
				else	begin
					state <= RESULT;
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

