module loadReg(rst, loadButton_s, in, out);
	input rst, loadButton_s;
	input[3:0] in;
	output reg[3:0] out;

	always @ (posedge loadButton_s, negedge rst)	begin
		if(~rst)	begin
			out = 4'd0;
		end
		else	begin
			out = in;
		end
	end
endmodule
