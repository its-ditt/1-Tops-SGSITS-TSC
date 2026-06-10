`timescale 1ns / 1ps

module jtsc_ctrl_unit(

input logic [6:0] op,
input logic [2:0] funct3,
input logic [6:0] funct7,

output logic RegWriteD,
output logic [2:0] ResultSrcD,
output logic MemWriteD,
output logic jumpD,
output logic BranchD,
output logic [3:0] ALUControlD,
output logic ALUSrcD,
output logic [1:0] ImmSrcD,

//////////////////////////////////////////////////////
// CSR CONTROL
//////////////////////////////////////////////////////

output logic csr_enD,
output logic [1:0] csr_opD,
output logic csr_use_immD,

output logic mretD,
output logic ecallD

);

logic [1:0] ALUOpConnec;

//////////////////////////////////////////////////////
// ALU DECODER
//////////////////////////////////////////////////////

jtsc_aludec alu (

    .op(op),
    .funct3(funct3),
    .funct7(funct7),

    .ALUOp(ALUOpConnec),

    .ALUControl(ALUControlD)

);

//////////////////////////////////////////////////////
// MAIN DECODER
//////////////////////////////////////////////////////

jtsc_dec decoder (

    .op(op),
    .funct3(funct3),

    .ResultSrc(ResultSrcD),

    .MemWrite(MemWriteD),
    .ALUSrc(ALUSrcD),

    .ImmSrc(ImmSrcD),

    .RegWrite(RegWriteD),

    .jump(jumpD),
    .Branch(BranchD),

    .ALUOp(ALUOpConnec),

    //////////////////////////////////////////////////////
    // CSR
    //////////////////////////////////////////////////////

    .csr_en(csr_enD),
    .csr_op(csr_opD),
    .csr_use_imm(csr_use_immD),
    
    .mret(mretD),
    .ecall(ecallD)

);

endmodule
