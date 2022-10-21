`timescale 1ns / 1ps

module Demodulator(clk,clk_symbol,reset,din,dout);
input clk;
input clk_symbol;
input reset;
input din;
output [1:0] dout;

reg last_din; 
reg [1:0] out;
reg [7:0] cnt;  // signal change times during one symbol period

parameter k = 128;
parameter thresh1 = 24;  // k*3/16
parameter thresh2 = 12;  // k*3/32
parameter thresh3 = 6;  // k*3/64

assign dout = out;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        cnt <= 8'b0;
        last_din <= 1'b0;
    end
    else begin
        if (clk_symbol == 1'b1)
            cnt <= 8'b0;
        else
            cnt <= cnt + (last_din ^ din);
        last_din <= din;    
    end
end

always @(posedge clk_symbol or negedge reset) begin
    if (!reset) begin
        out <= 2'b0;
    end
    else begin
        if (cnt > thresh1)
            out <= 2'b00;
        else if (cnt > thresh2)
            out <= 2'b01;
        else if (cnt > thresh3)
            out <= 2'b10;
        else
            out <= 2'b11;
    end
end

endmodule
