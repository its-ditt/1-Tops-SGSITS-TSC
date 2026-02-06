`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2026 18:01:44
// Design Name: 
// Module Name: Q4
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


module barrel_shifter #(parameter N=32)(
    input  [N-1:0] a,
    input  [$clog2(N)-1:0] shamt,
    input  [1:0] mode,        // 00 LSL, 01 LSR, 10 ASR
    output reg [N-1:0] y
);

always @(*) begin
    case(mode)
        2'b00: y = a << shamt;
        2'b01: y = a >> shamt;
        2'b10: y = $signed(a) >>> shamt;
        default: y = a;
    endcase
end

endmodule

