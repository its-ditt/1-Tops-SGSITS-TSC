`timescale 1ns / 1ps
`define STRUCTURAL

module Ripple_CA(
    input [7:0] A,B,
    output [15:0] Sum
    );
wire C0, C1, C2, C3, C4, C5, C6;

assign Sum[15:9] = 7'b0000000;
Half_adder A0(A[0],B[0],Sum[0],C0);
Full_adder A1(A[1],B[1],C0,Sum[1],C1);
Full_adder A2(A[2],B[2],C1,Sum[2],C2);
Full_adder A3(A[3],B[3],C2,Sum[3],C3);
Full_adder A4(A[4],B[4],C3,Sum[4],C4);
Full_adder A5(A[5],B[5],C4,Sum[5],C5);
Full_adder A6(A[6],B[6],C5,Sum[6],C6);
Full_adder A7(A[7],B[7],C6,Sum[7],Sum[8]);

endmodule
