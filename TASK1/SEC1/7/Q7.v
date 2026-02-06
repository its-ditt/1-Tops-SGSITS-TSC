`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 18:01:44
// Design Name: 
// Module Name: Q7
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


module sync_2ff(
    input  clk_dst,
    input  d_async,
    output reg q_sync
);

reg q1;

always @(posedge clk_dst) begin
    q1     <= d_async;
    q_sync <= q1;
end

endmodule

