`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 21:12:06
// Design Name: 
// Module Name: tb_cgcontrol
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


module tb_clk_gate;

logic clk;
logic en;
logic gclk;

cgcontrol dut(clk,en,gclk);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    en = 0;

    #12 en = 1;     // enable while clock low
    #20 en = 0;     // disable safely
    #15 en = 1;     // change not aligned intentionally
    #10 en = 0;
    #25 en = 1;     // test multiple toggles
    #15 en = 0;

    #50 $finish;
end

initial begin
    $monitor("t=%0t clk=%b en=%b gclk=%b",$time,clk,en,gclk);
end

endmodule

