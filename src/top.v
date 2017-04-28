// Apple Collector Game
// Team Busy Boys (Steven Ventura, Binh Doan, etc)
/* Project Description
Features:
- able to choose user prior to play the game. Each user has their own password.
- after having the access, player can set the speed and the maximum time frame for the game.
- when the game starts, a count down timer starts counting. Game will stop when the time is up or the player hits an obstacle.
- player uses 2 button KEY[3] and KEY[2] to move up and down to avoid the obstacles and to collect the apples. Each apple grants the player 1 point.
Game is over when player hits an apple.
(notice that KEY[2] = KEY[3], either one will toggle the object to move up/down)
- When the game is over, his current score will be compared with his previous highest score. Only the highest one will be saved.
- The player can press start button (KEY[3]) again to go back to the state where he can set the time and speed. Then press start one more time to start the game.
- Press reset button (KEY[0]) anytime to reset everything or logout. However, the previous score will not be lost.
- Red LEDs above the toggle switches state that their below switches are available/unavailable.

Instruction:
- Toggle switches from 5 to 8 to choose user ID, then press KEY[2].
- If the user ID cannot be found, letter F will pops up on HEX5, saying that the player should enter another user ID.
- Simply repeat first step until the player enters a correct user ID. Then he will no longer be able to enter another user ID.
- Notice the LEDs above the switches that they are stating whether these switches are available or not.
- Enter password by toggling switches from 1 to 4, then press KEY[2]. The password is 16-bit long, and the player has to enter 4 bits a time for 4 times.
- Guest can use this sample ID/password. ID: 4'hB (4'b1011). Password: 16'd5456 (16'b0001 0101 0101 0000).
- After succesfully entered the correct ID and password. Please set the speed by toggling the switch 0 (high is fast, low is slow), 
and set the time by pressing button KEY[1] (ranging from 10s to 9m50s).
- The press start button (KEY[3]) to start the game.
- Use KEY[2] and KEY[3] to move up and down (KEY[2] and KEY[3] are designed to have identical functionality. You will see when you play it).
- Hits a yellow object (obstacle), the you will die.
- Hits a red object, you will earn 1 point, adding up to the score display.
- Game is over when player dies or time is up.
- Player can continue another round without entering the password again, by simply pressing start button again.
- Now he is at the state before the game starts. He can set the time and speed again. Then press start button 1 more time to start the game.
*/

module top(clk, KEY,
	switches,
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	KEY_LED, gameOverFlagLED, accessFlagLED, userIDfoundFlagLED, LEDs, startGameLEDs,
	DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n);
	input clk;
	input[3:0] KEY;
	input[17:0] switches;

	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output gameOverFlagLED, accessFlagLED, userIDfoundFlagLED;
	output [7:0]VGA_R, VGA_G, VGA_B;  //Red, Green, Blue VGA signals
	output VGA_hSync, VGA_vSync, DAC_clk, blank_n; //Horizontal and Vertical sync signals
	output[17:0] LEDs;
	output[3:0] KEY_LED;
	output[1:0] startGameLEDs;

	wire timeOutFlag, flag1ms, flag100ms, KEY4_s, setTimeMaxFlag, scoreFlag;
	wire gameOverFlag, startGameFlag, BALL_clk, rst;
	wire[3:0] secDigit2, secDigit1, msDigit1, minDigit1, scoreDigitR, scoreDigitL, ROM_address;
	wire[15:0] random, userID, q;
	wire [2:0] setSpeed;
	wire[3:0] KEY_s;
	
	
	
	wire accessFlag, userIDfoundFlag, clearFlag, blinkFlag, outOfAttemptsFlag;
	wire[15:0] PASSWORD;
	wire enableSetUserIDFlag, enableSetPassFlag, enableStartButtonFlag, enableSetTimeFlag;
	wire resetGameFlag, move1_s, move2_s;
	wire[3:0] userID_digit1, userID_digit2, userID_digit3, userID_digit4;
	wire[6:0] HEX0_s, HEX1_s, HEX2_s, HEX3_s, HEX4_s, HEX5_s, HEX6_s, HEX7_s;
	wire[3:0] switch0_disp, switch1_disp, switch2_disp, switch3_disp;

	wire [6:0] RAM_score, currentScore, maxScore;
	wire [3:0] RAM_address;
	wire load_s, writeOrRead;
	
	//drawing information
	wire [9:0] pixelRow,pixelColumn;
	wire [3:0] drawingState;
	wire textBox,letterPixel,displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel;
	

	assign resetGameFlag = ~(clearFlag || ~rst);
	assign rst = KEY[0];
	assign KEY_LED[0] = KEY[0];
	assign KEY_LED[1] = KEY[1];
	assign KEY_LED[2] = KEY[2];
	assign KEY_LED[3] = KEY[3];
	assign gameOverFlagLED = gameOverFlag || timeOutFlag;
	assign accessFlagLED = accessFlag;
	assign userIDfoundFlagLED = userIDfoundFlag;
	assign startGameLEDs = startGameFlag;
	//assign setTimeFlagLED = ////////////////
	
	/***************************************** Timer ******************************************/
	LFSR_Timer_1ms LFSR1ms(resetGameFlag, clk, startGameFlag, flag1ms);
	Counter100ms Counter100ms1(resetGameFlag, flag1ms, flag100ms);
	CountDownTimer Timer(resetGameFlag, startGameFlag, gameOverFlag, setTimeMaxFlag, enableSetTimeFlag, flag100ms,
			 secDigit2, secDigit1, msDigit1, minDigit1, timeOutFlag, minOutFlag, secOutFlag);
	/******************************************************************************************/
	/*************************************** accessControl ************************************/
	
	accessControl accessControl1(userIDfoundFlag, enableSetPassFlag, PASSWORD, switches[3:0], clk, rst, accessFlag, blinkFlag, outOfAttemptsFlag);
	
	ROM_controller traceUserID(clk, rst, userID, q, ROM_address, userIDfoundFlag);
	ROM_userID	ROM_userID1(ROM_address,clk,q);
	ROM_pass	ROM_pass1(ROM_address,clk,PASSWORD);

	separateNumDigits userID_disp(clk, rst, userID, userID_digit4, userID_digit3, userID_digit2, userID_digit1);
	
	
	/******************************************************************************************/
	/*******************************************GAME*******************************************/
	GameController gameControl(
		//inputs
		clk, rst, timeOutFlag, accessFlag, blinkFlag, outOfAttemptsFlag,
		switches,
		hisCurrentScore, hisMaxScore, gameOverFlag, userIDfoundFlag, 
		KEY_s,
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

	//moves the objects around, does intersectcions, etc
	gameBrain game(
	resetGameFlag, setSpeed, startGameFlag, move1_s, move2_s, random,
	clk, DAC_clk, VGA_hSync, VGA_vSync, blank_n, 
	scoreFlag, gameOverFlag, BALL_clk,
	pixelRow,pixelColumn,
	textBox,letterPixel,displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel);

	//calculates the current state-machine-state of the game based on which boolean flags are up
	DrawingStateHandler dsh (
	clk,
	drawingState
	);
	//takes inputs from gameBrain and accessController and other modules to draw text and stuff on the screen
	DrawTheGame dtg (
	clk,
	//inputs
	drawingState,pixelRow,pixelColumn,
	//from gameBrain
	textBox,letterPixel,displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel,
	//from somewhere else lol
	gameOverFlag,
	//outputs
	VGA_R, VGA_G, VGA_B
	);
	
	randomGenerator RNG(BALL_clk, clk, rst, random);
	/*******************************************************************************************/

	/********************************************** Scores *************************************/

	scoreCounter scoreCounter1(scoreFlag, resetGameFlag, currentScore);
	ButtonShaper shapeSinglePulse(~userIDfoundFlag, clk, rst, load_s);
	loadReg4b(rst, load_s, ROM_address, RAM_address);
	RAM_scores (RAM_address, clk, maxScore, writeOrRead, RAM_score);			// I think write = 1, read = 0;
	/*******************************************************************************************/
	/***************************************** Extra stuff *************************************/
	loadReg16b loadReg1(rst, enableSetUserIDFlag, switches[3:0], userID);
//	ButtonShaper buttonShaper2(KEY[1], clk, rst, enableSetTimeFlag, setTimeButton_s);
//	ButtonShaper buttonShaper3(KEY[2], clk, rst, ~startGameFlag, KEY2_s);
//	ButtonShaper buttonShaper33(KEY[3], clk, rst, enableSetUserIDFlag, loadUserIDButton_s);
	ButtonShaper buttonShaper333(KEY[2], BALL_clk, rst, startGameFlag, move1_s);
	ButtonShaper buttonShaper4(KEY[3], BALL_clk, rst, startGameFlag, move2_s);

	ButtonShaper buttonShaper1(KEY[1], clk, rst, 1, KEY_s[1]);
	ButtonShaper buttonShaper2(KEY[2], clk, rst, 1, KEY_s[2]);
	ButtonShaper buttonShaper3(KEY[3], clk, rst, 1, KEY_s[3]);

	
//	numDisp numDisp4(minDigit1, HEX3);
//	numDisp numDisp3(secDigit2, HEX2);
//	numDisp numDisp2(secDigit1, HEX1);
//	numDisp numDisp1(msDigit1, HEX0);

	numDisp numDisp4(HEX3_s, HEX3);
	numDisp numDisp3(HEX2_s, HEX2);
	numDisp numDisp2(HEX1_s, HEX1);
	numDisp numDisp1(HEX0_s, HEX0);

	numDisp numDisp8(HEX7_s, HEX7);
	numDisp numDisp7(HEX6_s, HEX6);
	numDisp numDisp6(HEX5_s, HEX5);
	numDisp numDisp5(HEX4_s, HEX4);

//	numDisp numDisp5(scoreDigitR, HEX4);

	/********************************************************************************************/
endmodule