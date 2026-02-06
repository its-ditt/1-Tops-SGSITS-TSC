`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 17:15:03
// Design Name: 
// Module Name: Q9
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

module updown4(
    input clk,
    input rst,
    input dir,   // 1u0d
    output reg [3:0] q
);
always @(posedge clk) begin
    if (rst)
        q <= 4'd0;
    else if (dir)
        q <= q + 1;
    else
        q <= q - 1;
end
endmodule

