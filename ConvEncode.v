`timescale 1ns / 1ps

module ConvEncode(
    clock,
	din,
	dout,
	reset
);
input           clock;
input           reset;  
input 	     	din;
output 	[1:0] 	dout;

wire [1:0] dout;
reg  [3:0] status;
reg  [2:0]  count;

always @(posedge clock or negedge reset)
begin
    if (!reset)
        begin
            status <= {3'b000,din};
            count <= 0;
        end
    else
        begin
            count <= (count+1)%8;
            if (count == 0)
            begin
            status <= {3'b000,din};
            end
            else
            begin
            status <= {status[2:0],din};
            end
        end
end

assign	dout[0] = status[3] ^ status[1] ^ status[0];
assign	dout[1] = status[2] ^ dout[0];
endmodule

