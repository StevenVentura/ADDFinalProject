//9:09 PM Friday, April 28, 2017
//https://github.com/StevenVentura/ADDFinalProject
module DrawingStateHandler(clk,startGameFlag,drawingState,
						accessControlState,
						gameOverFlag,
						gameControllerState);
//states for DrawingStateHandler controller
parameter ENTERING_CREDENTIALS=4'd1,
		  ENTERING_TIME=4'd2,
		  PLAYING_GAME=4'd3,
		  PLAYER_DEAD = 4'd4;
//states taken from accessControl.v
parameter	BIT0	= 3'b000,				// 7 States
			BIT1	= 3'b001,
		 	BIT2	= 3'b010,
			BIT3	= 3'b011,
			BIT4	= 3'b100,
			BIT5	= 3'b101,
		   VERIFICATION = 3'b110,
			END	= 3'b111;
//states taken from GameController.v
parameter 	INIT		=	0,
			CHECKPASS	= 	1,
			SETTIME		=	2,
			GETREADY	=	3,
			START		=	4,	
			
			RESULT		=	5,
			WAIT1		= 	6,
			WAIT2		=	7,
			BLINK		= 	8;
input clk;
input startGameFlag;
input [2:0] accessControlState;
input [3:0] gameControllerState;
output reg [3:0] drawingState;
input gameOverFlag;

always @(posedge clk) begin
 if (startGameFlag)
	drawingState <= PLAYING_GAME;
 else if (accessControlState != VERIFICATION)
	drawingState <= ENTERING_CREDENTIALS;
 if(gameOverFlag)
	drawingState <= PLAYER_DEAD;
 if(gameControllerState == SETTIME)
	drawingState <= ENTERING_TIME;

end//end always

endmodule