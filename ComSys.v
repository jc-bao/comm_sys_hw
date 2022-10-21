`timescale 1ns / 1ps

module ComSys (
    clk_sys,
    reset,
    first_sequence,
    first_result
);
    input clk_sys;
    input reset;
    output [7:0] first_sequence;
    output [7:0] first_result;
    wire data_seq;
    wire [1:0] conv_data;
    wire [1:0] il_out;
    wire FSK;
    wire [1:0] de_FSK;
    wire [1:0] error_sig;
    wire [1:0] deil_out;
    wire [7:0] deconv_out;
    reg [7:0] cnt;
    reg clk, clk_display;
    reg [12:0] display_flag;
    reg [26:0] div_cnt;
    parameter FREQ_DIV = 1 << 7;
    parameter DISPLAY_DIV = 1 << 26;  //1<<16;
    reg [7:0] first_result_reg;

    assign first_result = first_result_reg;

    always @(posedge clk_sys or negedge reset) begin
        if (!reset) begin
            clk <= 0;
            cnt <= 0;
        end else begin
            if (cnt < FREQ_DIV / 2) begin
                clk <= 1;
            end else begin
                clk <= 0;
            end
            cnt <= (cnt + 1) % FREQ_DIV;
        end
    end

    always @(posedge clk_sys or negedge reset) begin
        if (!reset) begin
            clk_display <= 0;
            div_cnt <= 0;
        end else begin
            div_cnt <= div_cnt + 1;
            if (div_cnt == 1) begin
                clk_display <= 1;
            end else begin
                clk_display <= 0;
            end
            div_cnt <= (div_cnt + 1) % DISPLAY_DIV;
        end
    end

    always @(posedge clk or posedge clk_display) begin
        if (clk_display) begin
            first_result_reg <= 0;
            display_flag <= 0;
        end else begin
            if (display_flag < 80) begin
                display_flag <= display_flag + 1;
            end else if (display_flag < 88) begin
                if (deconv_out[0]+deconv_out[1]+deconv_out[2]+deconv_out[3]+deconv_out[4]+deconv_out[5]+deconv_out[6]+deconv_out[7] > 5)
                begin
                    display_flag <= display_flag + 1;
                end
            end else if (display_flag == 88) begin
                first_result_reg <= deconv_out;
                display_flag <= display_flag + 1;
            end
        end
    end

    SigGen siggen (
        clk,
        reset,
        clk_display,
        data_seq,
        first_sequence
    );
    ConvEncode encoder (
        clk,
        data_seq,
        conv_data,
        reset
    );
    Interleaver il (
        clk,
        reset,
        conv_data,
        il_out
    );
    Modulator fskmod (
        clk_sys,
        reset,
        il_out,
        FSK
    );
    Demodulator fskdemod (
        clk_sys,
        clk,
        reset,
        FSK,
        de_FSK
    );
    BitError error (
        clk,
        reset,
        de_FSK,
        error_sig
    );
    DeInterleaver dil (
        clk,
        reset,
        error_sig,
        deil_out
    );
    ConvDecode decoder (
        clk,
        deil_out,
        deconv_out,
        reset
    );

endmodule
