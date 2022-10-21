`timescale 1ns / 1ps
`include "ComSys.v"

module testbench();
    reg reset;
    reg clk_sys;
    //reg clk;
    //reg[5:0] head = 6'b 100101;
    //reg[2:0] sync_cnt1;
    //reg[2:0] sync_cnt2;
    //integer cnt;
    //parameter FREQ_DIV = 128;
    wire [7:0] first_sequence;
    wire [7:0] first_result;
    ComSys mySystem(clk_sys, reset, first_sequence, first_result);

    initial begin
        $dumpfile("results/test.vcd");
        $dumpvars(0, mySystem);
        //cnt = 0;
        reset = 0;
        clk_sys = 1;
        #200 reset = 1;
        //#23333333 reset = 0;
        //#12345 reset = 1;
        #10000 $finish;
    end

    always #50 clk_sys = ~clk_sys;

endmodule
