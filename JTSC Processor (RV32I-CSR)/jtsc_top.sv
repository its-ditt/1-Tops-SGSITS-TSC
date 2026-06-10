`timescale 1ns / 1ps

module jtsc_top(

input logic clk,
input logic rst,

output logic [31:0] debug_out

);

//////////////////////////////////////////////////////
// IF STAGE SIGNALS
//////////////////////////////////////////////////////

logic [31:0] InstrD;
logic [31:0] PcD;
logic [31:0] PcPlus4D;

//////////////////////////////////////////////////////
// ID → EX SIGNALS
//////////////////////////////////////////////////////

logic RegWriteE;
logic [2:0] ResultSrcE;

logic MemWriteE;

logic jumpE;
logic BranchE;

logic [3:0] ALUControlE;

logic ALUSrcE;

logic csr_enE;
logic [1:0] csr_opE;

logic mretE;
logic ecallE;

logic [11:0] csr_addrE;
logic csr_use_immE;
logic [4:0] zimmE;

logic [31:0] RD1E;
logic [31:0] RD2E;

logic [31:0] PCE;

logic [4:0] RdE;

logic [4:0] RS1E;
logic [4:0] RS2E;

logic [31:0] ImmExtendE;

logic [31:0] PcPlus4E;

logic [2:0] funct3E;

//////////////////////////////////////////////////////
// EX → MEM SIGNALS
//////////////////////////////////////////////////////

logic RegWriteM;

logic [2:0] ResultSrcM;

logic MemWriteM;

logic [31:0] ALUResultM;
logic [31:0] WriteDataM;

logic [31:0] CSRDataM;

logic [4:0] RdM;

logic [31:0] PcPlus4M;

logic [2:0] funct3M;

logic [31:0] PcTargetE;
logic PcSrcE;

//////////////////////////////////////////////////////
// MEM → WB SIGNALS
//////////////////////////////////////////////////////

logic RegWriteW;

logic [2:0] ResultSrcW;

logic [31:0] ALUResultW;
logic [31:0] ReadDataW;

logic [31:0] CSRDataW;

logic [4:0] RdW;

logic [31:0] PcPlus4W;

//////////////////////////////////////////////////////
// WB SIGNALS
//////////////////////////////////////////////////////

logic [31:0] ResultW;

//////////////////////////////////////////////////////
// HAZARD SIGNALS
//////////////////////////////////////////////////////

logic [1:0] ForwardAE;
logic [1:0] ForwardBE;

logic StallF;
logic StallD;

logic FlushD;
logic FlushE;

logic [4:0] RS1D;
logic [4:0] RS2D;

logic lw_stall;

//////////////////////////////////////////////////////
// IF STAGE
//////////////////////////////////////////////////////

jtsc_IFStage fetch(
.clk(clk),
.rst(rst),
.PcSrcE(PcSrcE),
.StallF(StallF),
.PcTargetE(PcTargetE),
.InstrD(InstrD),
.PcD(PcD),
.PcPlus4D(PcPlus4D)
);

//////////////////////////////////////////////////////
// ID STAGE
//////////////////////////////////////////////////////

jtsc_IDStage decode(
.clk(clk),
.rst(rst),
.RegWriteW(RegWriteW),
.InstrD(InstrD),
.PCD(PcD),
.PcPlus4D(PcPlus4D),
.ResultW(ResultW),
.RdW(RdW),
.StallD(StallD),
.FlushD(FlushD),

.RegWriteE(RegWriteE),
.ResultSrcE(ResultSrcE),
.MemWriteE(MemWriteE),
.jumpE(jumpE),
.BranchE(BranchE),
.ALUControlE(ALUControlE),
.ALUSrcE(ALUSrcE),

.csr_enE(csr_enE),
.csr_opE(csr_opE),
.csr_use_immE(csr_use_immE),

.mretE(mretE),
.ecallE(ecallE),

.csr_addrE(csr_addrE),
.zimmE(zimmE),

.RD1E(RD1E),
.RD2E(RD2E),
.PCE(PCE),
.RdE(RdE),
.RS1E(RS1E),
.RS2E(RS2E),
.ImmExtendE(ImmExtendE),
.PcPlus4E(PcPlus4E),

.RS1D(RS1D),
.RS2D(RS2D),

.funct3E(funct3E)
);

//////////////////////////////////////////////////////
// EX STAGE
//////////////////////////////////////////////////////

jtsc_EXStage execute(
.clk(clk),
.rst(rst),

.RegWriteE(RegWriteE),
.ResultSrcE(ResultSrcE),
.MemWriteE(MemWriteE),
.jumpE(jumpE),
.BranchE(BranchE),
.ALUControlE(ALUControlE),
.ALUSrcE(ALUSrcE),

.csr_enE(csr_enE),
.csr_opE(csr_opE),

.csr_use_immE(csr_use_immE),

.mretE(mretE),
.ecallE(ecallE),

.csr_addrE(csr_addrE),
.zimmE(zimmE),

.RD1E(RD1E),
.RD2E(RD2E),
.PCE(PCE),

.RdE(RdE),
.RS1E(RS1E),
.RS2E(RS2E),

.ImmExtendE(ImmExtendE),
.PcPlus4E(PcPlus4E),

.ResultW(ResultW),

.ForwardAE(ForwardAE),
.ForwardBE(ForwardBE),

.ALUResultM_forward(ALUResultM),

.FlushE(FlushE),

.funct3E(funct3E),

.RegWriteM(RegWriteM),
.ResultSrcM(ResultSrcM),
.MemWriteM(MemWriteM),

.ALUResultM(ALUResultM),
.WriteDataM(WriteDataM),
.CSRDataM(CSRDataM),

.RdM(RdM),

.PcPlus4M(PcPlus4M),

.funct3M(funct3M),

.PcTargetE(PcTargetE),
.PcSrcE(PcSrcE)
);

//////////////////////////////////////////////////////
// MEM STAGE
//////////////////////////////////////////////////////

jtsc_MEMStage memory_stage(
.clk(clk),
.rst(rst),

.RegWriteM(RegWriteM),
.ResultSrcM(ResultSrcM),

.MemWriteM(MemWriteM),

.ALUResultM(ALUResultM),
.WriteDataM(WriteDataM),
.CSRDataM(CSRDataM),

.RdM(RdM),

.PcPlus4M(PcPlus4M),

.funct3M(funct3M),

.RegWriteW(RegWriteW),
.ResultSrcW(ResultSrcW),

.ALUResultW(ALUResultW),
.ReadDataW(ReadDataW),
.CSRDataW(CSRDataW),

.RdW(RdW),

.PcPlus4W(PcPlus4W)
);

//////////////////////////////////////////////////////
// WB STAGE
//////////////////////////////////////////////////////

jtsc_WBstage wb(
.RegWriteW(RegWriteW),

.ResultSrcW(ResultSrcW),

.ALUResultW(ALUResultW),
.ReadDataW(ReadDataW),
.CSRDataW(CSRDataW),

.RdW(RdW),

.PcPlus4W(PcPlus4W),

.ResultW(ResultW)
);

//////////////////////////////////////////////////////
// HAZARD UNIT
//////////////////////////////////////////////////////

jtsc_hazard hazard(
.rst(rst),

.RegWriteM(RegWriteM),
.RegWriteW(RegWriteW),

.RdM(RdM),
.RdW(RdW),

.Rs1E(RS1E),
.Rs2E(RS2E),

.Rs1D(RS1D),
.Rs2D(RS2D),

.RdE(RdE),

.ResultSrcE(ResultSrcE),

.PcSrcE(PcSrcE),

.StallF(StallF),
.StallD(StallD),

.FlushE(FlushE),
.FlushD(FlushD),

.ForwardAE(ForwardAE),
.ForwardBE(ForwardBE),

.lw_stall(lw_stall)
);

//////////////////////////////////////////////////////
// DEBUG
//////////////////////////////////////////////////////

assign debug_out = ResultW;

endmodule