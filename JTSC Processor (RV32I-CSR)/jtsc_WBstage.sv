`timescale 1ns / 1ps


module jtsc_WBstage(

input logic RegWriteW,

input logic [2:0] ResultSrcW,

input logic [31:0] ALUResultW,
input logic [31:0] ReadDataW,
input logic [31:0] CSRDataW,

input logic [4:0] RdW,

input logic [31:0] PcPlus4W,

output logic [31:0] ResultW

);

always_comb begin

    case(ResultSrcW)

        3'b000: ResultW=ALUResultW;

        3'b001: ResultW=ReadDataW;

        3'b010: ResultW=PcPlus4W;

        3'b011: ResultW=CSRDataW;

        default: ResultW=32'b0;

    endcase

end

endmodule
