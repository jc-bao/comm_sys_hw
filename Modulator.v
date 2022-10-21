`timescale 1ns / 1ps

module Modulator(clk,reset,din,dout);
input clk;
input reset;
input [1:0] din;
output dout;

parameter FREQ_DIV = 1 << 7;

reg out, cnt1, clk1, clk2, clk3, clk4;
reg [1:0] cnt2;
reg [2:0] cnt3;
reg [3:0] cnt4;
reg [7:0] cnt;

assign dout = out;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        cnt1 <= 1'b0;
        cnt2 <= 2'b0;
        cnt3 <= 3'b0;
        cnt4 <= 4'b0;
        cnt <= 8'b0;
        clk1 <= 1'b0;
        clk2 <= 1'b0;
        clk3 <= 1'b0;
        clk4 <= 1'b0;
    end
    else begin
        if (cnt < (FREQ_DIV/2)) begin
            clk1 <= 1;
        end else begin
            clk1 <= 0;
        end
        if ((cnt >= (FREQ_DIV/4)) & (cnt < (FREQ_DIV/4*3))) begin
            clk2 <= 1;
        end else begin
            clk2 <= 0;
        end
        if ((cnt >= (FREQ_DIV/2)) & (cnt < (FREQ_DIV))) begin
            clk3 <= 1;
        end else begin
            clk3 <= 0;
        end
        if ((cnt >= (FREQ_DIV/4*3)) | (cnt < (FREQ_DIV/4))) begin
            clk4 <= 1;
        end else begin
            clk4 <= 0;
        end
        
        cnt <= (cnt + 1) % FREQ_DIV;

        // if (cnt1 == 1'b1) begin
        //     cnt1 <= 1'b0;
        //     clk1 <= ~clk1;
        // end
        // else
        //     cnt1 <= cnt1 + 1'b1;
        
        // if (cnt2 == 2'b11) begin
        //     cnt2 <= 2'b0;
        //     clk2 <= ~clk2;
        // end
        // else
        //     cnt2 <= cnt2 + 2'b01;
        
        // if (cnt3 == 3'b111) begin
        //     cnt3 <= 3'b0;
        //     clk3 <= ~clk3;
        // end
        // else
        //     cnt3 <= cnt3 + 3'b001;
        
        // if (cnt4 == 4'b1111) begin
        //     cnt4 <= 4'b0;
        //     clk4 <= ~clk4;
        // end
        // else
        //     cnt4 <= cnt4 + 4'b0001;
    end
end

always @(*) begin
    case (din)
        2'b00: out <= clk1;
        2'b01: out <= clk2;
        2'b10: out <= clk3;
        2'b11: out <= clk4;    
    endcase
end

endmodule
