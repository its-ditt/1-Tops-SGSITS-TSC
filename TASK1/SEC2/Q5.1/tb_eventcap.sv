`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2026 15:25:57
// Design Name: 
// Module Name: tb_eventcap
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


module tb_eventcap;

logic clk,rst,evt,cap;

eventcap dut(clk,rst,evt,cap);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    rst=1; evt=0;
    #12 rst=0;

    #10 evt=1;
    #10 evt=0;

    #20 evt=1;
    #10 evt=0;

    #20 rst=1;
    #10 rst=0;

    #15 evt=1;
    #10 evt=0;

    #40 $finish;
end

initial begin
    $monitor("t=%0t clk=%b rst=%b evt=%b cap=%b",$time,clk,rst,evt,cap);
end

endmodule

