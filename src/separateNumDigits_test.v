`timescale 1 ns / 100 ps
module separateNumDigits_test();

	reg[15:0] num;
	reg clk, rst;
	wire[3:0] digit4, digit3, digit2, digit1;
	
	separateNumDigits a(clk, rst, num, digit4, digit3, digit2, digit1);

	always begin
	clk <= 0;
	#10;
	clk <= 1;
	#10;
	end
	initial begin
	rst = 0;
	num = 0;
	#150
	rst = 1;
	#150
	num = 16'd4501;
	#150
	num = 16'd5168;
	#150
	num = 16'd321;
	end
endmodule
