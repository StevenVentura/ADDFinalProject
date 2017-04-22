module loadReg16b(rst, loadButton_s, in, out);
	input rst, loadButton_s;
	input[3:0] in;
	output reg[15:0] out;
	reg[2:0] cnt;
	reg[15:0] q;

	always @ (posedge loadButton_s, negedge rst)	begin
		if(~rst)	begin
			out <= 16'd0;
			cnt <= 3'd0;
			q <= 16'd0;
		end
		else	begin
			if(cnt == 3'd3)	begin
				out <= q + in;
			end
			else	begin
				
				q <= (q + in) << 4;
				cnt <= cnt + 3'd1;
			end
		end
	end
endmodule
