
module DrawingStateHandler(clk,drawingState);
input clk;
output reg [3:0] drawingState;

always @(posedge clk) begin
drawingState <= 0;

end//end always

endmodule