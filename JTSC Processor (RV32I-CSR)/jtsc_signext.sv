`timescale 1ns / 1ps


module jtsc_signext(
input logic [31:0]Instr,
input logic [1:0] ImmSrc,
output logic [31:0] ImmExtend
    );
    assign ImmExtend = (ImmSrc == 2'b00)?{{20{Instr[31]}}, Instr[31:20]}:
                       (ImmSrc == 2'b01)?{{20{Instr[31]}}, Instr[31:25], Instr[11:7]}:
                       (ImmSrc == 2'b10)?{{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}:
                       {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
endmodule
