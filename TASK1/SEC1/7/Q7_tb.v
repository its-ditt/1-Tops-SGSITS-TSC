`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 18:02:36
// Design Name: 
// Module Name: Q7_tb
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


module sync_2ff_tb;

reg clk_dst;
reg d_async;
wire q_sync;

sync_2ff dut(clk_dst, d_async, q_sync);

initial begin
    clk_dst = 0;
    forever #5 clk_dst = ~clk_dst;
end

initial begin
    d_async = 0;

    #7  d_async = 1;
    #13 d_async = 0;
    #19 d_async = 1;
    #4  d_async = 0;

    #100 $finish;
end

initial begin
    $monitor("t=%0t  d_async=%b  q_sync=%b", $time, d_async, q_sync);
end

endmodule
