`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 20:57:30
// Design Name: 
// Module Name: cgcontrol
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


module cgcontrol( input logic clk,en, output logic clko);
logic ennext;

always_latch begin
    if(!clk)
        ennext <= en;
end

assign clko = clk & ennext; 
endmodule
