`timescale 1ns / 1ps

module BitError(clk,reset,din,dout);
input clk;
input reset;
input [1:0] din;
output [1:0] dout;

parameter Le = 11;

reg [1:0] dout_reg;
reg [4:0] cnt;
reg flag;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        cnt <= 0;
        flag <= 0;
    end
    else begin
        cnt <= (cnt + 1) % Le;
        if(cnt == 2) begin
            flag <= 1;
        end
        else begin
            flag <= 0;
        end
    end
end

assign dout[1] = flag ? ~din[1] : din[1];
assign dout[0] = flag ? ~din[0] : din[0];

endmodule
