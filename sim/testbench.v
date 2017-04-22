`timescale 1 ns/1 ps
module testbench();
	reg clk, rst, KEY1, KEY2, KEY3, KEY0;
	reg[17:0] switches;
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, accessFlagLED;

	top a(clk, KEY0, KEY1, KEY2, KEY3,
	switches,
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	KEY0LED, KEY1LED, KEY2LED, KEY3LED, gameOverFlagLED, accessFlagLED, buttonStuckLED, setTimeFlagLED, enableUserIDinputLED, enablePassInputLED, enableSetLevelLED,
	DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n);

	always begin
	clk <= 0;
	#10;
	clk <= 1;
	#10;
	end

	initial begin
	rst = 0;
	#20
	rst = 1;
	#5
	switches[8:5] = 4'b1011;
	#25
	KEY3 = 0;
	#60
	KEY3 = 1;
	#150
	switches[3:0] = 4'b0000;
	#95
	KEY3 = 0;
	#90
	KEY3 = 1;
	switches[3:0] = 4'b0101;
	#95
	KEY3 = 0;
	#90
	KEY3 = 1;
	switches[3:0] = 4'b0101;
	#95
	KEY3 = 0;
	#90
	KEY3 = 1;
	switches[3:0] = 4'b00101;
	#95
	KEY3 = 0;
	#690
	KEY3 = 1;
	#100
	KEY3 = 0;
	#50 KEY3 = 1;
	end
endmodule
