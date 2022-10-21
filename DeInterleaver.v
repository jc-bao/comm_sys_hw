`timescale 1ns / 1ps

module DeInterleaver(clk,reset,para_in,para_out);
    parameter depth = 12;
    input clk;
    input reset;
    input[1:0] para_in;
    output[1:0] para_out;
    reg[1:0] mem_in[0:depth-1];
    reg[1:0] mem_out[0:depth-1];
    reg[1:0] outreg;
    integer count;
    assign para_out = outreg;
    integer i;

    initial begin
        count = depth-2;
        for(i = 0; i<depth; i = i + 1) begin
               mem_in[i] <= 2'b 00;
               mem_out[i] <= 2'b 00;
        end
    end
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            count = depth-2;
            for(i = 0; i<depth; i = i + 1) begin
               mem_in[i] <= 2'b 00;
               mem_out[i] <= 2'b 00;
               outreg <= 2'b 00;
            end
        end
        else begin
            if (count < depth/2) begin
                if(count == 0) begin
                    for(i = 0; i<depth; i = i + 1) begin
                        mem_out[i] = mem_in[i];
                    end
                end
                outreg = mem_out[count];
                {mem_in[2*count+1][0],mem_in[2*count][0]} = para_in;
            end
            else begin
                outreg = mem_out[count];
                {mem_in[2*count+1-depth][1],mem_in[2*count-depth][1]} = para_in;
            end
            count = (count+1)%depth;
        end
    end

endmodule
