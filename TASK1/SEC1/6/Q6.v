`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2026 20:02:59
// Design Name: 
// Module Name: clock_div_5
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


module clock_div_5(
    input clk,
    input rst,
    output reg clk_out
);

reg [2:0] cnt_p;
reg [2:0] cnt_n;

always @(posedge clk or posedge rst) begin
    if(rst) cnt_p <= 0;
    else if(cnt_p == 4) cnt_p <= 0;
    else cnt_p <= cnt_p + 1;
end

always @(negedge clk or posedge rst) begin
    if(rst) cnt_n <= 0;
    else if(cnt_n == 4) cnt_n <= 0;
    else cnt_n <= cnt_n + 1;
end

always @(*) begin
    clk_out = (cnt_p < 3) & (cnt_n < 3);
end

endmodule

