//Steven Ventura & Binh Doan
//made this program on 4/3/2017
//bounces a ball up and down and left and right

module gameBrain(
	// inputs
	rst, Speed, startGame, directionButton1, directionButton2, random, 

	// outputs
	master_clk, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n, 
	hitApple, gameOverFlag, BALL_clk);
	
	parameter enemySize	= 15
		, appleSize	= 20;
	parameter 	CEILING	= 350,
			FLOOR   = 120,
			LEFTWALL	= 15,
			RIGHTWALL 	= 625,
			MIDDLEY  	= 240,
			BALLSIZE 	= 15,
			UP 	= 1,//"up" is actually down on the monitor because 0,0 is on the topleft
			DOWN 	= 0,
			LEFT 	= 0,
			RIGHT 	= 1;

	parameter TRUE = 1,
		 FALSE = 0;
	input master_clk, rst;
	input[2:0] Speed;
	input directionButton1,directionButton2;
	input[15:0] random;
	reg [15:0] stevenbackgroundsequence=16'b0000111100001111;
	output reg hitApple;
	output reg [7:0]VGA_R, VGA_G, VGA_B;  //Red, Green, Blue VGA signals
	output VGA_hSync, VGA_vSync, DAC_clk, blank_n; //Horizontal and Vertical sync signals
	wire [9:0] pixelColumn; //current x pixel coordinate
	wire [9:0] pixelRow; //current y pixel coordinate
	wire displayArea; //boolean: current x and y pixel are within the screen bounds
	wire VGA_clk; //25 MHz
	output BALL_clk; //28 frames per second on 60MHz
	wire [9:0] ballX, ballY;
	wire R;
	wire G;
	wire B;
	input startGame;
	
	

	output reg gameOverFlag;				// Binh 04/09
	
	//wire directionButton1, directionButton2;
	
	


	reg randRequest;
	integer i,j;
	integer e;
integer a;
	integer counter;
	integer row = 0;
		
	reg [9:0] enemyXs[0:15];
	reg [9:0] enemyYs[0:15];
	
	reg[9:0] appleXs[0:2];
	reg[9:0] appleYs[0:2];
	
	parameter	INIT	= 0,
			START	= 1;
	reg state = INIT;

	always@(posedge BALL_clk, negedge rst) begin
/////////////////////////////////////////////////
//		case(state)
		//INIT:
		if(~rst)	begin
			for (i=0;i<16;i=i+1) begin
				enemyXs[i] <= i*40;//i * 640 divided by number of enemies
				enemyYs[i] <= 30;
			end
			for (j=0;j<3;j=j+1) begin
				appleXs[j] <= j*40*4;
				appleYs[j] <= 60;
			end
			hitApple <= 4'd0;
			gameOverFlag <= FALSE;
			//state <= START;
		end
		else	begin
//		START:	begin
			for (i=0;i<16;i=i+1) begin
				enemyXs[i] <= enemyXs[i] - Speed;
				if (enemyXs[i] < 20) begin
					enemyXs[i] <= 640-enemySize;

					enemyYs[i] <= (random)%(350-(120+BALLSIZE)) + 120;//state <= INIT;
				end
			end

			for (j=0;j<3;j=j+1)	begin
				appleXs[j] <= appleXs[j] - Speed;	//apple and enemy have the same speed
				if (appleXs[j] < 20) begin
					appleXs[j] <= 640-appleSize;	//apple and enemy have the same size
					appleYs[j] <= (random)%(350-(120+appleSize)) + 120;
				end
			end

			//check for deadly collision
			for (i=0; i<16; i=i+1) begin
				if ( ( (ballX-1 >= enemyXs[i] && ballX+1 <= enemyXs[i]+enemySize)
				||
				 (ballX+BALLSIZE-1 >= enemyXs[i] && ballX+BALLSIZE+1 <= enemyXs[i]+enemySize) )
				 &&
				 (
				 (ballY-1 >= enemyYs[i] && ballY+1 <= enemyYs[i]+enemySize)
				 ||
				 (ballY+BALLSIZE-1 >= enemyYs[i] && ballY+BALLSIZE+1 <= enemyYs[i]+enemySize)
				 )
				 )
					 gameOverFlag <= TRUE;
			end//end for
			//gameOverFlag <= (playerArea==TRUE && enemyPixel==TRUE);
			
			hitApple <= 0;
			//check for lovely collision
			for (j=0; j<3; j=j+1) begin
				if ( ( (ballX-1 >= appleXs[j] && ballX+1 <= appleXs[j]+appleSize)
				||
				 (ballX+BALLSIZE-1 >= appleXs[j] && ballX+BALLSIZE+1 <= appleXs[j]+appleSize) )
				 &&
				 (
				 (ballY-1 >= appleYs[j] && ballY+1 <= appleYs[j]+appleSize)
				 ||
				 (ballY+BALLSIZE-1 >= appleYs[j] && ballY+BALLSIZE+1 <= appleYs[j]+appleSize)
				 )
				 )	
				begin
						appleXs[j] <= 640-appleSize;	
					appleYs[j] <= (random)%(350-(120+appleSize)) + 120;
					 hitApple <= 1;
				end
					
					
				
			end//end for
		end
//		end//end START
//		default:	begin
//			state <= INIT;
//		end
//		endcase


	end//end always
	
	clk_reduce reduce1(master_clk, VGA_clk); //Reduces 50MHz clock to 25MHz
	game_fps gfps1(master_clk, startGame, BALL_clk);
	//tells us which row and column we are on. also generates the hsync,vsync, and blank_n output signals.
	VGA_gen gen1(VGA_clk, pixelColumn, pixelRow, displayArea, VGA_hSync, VGA_vSync, blank_n);
	assign DAC_clk = VGA_clk;
	
	
	
	///////////////////INSTRUCTIONS FOR DRAWING TO THE SCREEN
	//move the ball
	//EdgeTriggerButton etb1 (BALL_clk,button2, directionButton2);
	//EdgeTriggerButton etb2 (BALL_clk,button1, directionButton1);
	ball_move bm1(BALL_clk,directionButton1,directionButton2,ballX,ballY);
	
	

	
	//drawing
	reg middleSection=FALSE, boundaries=FALSE, playerArea = FALSE, appleArea = FALSE;
	reg enemyPixel = FALSE;
	// this is an optional part to display the deadly screen when game is over. There is nothing to look at!!!
	always @(posedge master_clk) begin
		stevenbackgroundsequence[0] <= stevenbackgroundsequence[1] ^ stevenbackgroundsequence[2] ^ stevenbackgroundsequence[4] ^ stevenbackgroundsequence[15];
		stevenbackgroundsequence[15:1] <= stevenbackgroundsequence[14:0];
	end
	
	
	always @(posedge VGA_clk) begin



	if (appleArea == TRUE)
		appleArea <= FALSE;
	if (enemyPixel == TRUE)
		enemyPixel <= FALSE;
	
	for (a=0;a<3;a=a+1)
	if (pixelColumn > appleXs[a] && pixelColumn < appleXs[a]+appleSize && pixelRow > appleYs[a] && pixelRow < appleYs[a]+appleSize)
		appleArea <= TRUE;

	for (e=0;e<16;e=e+1)
	if (pixelColumn > enemyXs[e] && pixelColumn < enemyXs[e]+enemySize && pixelRow > enemyYs[e] && pixelRow < enemyYs[e]+enemySize)
		enemyPixel <= TRUE;
	
	
	
	
	//now drawing instructions
	boundaries <= ~(pixelRow >= FLOOR && pixelRow <= CEILING && pixelColumn <= RIGHTWALL && pixelColumn >= LEFTWALL);
	playerArea <= pixelRow <= ballY+BALLSIZE && pixelRow >= ballY && pixelColumn <= ballX+BALLSIZE && pixelColumn >= ballX; 
	middleSection <= ~boundaries && ~playerArea;
	
	
	
	
	end//end always
	
	///////////////////END OF INSTRUCTIONS FOR DRAWING TO THE SCREEN
	//draw to the screen
	assign R = displayArea && (
			(playerArea && ~gameOverFlag && ~boundaries)
			||
			(appleArea)
			||
			(enemyPixel)//red and yellow 
			||
			(boundaries && gameOverFlag)
			);
	assign G = displayArea && (
			(playerArea && ~gameOverFlag)
			||
			gameOverFlag && (~playerArea && ~boundaries && ~enemyPixel && (stevenbackgroundsequence[0] || stevenbackgroundsequence[3]))
			||
			//~gameOverFlag && (~playerArea && ~boundaries && ~enemyPixel)
			//||
			gameOverFlag && (boundaries && ~playerArea && ~appleArea && ~enemyPixel && stevenbackgroundsequence[2])
			||
			~gameOverFlag && (boundaries && ~playerArea && ~enemyPixel && ~appleArea)
			||
			(enemyPixel)
			);
	assign B = displayArea && ( 
				(playerArea && ~gameOverFlag)
				|| 
				gameOverFlag && (~appleArea && middleSection && ~playerArea && ~enemyPixel && (stevenbackgroundsequence[1]))
				||
				~gameOverFlag && (~appleArea && middleSection && ~playerArea && ~enemyPixel)
				);
	always@(posedge VGA_clk)
	begin
		VGA_R = {8{R}};
		VGA_G = {8{G}};
		VGA_B = {8{B}};
	end 

endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////

//clock q is half the frequency of p
module clk_reduce(master_clk, VGA_clk);

	input master_clk; //50MHz clock
	output reg VGA_clk; //25MHz clock

	always@(posedge master_clk)
	begin
		VGA_clk <= ~VGA_clk;
	end
endmodule


//////////////////////////////////////////////////////////////////////////////////////////////////////
/*
VGA_gen documentation:
here's how it scans through the screen:
int r, c;
boolean displayArea, VGA_vSync, VGA_hSync, blank_n;

for (r = 0; r < maxV; r++)//yCount
{
for (c = 0; c < maxH; c++)//xCount
{
displayArea = (r <= maxV && c <= maxH);
VGA_vSync = ~(r >= syncV && r < porchVB);
VGA_hSync = ~(c >= syncH && c < porchHB);
blank_n = displayArea;
}
}

*/
module VGA_gen(VGA_clk, xCount, yCount, displayArea, VGA_hSync, VGA_vSync, blank_n);

	input VGA_clk;
	output reg [9:0]xCount, yCount; 
	output reg displayArea;  
	output VGA_hSync, VGA_vSync, blank_n;

	reg p_hSync, p_vSync; 
	
	integer porchHF = 640; //start of horizntal front porch
	integer syncH = 655;//start of horizontal sync
	integer porchHB = 747; //start of horizontal back porch
	integer maxH = 793; //total length of line.

	integer porchVF = 480; //start of vertical front porch 
	integer syncV = 490; //start of vertical sync
	integer porchVB = 492; //start of vertical back porch
	integer maxV = 525; //total rows. 

	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)
			xCount <= 0;
		else
			xCount <= xCount + 1;
	end
	// 93sync, 46 bp, 640 display, 15 fp
	// 2 sync, 33 bp, 480 display, 10 fp
	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)//at the end of each row (last column)
		begin
			if(yCount === maxV)//if we are at the last row
				yCount <= 0;
			else
			yCount <= yCount + 1;
		end
	end
	
	always@(posedge VGA_clk)
	begin
		displayArea <= ((xCount < porchHF) && (yCount < porchVF)); 
	end

	always@(posedge VGA_clk)
	begin
		p_hSync <= ((xCount >= syncH) && (xCount < porchHB)); 
		p_vSync <= ((yCount >= syncV) && (yCount < porchVB)); 
	end
 
	assign VGA_vSync = ~p_vSync; 
	assign VGA_hSync = ~p_hSync;
	assign blank_n = displayArea;
endmodule		

module game_fps(master_clk, startGame, gameRefresh);	// Binh added startGame input to control the Game (start/pause)
	input master_clk, startGame;
	output reg gameRefresh;
	parameter FPS28 = 1777777,
		  FPS60 = 833333;
		  
	reg [21:0]count;	
	
	always@(posedge master_clk)
	begin
		if(startGame)	begin
			if(count < FPS60)	begin
				count <= count + 1;
			end	
			else begin
				gameRefresh <= ~gameRefresh;
				count <= 0;
			end
		end
		else	begin
			gameRefresh <= 0;
			count = 0;
		end
	end
endmodule



module ball_move(BALL_clk, button1, button2, ballX, ballY);

parameter CEILING = 350,
			  FLOOR   = 120,
			  LEFTWALL = 15,
			  RIGHTWALL = 625,
			  MIDDLEY  = 240,
			  BALLSIZE = 15,
			  UP = 1,//"up" is actually down on the monitor because 0,0 is on the topleft
			  DOWN = 0,
			  LEFT = 0,
			  RIGHT = 1,
			  BALLSPEEDX = 1,
			  BALLSPEEDY = 3;
input BALL_clk;
input button1, button2;
reg vDirection = 1;
reg hDirection = 1;
output reg [9:0] ballX = LEFTWALL+BALLSIZE*2, ballY = MIDDLEY;
	
	always @(posedge BALL_clk) begin
	if (button1 == 1 || button2 == 1) begin
	case (vDirection)
	UP: vDirection <= DOWN;
	DOWN: vDirection <= UP;
	endcase
	end
	
	if (ballY+BALLSIZE > CEILING) begin
	ballY <= CEILING - BALLSIZE - 1;
	vDirection <= DOWN;
	end//end hit the ceiling
	if (ballY < FLOOR) begin
	ballY <= FLOOR + 1;
	vDirection <= UP;
	end
	
	if (ballX+BALLSIZE > RIGHTWALL) begin
	ballX <= RIGHTWALL-BALLSIZE-1;
	hDirection <= LEFT;
	end
	
	if (ballX < LEFTWALL) begin
	ballX <= LEFTWALL+1;
	hDirection <= RIGHT;
	end
	
	//move the ball
	/*if (hDirection == RIGHT)
		ballX <= ballX + BALLSPEEDX;
	else
		ballX <= ballX - BALLSPEEDX;
    */
	if (vDirection == UP)
		ballY <= ballY + BALLSPEEDY;
	else
		ballY <= ballY - BALLSPEEDY;
		
	end//end always


endmodule


//Steven Ventura
//shapes a signal to send an edge signal
//uses state thing
module EdgeTriggerButton(clock,buttonInput,edgePulse);
input clock,buttonInput;
output reg edgePulse = 1'b0;
reg [1:0] state = 2'b00;
parameter STATE_INIT = 0, STATE_PULSE = 1, STATE_WAIT = 2;	

always @(posedge clock)
begin
case(state)
STATE_INIT:
begin
edgePulse=1'b0;
if (~buttonInput)
state = STATE_PULSE;
else
state = STATE_INIT;
end//end STATE_INIT

STATE_PULSE:
begin 
edgePulse=1'b1;
state=STATE_WAIT;
end//end STATE_PULSE

STATE_WAIT: //wait for the button to let go before another pulse is allowed
begin
edgePulse=1'b0;
if (buttonInput)
state=STATE_INIT;
else
state=STATE_WAIT;
end//end STATE_WAIT
endcase
end//end always


endmodule