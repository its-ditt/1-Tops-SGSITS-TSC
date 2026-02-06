`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 17:05:49
// Design Name: 
// Module Name: Q12
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


module cmp8(a,b,eq,gt,lt);
input  [7:0] a,b;
output       eq,gt,lt;

wire [7:0] x;
wire [7:0] ms;

assign x  = a ^ b;
assign eq = ~(|x);

assign ms[7] = x[7];
assign ms[6] = x[6] & ~(|x[7]);
assign ms[5] = x[5] & ~(|x[7:6]);
assign ms[4] = x[4] & ~(|x[7:5]);
assign ms[3] = x[3] & ~(|x[7:4]);
assign ms[2] = x[2] & ~(|x[7:3]);
assign ms[1] = x[1] & ~(|x[7:2]);
assign ms[0] = x[0] & ~(|x[7:1]);

assign gt = |(ms &  a);
assign lt = |(ms & ~a);

endmodule

