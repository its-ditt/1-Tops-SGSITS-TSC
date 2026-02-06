`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 17:23:45
// Design Name: 
// Module Name: Q9_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_updown4;

reg clk;
reg rst;
reg dir;
wire [3:0] q;

updown4 dut(clk,rst,dir,q);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1; dir = 1;
    #10 rst = 0;

    // count up
    #100 dir = 0;

    // count down
    #100 dir = 1;

    // count up again
    #50 rst = 1;
    #10 rst = 0;

    #100 $finish;
end

initial begin
    $monitor("t=%0t clk=%b rst=%b dir=%b q=%0d", $time, clk, rst, dir, q);
end

endmodule

