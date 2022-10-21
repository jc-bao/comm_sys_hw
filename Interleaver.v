`timescale 1ns / 1ps

module Interleaver(clk,reset,para_in,para_out);
    parameter depth = 12;
    input clk;
    input reset;
    input[1:0] para_in;
    output[1:0] para_out;
    reg[1:0] mem_in[0:depth-1];
    reg[1:0] mem_out[0:depth-1];
    reg[1:0] outreg;
    integer row_in;
    assign para_out = outreg;
    integer i;

    initial begin
        row_in = 0;
        for(i = 0; i<depth; i = i + 1) begin
               mem_in[i] <= 2'b 00;
               mem_out[i] <= 2'b 00;
        end
    end
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            row_in = 0;
            for(i = 0; i<depth; i = i + 1) begin
               mem_in[i] <= 2'b 00;
               mem_out[i] <= 2'b 00;
               outreg <= 2'b 00;
            end
        end
        else begin
            if(row_in < depth/2) begin
                if(row_in == 0) begin
                    for(i = 0; i<depth; i = i + 1) begin
                        mem_out[i] = mem_in[i];
                    end
                end
                outreg = {mem_out[2*row_in+1][0],mem_out[2*row_in][0]};
            end
            else begin
                outreg = {mem_out[2*row_in-depth+1][1],mem_out[2*row_in-depth][1]};
            end
            mem_in[row_in] = para_in;
            row_in = (row_in+1)%depth;
        end
    end

endmodule
