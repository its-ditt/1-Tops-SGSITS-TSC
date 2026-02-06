`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2026 20:06:59
// Design Name: 
// Module Name: clock_div_5_tb
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


module clock_div_5_tb;

reg clk;
reg rst;
wire clk_out;

clock_div_5 dut(
    .clk(clk),
    .rst(rst),
    .clk_out(clk_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;   
end

initial begin
    rst = 1;
    #20 rst = 0;

    #500 $finish;
end

endmodule

