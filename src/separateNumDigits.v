module separateNumDigits(clk, rst, num, digit4, digit3, digit2, digit1);
	input[15:0] num;
	input clk, rst;
	output reg [3:0] digit1, digit2, digit3, digit4;
	reg[15:0] numTemp;
	reg[2:0] state;
	parameter	S1=0,S2=1,S3=2, S4=3, S5=4;

	always @ (posedge clk)	begin
		if(~rst)	begin
			state <= S1;
		end
		else	begin
		case(state)
		S1:	begin
			digit1 <= num % 10;
			numTemp <= num - (num%10);
			state <= S2;
		end
		S2:	begin
			digit2 <= (numTemp%100)/10;
			numTemp <= numTemp - (numTemp % 100);
			state <= S3;
		end
		S3:	begin
			digit3 <= (numTemp%1000)/100;
			numTemp <= numTemp - (numTemp % 1000);
			digit4 <= (numTemp - (numTemp % 1000))/1000;
			state <= S4;
		end
		S4:	begin
			numTemp <= num;
			state <= S5;
		end
		S5:	begin
			if(numTemp == num)	begin
				state <= S5;
			end
			else	begin
				state <= S1;
			end
		end
		default:	state <= S1;
		endcase
		end
	end
endmodule
