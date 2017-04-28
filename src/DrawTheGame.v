module DrawTheGame(
	clk,
	//inputs
	drawingState,pixelRow,pixelColumn,
	//from gameBrain
	textBox,letterPixel,displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel,
	//from somewhere else xd
	gameOverFlag,
	//outputs
	VGA_R, VGA_G, VGA_B);
	input clk;
input gameOverFlag;
input [3:0] drawingState;
input [9:0] pixelRow, pixelColumn;
input textBox,letterPixel,displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel;

output reg [7:0]VGA_R, VGA_G, VGA_B;  //Red, Green, Blue VGA signals
wire R;
	wire G;
	wire B;
	reg [15:0] stevenbackgroundsequence=16'b0000111100001111;
		// this is an optional part to display the deadly screen when game is over. There is nothing to look at!!!
	always @(posedge clk) begin
		stevenbackgroundsequence[0] <= stevenbackgroundsequence[1] ^ stevenbackgroundsequence[2] ^ stevenbackgroundsequence[4] ^ stevenbackgroundsequence[15];
		stevenbackgroundsequence[15:1] <= stevenbackgroundsequence[14:0];
	end

	
//draw to the screen
	assign R = displayArea && (
			letterPixel
			||
			(playerArea && ~gameOverFlag && ~boundaries)
			||
			(appleArea)
			||
			(enemyPixel)//red and yellow 
			||
			(boundaries && gameOverFlag)
			);
	assign G = displayArea && (
			letterPixel
			||
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
				letterPixel
				||
				(playerArea && ~gameOverFlag)
				|| 
				gameOverFlag && (~appleArea && middleSection && ~playerArea && ~enemyPixel && (stevenbackgroundsequence[1]))
				||
				~gameOverFlag && (~appleArea && middleSection && ~playerArea && ~enemyPixel)
				);

always@(posedge clk)
	begin
		VGA_R = {8{R}};
		VGA_G = {8{G}};
		VGA_B = {8{B}};
	end

endmodule