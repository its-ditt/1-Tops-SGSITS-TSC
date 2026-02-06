`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 17:36:05
// Design Name: 
// Module Name: FED
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


module FED(
    input  clk,
    input  signal,
    output pulse
);

reg prev;

always @(posedge clk) begin
    prev <= signal;
end

assign pulse = ~signal & prev;  // 1-cycle pulse
endmodule
