`timescale 1ns / 1ps

module Demodulator(clk,clk_symbol,reset,din,dout);
input clk;
input clk_symbol;
input reset;
input din;
output [1:0] dout;

parameter FREQ_DIV = 1 << 7;

reg [1:0] out;
reg [1:0] din_sample;

reg [7:0] sysclk_cnt;

assign dout = out;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        sysclk_cnt <= 8'b0;
    end
    else begin
        if (clk_symbol == 1'b1) begin
            sysclk_cnt <= 8'b0;
        end
        else begin
            sysclk_cnt <= (sysclk_cnt + 1);
        end
    end

    if (sysclk_cnt == (FREQ_DIV/8))
        din_sample[1] <= din;
    else if (sysclk_cnt == (FREQ_DIV/8*3))
        din_sample[0] <= din;
end

always @(posedge clk_symbol or negedge reset) begin
    if (!reset) begin
        out <= 2'b0;
    end
    else begin
        if (din_sample == 2'b00)
            out <= 2'b00;
        else if (din_sample == 2'b10)
            out <= 2'b01;
        else if (din_sample == 2'b11)
            out <= 2'b10;
        else
            out <= 2'b11;
    end
end

endmodule
