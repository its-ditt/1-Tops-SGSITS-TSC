`timescale 1ns / 1ps

module jtsc_MEMStage(

input logic clk,
input logic rst,

input logic RegWriteM,
input logic [2:0] ResultSrcM,

input logic MemWriteM,

input logic [31:0] ALUResultM,
input logic [31:0] WriteDataM,
input logic [31:0] CSRDataM,

input logic [4:0] RdM,

input logic [31:0] PcPlus4M,

input logic [2:0] funct3M,

output logic RegWriteW,
output logic [2:0] ResultSrcW,

output logic [31:0] ALUResultW,
output logic [31:0] ReadDataW,
output logic [31:0] CSRDataW,

output logic [4:0] RdW,

output logic [31:0] PcPlus4W

);

//////////////////////////////////////////////////////
// DATA MEMORY
//////////////////////////////////////////////////////

logic [31:0] ReadDataM;

jtsc_dmem dmem (

    .clk(clk),

    .MemWrite(MemWriteM),

    .funct3M(funct3M),

    .A(ALUResultM),

    .WD(WriteDataM),

    .RD(ReadDataM)

);

//////////////////////////////////////////////////////
// MEM/WB PIPELINE REGISTER
//////////////////////////////////////////////////////

always_ff @(posedge clk or negedge rst)
begin

    if(!rst)
    begin

        RegWriteW <= 1'b0;

        ResultSrcW <= 3'b000;

        ALUResultW <= 32'b0;
        ReadDataW  <= 32'b0;
        CSRDataW   <= 32'b0;

        RdW <= 5'b0;

        PcPlus4W <= 32'b0;

    end

    else
    begin

        RegWriteW <= RegWriteM;

        ResultSrcW <= ResultSrcM;

        ALUResultW <= ALUResultM;

        ReadDataW <= ReadDataM;

        CSRDataW <= CSRDataM;

        RdW <= RdM;

        PcPlus4W <= PcPlus4M;

    end

end

endmodule