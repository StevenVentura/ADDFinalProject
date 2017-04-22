module loadReg16b_test();
	reg rst, loadButton_s;
	reg[3:0] in;
	wire[15:0] out;
	



	loadReg16b a(rst, loadButton_s, in, out);

	initial begin
	rst = 0; loadButton_s = 0; in = 4'b1011;
	#25
	rst = 1;
	#30
	loadButton_s = 1;
	#50
	in = 4'b1111;
	#40
	loadButton_s = 0;
	#50
	loadButton_s = 1;
	#50
	in = 4'b0001;
	#40
	loadButton_s = 0;
	#50
	loadButton_s = 1;
	#50
	in = 4'b1000;
	#40
	loadButton_s = 0;
	#50
	loadButton_s = 1;
	#50
	in = 4'b0000;
	#40
	loadButton_s = 0;
	#50
	loadButton_s = 1;
	end
endmodule
