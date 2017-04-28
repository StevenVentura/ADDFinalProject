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
	integer please;//counter for my loops
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
	reg letterPixel, textBox;
	//define the bounds of the textbox
	parameter textBoxTop = 480,
			  textBoxBottom = 480-32,
			  textBoxLeft = 640-32*16,
			  textBoxRight = 640;
	reg [32*16-1:0] textField [0:31];//holds the 16 letters
	
	
	
	

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
	
parameter reg [31:0] 
cA [0:31] = '{'h0000c000,'h0000c000,'h0000c000,'h0001c000,'h00012000,'h00012000,'h00033000,'h00021000,'h00061800,'h00040800,'h000c0800,'h00080400,'h00080600,'h00100200,'h00100300,'h00200100,'h00200180,'h0041ff80,'h007ff980,'h007f8040,'h00c00060,'h00800020,'h00800030,'h00800010,'h01000018,'h01000008,'h0300000c,'h02000004,'h02000006,'h04000003,'h04000001,'h08000001},
cB [0:31] = '{'h00000000,'h000003f0,'h00001c10,'h00007010,'h0000c010,'h00010010,'h00020010,'h00060010,'h00040010,'h00040010,'h00040010,'h00040010,'h00060010,'h00030010,'h0001e010,'h00003f10,'h000000f0,'h00001ff0,'h0003f010,'h00060010,'h000c0018,'h00080008,'h00080008,'h00080008,'h000c0008,'h00060008,'h00030018,'h0001c010,'h00007f90,'h000000f0,'h00000030,'h00000000},
cC [0:31] = '{'h00000000,'h00000000,'h00000000,'h01ffe000,'h0f001800,'h08000600,'h00000300,'h00000180,'h000000c0,'h00000040,'h00000020,'h00000020,'h00000020,'h00000020,'h00000020,'h00000030,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h08000030,'h0c000020,'h03800060,'h00f001c0,'h001fff00,'h00000000,'h00000000,'h00000000,'h00000000},
cD [0:31] = '{'h00000000,'h000003c0,'h0000fe20,'h00078030,'h000c0010,'h00180010,'h00300010,'h00400010,'h00c00010,'h01800010,'h03000010,'h06000010,'h04000010,'h04000010,'h08000010,'h08000010,'h08000010,'h08000010,'h08000030,'h04000020,'h04000020,'h06000020,'h02000020,'h03000020,'h01800020,'h00e00020,'h003c0020,'h0007e020,'h00003f20,'h000001f0,'h00000000,'h00000000},
cE [0:31] = '{'h00000000,'h00000000,'h003fff70,'h000001d0,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h0007ffd0,'h00000030,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00000010,'h00fe0010,'h0003fff0,'h00000030,'h00000000},
cF [0:31] = '{'h00000000,'h00000000,'h001fffe0,'h001fffe0,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h0000ffe0,'h0000ffe0,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000060,'h00000000,'h00000000},
cG [0:31] = '{'h00000000,'h00000000,'h00000000,'h007f8000,'h0780e000,'h0c003000,'h00001800,'h00000c00,'h00000600,'h00000200,'h00000300,'h00000100,'h00000180,'h00000080,'h00000080,'h000000c0,'h00000040,'h00000040,'h0f800040,'h0fff0040,'h083f8040,'h04000040,'h060000c0,'h02000080,'h03000080,'h00c00100,'h00780300,'h000ffc00,'h00000000,'h00000000,'h00000000,'h00000000},
cH [0:31] = '{'h00000000,'h00000000,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h01fff860,'h00ffffe0,'h00c007e0,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00c00060,'h00000060,'h00000000,'h00000000},
cI [0:31] = '{'h00000000,'h00000000,'h00fffff0,'h00fffff0,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h00003000,'h007fffe0,'h007fffe0,'h00000000,'h00000000,'h00000000},
cJ [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h3fffff80,'h03fdc000,'h00018000,'h00038000,'h00030000,'h00030000,'h00070000,'h00060000,'h00060000,'h00060000,'h00060000,'h00060000,'h00020000,'h00030000,'h00030000,'h00018000,'h0001c000,'h0000e060,'h0000ffc0,'h00007f80,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cK [0:31] = '{'h00000000,'h00000000,'h00000060,'h00000060,'h00100060,'h00180060,'h000c0060,'h00060060,'h00010060,'h0000c060,'h00006060,'h00001860,'h00000660,'h00000360,'h000001e0,'h000000e0,'h000000e0,'h000001e0,'h00000360,'h00000c60,'h00001860,'h00006060,'h00038060,'h00060060,'h001c0060,'h00300060,'h00200060,'h00000060,'h00000000,'h00000000,'h00000000,'h00000000},
cL [0:31] = '{'h00000000,'h00000000,'h000000c0,'h000000c0,'h000000c0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000e0,'h000000c0,'h000000c0,'h000000c0,'h000001c0,'h000000c0,'h000000c0,'h000000c0,'h000000c0,'h000000c0,'h0fffe0c0,'h0ffffec0,'h007fffe0,'h0001ff80,'h000001c0,'h00000000},
cM [0:31] = '{'h00000000,'h00000000,'h00000004,'h02000004,'h03000004,'h0780000c,'h0280000e,'h0240000a,'h02600012,'h02300036,'h02100024,'h02080064,'h020c0044,'h020600c4,'h02030184,'h02010104,'h02008304,'h0200cc04,'h02007804,'h02003004,'h02002004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h02000004,'h00000004,'h00000000,'h00000000},
cN [0:31] = '{'h00000000,'h00400000,'h00400008,'h00200018,'h00200018,'h00200038,'h00200028,'h0020006c,'h00200044,'h002000c4,'h00200084,'h0020018c,'h00200108,'h00200308,'h00600608,'h00400408,'h00400808,'h00401808,'h00401008,'h00402008,'h00406008,'h0040c008,'h00418008,'h00410008,'h00420008,'h00460008,'h00580008,'h00700008,'h00e0000c,'h00400000,'h00000000,'h00000000},
cO [0:31] = '{'h00000000,'h00000000,'h00000000,'h000f0000,'h001ff800,'h00380e00,'h00600300,'h004000c0,'h00c00060,'h00800020,'h01800010,'h01000010,'h01000008,'h01000008,'h03000008,'h02000008,'h02000008,'h02000008,'h02000008,'h02000008,'h03000008,'h01000008,'h01800010,'h00c00030,'h00600020,'h00380040,'h0007ff80,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cP [0:31] = '{'h00000000,'h00000000,'h0000ff00,'h000381c0,'h000e00c0,'h00180040,'h00300040,'h00600040,'h00400040,'h00400040,'h00400040,'h00600040,'h003803c0,'h000ffe40,'h00000040,'h00000040,'h00000040,'h00000040,'h00000040,'h00000040,'h00000040,'h00000040,'h00000060,'h00000020,'h00000020,'h00000020,'h00000020,'h00000020,'h00000000,'h00000000,'h00000000,'h00000000},
cQ [0:31] = '{'h00000000,'h00000000,'h00000000,'h0003e000,'h001c3800,'h00300c00,'h00c00600,'h01800300,'h01000100,'h01000080,'h010000c0,'h03000040,'h02000040,'h03000060,'h01000020,'h01000020,'h01038020,'h008e0060,'h00980040,'h00600040,'h00e00040,'h033000c0,'h060e0180,'h0c03ff00,'h18000000,'h10000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cR [0:31] = '{'h00000000,'h00000000,'h00000000,'h0000fe00,'h00030200,'h00040200,'h000c0200,'h00080200,'h00080300,'h00100100,'h00100100,'h00100100,'h00100100,'h00100100,'h00100100,'h00180100,'h000c0380,'h0003ff80,'h00000680,'h00000c80,'h00003080,'h0000e080,'h00018080,'h00030080,'h000c00c0,'h00180040,'h00700040,'h00400040,'h00000000,'h00000000,'h00000000,'h00000000},
cS [0:31] = '{'h00000000,'h00000000,'h003f0000,'h00e1e000,'h01003000,'h00001800,'h00000800,'h00000800,'h00000800,'h00001800,'h00001000,'h00002000,'h0000c000,'h00038000,'h00060000,'h000c0000,'h00180000,'h00300000,'h00600000,'h00400000,'h00400180,'h00400100,'h00600700,'h00381c00,'h000ff000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cT [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h01fffe00,'h0001fff8,'h00003000,'h00002000,'h00002000,'h00002000,'h00002000,'h00002000,'h00002000,'h00002000,'h00006000,'h00006000,'h00006000,'h00006000,'h00006000,'h00006000,'h00006000,'h0000e000,'h0000e000,'h0000e000,'h0000e000,'h0000e000,'h00006000,'h00006000,'h00000000,'h00000000,'h00000000},
cU [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000020,'h00400020,'h00400020,'h00c00030,'h00800010,'h00800010,'h00800010,'h00800010,'h00800018,'h00800008,'h00800008,'h00800008,'h00800008,'h00800008,'h00800008,'h00800008,'h00c00018,'h00400010,'h00400010,'h00600030,'h00200060,'h003000c0,'h00180180,'h000cfe00,'h00038000,'h00000000,'h00000000,'h00000000},
cV [0:31] = '{'h00000000,'h00000000,'h00000000,'h01000000,'h01800000,'h00800008,'h00800008,'h00c00010,'h00400010,'h00400020,'h00200020,'h00200040,'h002000c0,'h00100080,'h00100180,'h00100300,'h00180200,'h00080400,'h000c0c00,'h00040800,'h00061000,'h00021000,'h00022000,'h00036000,'h00014000,'h0001c000,'h00008000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cW [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h10000004,'h10000004,'h18000004,'h08000008,'h08000018,'h08000010,'h04000010,'h04000020,'h04000020,'h06018060,'h02038040,'h0206c080,'h03046080,'h010c2100,'h01983300,'h00901200,'h00700e00,'h00600c00,'h00000c00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cX [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000080,'h00200180,'h00300300,'h00180600,'h000c0400,'h00040800,'h00021000,'h00013000,'h0001a000,'h0000c000,'h0000c000,'h00012000,'h00011000,'h00020800,'h00040c00,'h00080200,'h00100300,'h00300100,'h00600080,'h00c00080,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cY [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00800008,'h00800018,'h00400030,'h00400060,'h006000c0,'h00200080,'h00300100,'h00100300,'h00100600,'h00080c00,'h00080800,'h00041000,'h00062000,'h00026000,'h00024000,'h00018000,'h00010000,'h00008000,'h0000c000,'h00006000,'h00003000,'h00001000,'h00000c00,'h00000600,'h00000300,'h00000180,'h00000000},
cZ [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000030,'h00000fc0,'h03fff800,'h03000000,'h00c00000,'h00600000,'h00180000,'h00040000,'h00030000,'h0000c000,'h00003000,'h00000c00,'h00000300,'h000001c0,'h00000060,'h00000030,'h00000018,'h0000000c,'h007ffffc,'h03c00000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c0 [0:31] = '{'h00000000,'h00000000,'h00000000,'h0003e000,'h000e3800,'h00180c00,'h00300600,'h00600200,'h00400300,'h00c00100,'h00800100,'h01800080,'h01000080,'h01000080,'h01000080,'h030000c0,'h02000040,'h02000040,'h02000040,'h02000040,'h02000040,'h01000080,'h01000080,'h01800180,'h00800100,'h00400300,'h00700600,'h001e3c00,'h0003e000,'h00000000,'h00000000,'h00000000},
c1 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00007000,'h00005c00,'h00004700,'h00004180,'h00004080,'h00004000,'h00004000,'h00004000,'h00004000,'h00004000,'h00004000,'h0000c000,'h00008000,'h00008000,'h00008000,'h00008000,'h00008000,'h00008000,'h00008000,'h0000c000,'h00f8c000,'h000fffc0,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c2 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h0007e000,'h001c3f00,'h002001c0,'h00400030,'h00c00010,'h00800000,'h01800000,'h01000000,'h01000000,'h02000000,'h02000000,'h02000000,'h03000000,'h01800000,'h00e00000,'h003c0000,'h00070000,'h0001c000,'h00003800,'h0f800f00,'h007fffc0,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c3 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h000fff80,'h003800e0,'h00600000,'h00400000,'h00400000,'h00400000,'h00600000,'h00200000,'h00180000,'h000fe000,'h00007800,'h000fc000,'h00180000,'h00300000,'h00200000,'h00200000,'h00200040,'h002001c0,'h00200300,'h00381c00,'h000fe000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c4 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000100,'h00000100,'h00200100,'h00200100,'h00200080,'h00200080,'h00200080,'h00200080,'h002000c0,'h00200040,'h00200060,'h00200060,'h007fffc0,'h00100000,'h00100000,'h00100000,'h00100000,'h00180000,'h00080000,'h00080000,'h00080000,'h00080000,'h000c0000,'h00040000,'h00000000,'h00000000,'h00000000,'h00000000},
c5 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h0007f800,'h03fc0800,'h00000800,'h00000400,'h00000400,'h00000400,'h00000400,'h00000400,'h00000400,'h00000400,'h000f8400,'h00707c00,'h01800000,'h01000000,'h02000000,'h02000000,'h02000000,'h03000000,'h01000080,'h01c00180,'h00780f00,'h000ff800,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c6 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h007c0000,'h00078000,'h00004000,'h00003000,'h00001800,'h00000c00,'h00000200,'h00000300,'h00000100,'h00000180,'h00000080,'h00000080,'h00078080,'h001c7c80,'h00200780,'h00200180,'h002000c0,'h00200080,'h00300080,'h000c0080,'h0003c180,'h00007e00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c7 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00ffffe0,'h03800000,'h01000000,'h00800000,'h00c00000,'h00600000,'h00100000,'h00080000,'h00040000,'h00020000,'h00010000,'h00018000,'h0000c000,'h00004000,'h00006000,'h00003000,'h00001800,'h00000c00,'h00000700,'h00000100,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c8 [0:31] = '{'h00000000,'h00000000,'h00000000,'h000f8000,'h0018c000,'h00206000,'h00602000,'h00603000,'h00201000,'h00201000,'h00101000,'h000a2000,'h000f2000,'h0003e000,'h0001c000,'h0001e000,'h00033000,'h00061800,'h000c0c00,'h00080600,'h00180200,'h00100300,'h00180200,'h000e0600,'h0003fc00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
c9 [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h0001f800,'h00070c00,'h00080200,'h00080300,'h00180100,'h00180100,'h00180080,'h00180080,'h00180080,'h001c0180,'h00160100,'h0013fe00,'h00100000,'h00100000,'h00300000,'h00200000,'h00200000,'h00200000,'h00200000,'h00200000,'h00200000,'h00200000,'h00200000,'h00200000,'h00200000,'h00000000,'h00000000,'h00000000},
c_ [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cEQUALS [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h007fff00,'h007fff00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h007fff00,'h007fff00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000}
;
	
	task drawNumber(input [3:0] textIndex, input [3:0] number);
reg [31:0] getDigit [0:31];
case(number)
0:getDigit=c0;
1:getDigit=c1;
2:getDigit=c2;
3:getDigit=c3;
4:getDigit=c4;
5:getDigit=c5;
6:getDigit=c6;
7:getDigit=c7;
8:getDigit=c8;
9:getDigit=c9;
10:getDigit=cA;
11:getDigit=cB;
12:getDigit=cC;
13:getDigit=cD;
14:getDigit=cE;
15:getDigit=cF;
endcase
drawCharacter(textIndex,getDigit);
endtask
task drawCharacter(input [3:0] textIndex, input [31:0] letterChoice [0:31]);
for (please = 0; please < 32; please = please + 1)
	textField[please][textIndex*32+31 -: 32] = letterChoice[please];
endtask
task clearTextField();
for (please=0;please<32;please=please+1)
	textField[please] = 0;
endtask

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
drawCharacter(0,cW);
drawCharacter(1,cE);
drawCharacter(2,cL);
drawCharacter(3,cC);
drawCharacter(4,cO);
drawCharacter(5,cM);
drawCharacter(6,cE);
drawCharacter(7,c_);
drawCharacter(8,cL);
drawCharacter(9,cO);
drawCharacter(10,cG);
drawCharacter(11,c_);
drawCharacter(12,cI);
drawCharacter(13,cN);

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
	textBox <= pixelRow >= textBoxBottom && pixelRow < textBoxTop && pixelColumn >= textBoxLeft && pixelColumn < textBoxRight;
	letterPixel <= textBox && (textField[pixelRow-textBoxTop][pixelColumn-textBoxLeft] == 1);
	
	
	
	
	end//end always
	
	///////////////////END OF INSTRUCTIONS FOR DRAWING TO THE SCREEN
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