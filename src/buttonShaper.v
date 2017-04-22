// Binh Doan - 1377079
// ECE5440
// Inputs: button_IN, rst, clk
// Outputs: button_OUT
// Description: buttonShaper receives signals from button_IN and generates a single cycle pulse signal

module ButtonShaper(button_IN, clk, rst, controlFlag, button_OUT);
	input clk, button_IN, rst, controlFlag;
	reg[1:0] state;
	output button_OUT;
	reg button_OUT;

	parameter	PRESSED		= 1'd0,
		 	RELEASED	= 1'd1,
			HIGH 		= 1'd1,
		  	 LOW 		= 1'd0;

	parameter	INIT	 = 2'd0,
 		   	PULSE	 = 2'd1,
		  	 WAIT	 = 2'd2;

	
	always @ (posedge clk, negedge rst)	begin
		if(rst == PRESSED)	begin
			state <= INIT;	
		end					
		else	begin
			case (state)
				INIT:	begin
					if(controlFlag)	begin
						button_OUT = LOW;
						if(button_IN == PRESSED)	begin
							state <= PULSE;
						end
						else	begin
							state <= INIT;
						end
					end
					else	begin
						state <= INIT;
					end
				end
				PULSE: 	begin
					button_OUT = HIGH;
					
					state <= WAIT;
				end
				WAIT:	begin
					button_OUT = LOW;
					if(button_IN == RELEASED)	begin
						state <= INIT;
					end
					else	begin
						state <= WAIT;
					end
				end
				default:	begin
					button_OUT = LOW;
					state <= INIT;	
				end
			endcase
		end
	end
endmodule
			
			
