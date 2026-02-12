`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.02.2026 14:31:28
// Design Name: 
// Module Name: Not_gate
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


`timescale 1ns/1ps
`define DATAFLOW

module Not_gate(input A, output Y);

// STRUCTURAL MODEL
`ifdef STRUCTURAL

    not N1(Y, A);

// DATAFLOW MODEL
`elsif DATAFLOW

    assign Y = ~A;

// BEHAVIORAL MODEL
`else
    reg Y_reg;
    assign Y = Y_reg;

    always @(*) begin
        if (A)
            Y_reg = 1'b0;
        else
            Y_reg = 1'b1;
    end
`endif

endmodule
