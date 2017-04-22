
module checkFlash (rst, in, out);
	input in, rst;
	output reg out;

	always@(posedge in, negedge rst)	begin
		if(~rst)	begin
			out = 0;
		end
		else	begin
			out = in;
		end
	end
endmodule