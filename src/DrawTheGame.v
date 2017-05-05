//9:08 PM Friday, April 28, 2017
//Steven Ventura. Font created by hand in my java applet. 
//https://github.com/StevenVentura/ADDFinalProject
module DrawTheGame(
	clk,PASSWORD,
	//inputs
	currentScore,
	secDigit2,secDigit1,minDigit1,msDigit1,
	drawingState,accessControlState,gameControllerState,pixelRow,pixelColumn,
	//from gameBrain
	displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel,
	//from somewhere else xd
	gameOverFlag,
	//outputs
	VGA_R, VGA_G, VGA_B);
	input[3:0] secDigit2, secDigit1, msDigit1, minDigit1;//, scoreDigitR, scoreDigitL, ROM_address;
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
cEQUALS [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h007fff00,'h007fff00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h007fff00,'h007fff00,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cCHICKEN [0:31] = '{'h000006c0,'h000007c0,'h00001d40,'h00001540,'h000077c0,'h00004ce0,'h00007860,'h00003320,'h00001320,'h00001038,'hf000187e,'hd80008ff,'ha40009b0,'h1e000b08,'h0f001e0c,'h05801084,'h02c03984,'h02606984,'h03f9cf84,'h010ef1dc,'h01e898f0,'h017ad880,'h011bf880,'h01b42880,'h00f56880,'h00dd9880,'h00583080,'h006fe180,'h00360300,'h00180600,'h00063c00,'h0003e000},
cBASILBOYS [0:31] = '{'h04780000,'h04000000,'h0c000000,'h180f0000,'hf1e181e0,'h0000c700,'h487f5c01,'h4c01dfc2,'hc403f065,'h00061820,'h000c0c00,'h00080405,'h001b8402,'h00178790,'h40178e0c,'he0130b91,'h401009e0,'ha0101920,'hf0181136,'h407c3910,'ha0c3b910,'ha1819910,'h0103f910,'h02020910,'h02040b10,'h02040a30,'h02040a20,'h02040820,'h000c0000,'h00000000,'h00000000,'h00000000},
cCOLON [0:31] = '{'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h0003e000,'h0003f000,'h0003f000,'h0003e000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h0007e000,'h0007e000,'h0007e000,'h0003e000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000,'h00000000},
cCLOCK [0:31] = '{'h00000000,'hde0000f6,'hf300019e,'h51800314,'hf8c0063e,'hd8631c36,'hc4631c46,'hc1e79e0e,'h61f33f0c,'h63ffff8c,'h7f0201fc,'h3e8302f8,'h3c410478,'h3c010078,'h3c010078,'h1a0100b0,'h19010130,'h18010030,'h18030030,'h0f7f81e0,'h0c078060,'h0c030060,'h0c4004e0,'h0e8002e0,'h070001c0,'h03000180,'h03104380,'h01a02f00,'h01c21e00,'h00f27800,'h001fc000,'h00078000}
;
integer please;//counter for my loops
	//define the bounds of the textbox
	parameter textBoxTop = 480,
			  textBoxBottom = 480-32,
			  textBoxLeft = 640-32*16,
			  textBoxRight = 640;
	reg [32*16-1:0] textField [0:31];//holds the 16 letters



	
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
for (please = 0; please < 16; please = please + 1)
	drawCharacter(please, c_);
endtask

	input clk;
input gameOverFlag;
input [3:0] drawingState;
input [2:0] accessControlState;
input [3:0] gameControllerState;
input [9:0] pixelRow, pixelColumn;
input [6:0] currentScore;
input [15:0] PASSWORD;
input displayArea,middleSection,boundaries,playerArea,appleArea,enemyPixel;
reg textBox,letterPixel;

output reg [7:0]VGA_R, VGA_G, VGA_B;  //Red, Green, Blue VGA signals
wire R;
	wire G;
	wire B;
	reg [15:0] stevenbackgroundsequence=16'b0000111100001111;
		// this is an optional part to display the deadly screen when game is over. There is nothing to look at!!!
	always @(posedge clk) begin
		stevenbackgroundsequence[0] <= stevenbackgroundsequence[1] ^ stevenbackgroundsequence[2] ^ stevenbackgroundsequence[4] ^ stevenbackgroundsequence[15];
		stevenbackgroundsequence[15:1] <= stevenbackgroundsequence[14:0];
		textBox <= pixelRow >= textBoxBottom && pixelRow < textBoxTop && pixelColumn >= textBoxLeft && pixelColumn < textBoxRight;
		letterPixel <= textBox && (textField[pixelRow-textBoxTop][pixelColumn-textBoxLeft] == 1);
	end
	
	
	
			
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

always @(posedge clk) begin

case(drawingState) 
ENTERING_CREDENTIALS: begin
drawCharacter(0,cP);
drawCharacter(1,cA);
drawCharacter(2,cS);
drawCharacter(3,cS);
drawCharacter(4,cCOLON);
drawCharacter(5,cX);
drawCharacter(6,cX);
drawCharacter(7,cX);
drawCharacter(8,cX);
drawCharacter(9,c_);
drawCharacter(10,c_);
drawCharacter(11,c_);
drawCharacter(12,c_);
drawCharacter(13,c_);
drawCharacter(14,c_);
drawCharacter(15,c_);
case(accessControlState)
BIT1:begin
drawNumber(5,PASSWORD[15:12]);
end
BIT2:begin
drawNumber(5,PASSWORD[15:12]);
drawNumber(6,PASSWORD[11:8]);
end
BIT3:begin
drawNumber(5,PASSWORD[15:12]);
drawNumber(6,PASSWORD[11:8]);
drawNumber(7,PASSWORD[7:4]);
end
END:begin
drawCharacter(0,cL);
drawCharacter(1,cO);
drawCharacter(2,cC);
drawCharacter(3,cK);
drawCharacter(4,cE);
drawCharacter(5,cD);
drawCharacter(6,cCHICKEN);
drawCharacter(7,cO);
drawCharacter(8,cU);
drawCharacter(9,cT);
drawCharacter(10,cCHICKEN);
drawCharacter(11,c_);
drawCharacter(12,cH);
drawCharacter(13,cA);
drawCharacter(14,cH);
drawCharacter(15,cA);
end//end state END
endcase//end case(accessControlState)
end//end ENTERING_CREDENTIALS
ENTERING_TIME:begin
drawCharacter(0,cS);
drawCharacter(1,cE);
drawCharacter(2,cT);
drawCharacter(3,c_);
drawCharacter(4,cT);
drawCharacter(5,cI);
drawCharacter(6,cM);
drawCharacter(7,cE);
drawCharacter(8,c_);
drawNumber(9,minDigit1);
drawCharacter(10,cCOLON);
drawNumber(11,secDigit2);
drawNumber(12,secDigit1);
drawCharacter(13,c_);
drawCharacter(14,c_);
drawCharacter(15,c_);
end//end ENTERING_TIME
PLAYER_DEAD: begin
drawCharacter(0,cY);
drawCharacter(1,cO);
drawCharacter(2,cU);
drawCharacter(3,c_);
drawCharacter(4,cD);
drawCharacter(5,cI);
drawCharacter(6,cE);
drawCharacter(7,cD);
drawCharacter(8,c_);
drawCharacter(9,c_);
drawCharacter(10,cCHICKEN);
drawCharacter(11,cCOLON);
drawNumber(12,((currentScore - currentScore%10)%100)/10);
drawNumber(13,currentScore%10);
drawCharacter(14,c_);
drawCharacter(15,c_);




end//end PLAYER_DEAD
PLAYING_GAME: begin
drawCharacter(0,cBASILBOYS);
drawCharacter(1,cCOLON);
drawNumber(2,((currentScore - currentScore%10)%100)/10);
drawNumber(3,currentScore%10);
drawCharacter(4,c_);
drawCharacter(5,c_);
drawCharacter(6,cCLOCK);
drawNumber(7,minDigit1);
drawCharacter(8,cCOLON);
drawNumber(9,secDigit2);
drawNumber(10,secDigit1);
drawNumber(11,msDigit1);
drawCharacter(12,cCHICKEN);
drawCharacter(13,cCHICKEN);
drawCharacter(14,cCHICKEN);
drawCharacter(15,cCHICKEN);
end//end PLAYING_GAME
endcase
end//end always


/*parameter reg[7:0]
imageRed [0:31] [0:31]= '{32'{'hff}},
imageGreen [0:31] [0:31] = '{},
imageBlue [0:31] [0:31] = '{}
;*/
/*reg [7:0] templol = 'h33;
parameter reg[7:0] 
testeroo [0:1] [0:1] = '{ '{'hff, 'hff}, '{'hff, 'hff} };
*/
parameter reg[7:0] 
imageRed [0:31] [0:31] = '{ '{'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31},'{'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31},'{'hef,'hef,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31,'h31,'h31},'{'hef,'hef,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31,'h31,'h31},'{'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31},'{'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31}},
imageGreen [0:31] [0:31] = '{ '{'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h30,'h30},'{'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h30,'h30},'{'heb,'heb,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h82,'h69,'h69,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h8a,'h41,'h41,'h30,'h30,'h30,'h30},'{'heb,'heb,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'h30,'h30,'h30,'h30},'{'heb,'heb,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'h30,'h30,'h30,'h30},'{'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'h30,'h30},'{'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'haa,'h30,'h30}},
imageBlue [0:31] [0:31] = '{ '{'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31},'{'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31},'{'hef,'hef,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h84,'h6b,'h6b,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h8c,'h42,'h42,'h31,'h31,'h31,'h31},'{'hef,'hef,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31,'h31,'h31},'{'hef,'hef,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31,'h31,'h31},'{'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31},'{'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'had,'h31,'h31}};



reg isImagePixel;
assign isImagePixel = (pixelRow < textBoxBottom) && boundaries && ~(enemyPixel || appleArea || playerArea || letterPixel);


 
//draw to the screen
	assign VGA_R = isImagePixel ? imageRed[pixelRow][pixelColumn] : {8{(displayArea && (
			letterPixel
			||
			(playerArea && ~gameOverFlag && ~boundaries)
			||
			(appleArea)
			||
			(enemyPixel)//red and yellow 
			||
			(boundaries && gameOverFlag)
			))}};
	assign VGA_G = isImagePixel ? imageGreen[pixelRow][pixelColumn] : {8{(displayArea && (
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
			))}};
	assign VGA_B = isImagePixel ? imageBlue[pixelRow][pixelColumn] : {8{(displayArea && ( 
				letterPixel
				||
				(playerArea && ~gameOverFlag)
				|| 
				gameOverFlag && (~appleArea && middleSection && ~playerArea && ~enemyPixel && (stevenbackgroundsequence[1]))
				||
				~gameOverFlag && (~appleArea && middleSection && ~playerArea && ~enemyPixel)
				))}};
	
endmodule