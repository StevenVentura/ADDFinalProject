

module ROM_controller(clk, rst, userID_in, q_in, address_out, userIDfoundFlag);
	input clk, rst;
	input[15:0] userID_in, q_in;

	output reg[3:0] address_out;
	output reg userIDfoundFlag;
	
	reg[2:0] state;
	parameter INIT = 3'd0, WAIT1 = 3'd1, WAIT2 = 3'd2, LOAD = 3'd3, CHECK = 3'd4, FINISH = 3'd5;
	always @ (posedge clk, negedge rst)	begin
		if(~rst)	begin
			state <= INIT;
			address_out <= 4'd0;
			userIDfoundFlag <= 0;
		end
		else	begin	
			case(state)
			INIT:	begin
				address_out <= 4'd0;
				userIDfoundFlag <= 0;
				if(userID_in != 0)	begin	// wait for userID input
					state <= WAIT1;
				end
				else begin
					state <= INIT;
				end
			end
			WAIT1:	state = WAIT2;
			WAIT2: state = CHECK;
			CHECK:	begin
				if(q_in==0)	begin
					//address_out <= 4'd15;	// address 15 means "userID does not matched, plz enter another userID" OR WE CAN SET LED HERE
					state <= FINISH;
				end
				else	begin
					if(q_in == userID_in)	begin
						userIDfoundFlag <= 1;
						state <= FINISH;
					end
					else	begin
						address_out <= address_out + 1;
						state <= WAIT1;
					end
				end	
			end
			FINISH:	begin
				state <= FINISH;

			end
			default:	begin
				state <= INIT;
			end
			endcase	
		end
	end
endmodule