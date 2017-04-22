module Counter100ms(rst, in_1ms, out_100ms);
	input rst, in_1ms;
	output reg out_100ms;
	reg[6:0] cnt1ms;

	always @(posedge in_1ms, negedge rst) begin
		if(rst == 0)
		begin
			cnt1ms = 7'd0;
			out_100ms = 0;
		end
		else
		begin
			if(cnt1ms == 7'd99)
			begin
				out_100ms = 1;
				cnt1ms = 7'd0;
			end
			else
			begin
				cnt1ms = cnt1ms + 7'd1;
				out_100ms = 0;
			end
		end
	end
endmodule
