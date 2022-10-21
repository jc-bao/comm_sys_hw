`timescale 1ns / 1ps

module SigGen(clk, reset, clk_display, data_out, first_sequence);
    input clk, reset, clk_display;
    output data_out;
    output[7:0] first_sequence;
    reg rand;
    reg [12:0] counter;
    reg [3:0] pointer;
    parameter FRAME_LEN = 128000;
    parameter ZERO_LEN = 160;
    parameter Rand_Len = 2333;
    reg outreg;
    reg[7:0] first_sequence_reg;
    reg[128:0] count;
    
    assign data_out = outreg;
    assign first_sequence = first_sequence_reg;

    always @(negedge clk or negedge reset) begin
        if (!reset) begin
            rand <= 1'b0;
            counter <= 13'b0_0110_1010_1001;
            pointer <= 4'b0;
        end
        else begin
            rand <= counter[pointer];
            if (pointer < 12) begin
                pointer <= pointer + 1;
            end
            else begin
                counter <= (counter + 1) % Rand_Len;
                pointer <= 4'b0;
            end
        end    
    end
    
    always @(negedge clk or negedge reset or posedge clk_display) begin
        //rand <= {$random}%2;
        if (!reset | clk_display) begin
            first_sequence_reg <= 0;
            outreg <= 0;
            count <= 0;
        end
        else begin
            if (count < ZERO_LEN-1) begin
                outreg <= 0;//{head[count+1],head[count]};
                count <= (count + 1);//%FRAME_LEN;
            end
            else if (count < ZERO_LEN+7) begin
                outreg <= 1;//{head[count+1],head[count]};
                count <= (count + 1);//%FRAME_LEN;
            end
            else if (count < ZERO_LEN+15) begin
                outreg <= rand;//{head[count+1],head[count]};
                first_sequence_reg[ZERO_LEN+14-count] <= rand;
                count <= (count + 1);//%FRAME_LEN;
            end
            else begin
                outreg <= rand;
                count <= (count + 1);//%FRAME_LEN;
            end
        end
    end
endmodule
