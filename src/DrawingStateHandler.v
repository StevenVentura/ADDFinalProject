
module DrawingStateHandler(clk,startGameFlag,drawingState
						);

parameter ENTERING_PASSWORD=4'd0,
		  PLAYING_GAME=4'd3;
input clk;
input startGameFlag;
output reg [3:0] drawingState;

always @(posedge clk) begin
 if (startGameFlag)
	drawingState <= PLAYING_GAME;
	else
	drawingState <= ENTERING_PASSWORD;

end//end always

endmodule