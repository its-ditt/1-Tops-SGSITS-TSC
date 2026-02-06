`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 17:23:45
// Design Name: 
// Module Name: Q10_tb
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


module gtbtg_tb;

parameter N = 8;

reg en;
reg mode;
reg [N-1:0] x;
wire [N-1:0] y;

gtbtg #(N) dut(en,mode,x,y);

initial begin
    en = 0; mode = 0; x = 0;
    #10 en = 1;

    mode = 0;
    x = 8'd0;      #10;
    x = 8'd1;      #10;
    x = 8'd5;      #10;
    x = 8'd10;     #10;
    x = 8'd255;    #10;

    mode = 1;
    x = 8'h00;     #10;
    x = 8'h01;     #10;
    x = 8'h03;     #10;
    x = 8'h02;     #10;
    x = 8'h80;     #10;
    x = 8'hFF;     #10;

    // Disable
    en = 0;        #10;

    $finish;
end

initial begin
    $monitor("t=%0t  en=%b mode=%b x=%b y=%b",$time,en,mode,x,y);
end

endmodule

