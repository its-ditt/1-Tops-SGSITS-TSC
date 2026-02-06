`timescale 1ns / 1ps
//`define STRUC
//`define DFLOW
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 15:03:02
// Design Name: 
// Module Name: Full_Adder
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


module Full_Adder(
input logic a,b,ci,
output logic s,co
    );
    
`ifdef DFLOW  
//dataflow  
assign s=a^b^ci;
assign co=a&b|ci&(a^b);

`elsif STRUC
//structural
logic s1,a1,a2;
xor X1(s1,a,b);
xor X2(s,s1,ci);
and A1(a1,a,b);
and A2(a2,ci,s1);
or O1(co,a1,a2);

`else
//behaviorual
always_comb begin
        s=a^b^ci;
        co=(a&b)|(b&ci)|(a&ci);
    end
    
`endif


endmodule
