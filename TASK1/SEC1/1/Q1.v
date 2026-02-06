`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2026 14:30:33
// Design Name: 
// Module Name: RED
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


module RED(
    input  clk,
    input  signal,
    output pulse
);

reg prev;

always @(posedge clk) begin
    prev <= signal;
end

assign pulse = signal & ~prev;  // 1-cycle pulse
endmodule

