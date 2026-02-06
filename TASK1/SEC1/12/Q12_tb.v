`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 17:08:00
// Design Name: 
// Module Name: Q12_tb
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


module tb_cmp8;

reg  [7:0] a,b;
wire eq,gt,lt;

cmp8 dut(a,b,eq,gt,lt);

initial begin
    a=8'd0;   b=8'd0;
    #5 a=8'd10; b=8'd10;    
    #5 a=8'd25; b=8'd10;    
    #5 a=8'd5;  b=8'd20;    
    #5 a=8'd255; b=8'd0;    
    #5 a=8'd0;   b=8'd255;  
    #5 a=8'd100; b=8'd99;   
    #5 a=8'd99;  b=8'd100;  
    #5 a=8'd128; b=8'd128;  
    #5 $finish;
end

initial begin
    $monitor("time=%0t  a=%0d  b=%0d  eq=%b gt=%b lt=%b",$time,a,b,eq,gt,lt);
end

endmodule

