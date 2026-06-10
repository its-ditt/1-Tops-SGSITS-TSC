`timescale 1ns / 1ps

module jtsc_IDStage(

input logic clk,
input logic rst,

input logic RegWriteW,

input logic [31:0] InstrD,
input logic [31:0] PCD,
input logic [31:0] PcPlus4D,

input logic [31:0] ResultW,
input logic [4:0] RdW,

input logic StallD,
input logic FlushD,

output logic RegWriteE,
output logic [2:0] ResultSrcE,
output logic MemWriteE,
output logic jumpE,
output logic BranchE,
output logic [3:0] ALUControlE,
output logic ALUSrcE,

output logic csr_enE,
output logic [1:0] csr_opE,
output logic mretE,
output logic ecallE,
output logic [11:0] csr_addrE,
output logic csr_use_immE,
output logic [4:0] zimmE,

output logic [31:0] RD1E,
output logic [31:0] RD2E,
output logic [31:0] PCE,

output logic [4:0] RdE,
output logic [4:0] RS1E,
output logic [4:0] RS2E,

output logic [31:0] ImmExtendE,
output logic [31:0] PcPlus4E,

output logic [4:0] RS1D,
output logic [4:0] RS2D,

output logic [2:0] funct3E

);

logic RegWriteD;
logic MemWriteD;
logic jumpD;
logic BranchD;
logic ALUSrcD;

logic [2:0] ResultSrcD;
logic [3:0] ALUControlD;
logic [1:0] ImmSrcD;

logic csr_enD;
logic [1:0] csr_opD;
logic mretD;
logic ecallD;
logic csr_use_immD;
logic [4:0] zimmD;

logic [11:0] csr_addrD;

logic [31:0] RD1D;
logic [31:0] RD2D;
logic [31:0] ImmExtendD;

logic [4:0] RdD;

assign RdD=InstrD[11:7];

assign RS1D=InstrD[19:15];

assign RS2D=InstrD[24:20];

assign csr_addrD=InstrD[31:20];

assign zimmD=InstrD[19:15];

jtsc_ctrl_unit control(

    .op(InstrD[6:0]),
    .funct3(InstrD[14:12]),
    .funct7(InstrD[31:25]),

    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .jumpD(jumpD),
    .BranchD(BranchD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .ImmSrcD(ImmSrcD),

    .csr_enD(csr_enD),
    .csr_opD(csr_opD),
    .csr_use_immD(csr_use_immD),
    .mretD(mretD),
    .ecallD(ecallD)

);

jtsc_regfile register_file(

    .clk(clk),
    .rst(rst),

    .A1(InstrD[19:15]),
    .A2(InstrD[24:20]),

    .A3(RdW),

    .WD3(ResultW),
    .WE3(RegWriteW),

    .RD1(RD1D),
    .RD2(RD2D)

);

jtsc_signext extend(

    .Instr(InstrD),
    .ImmSrc(ImmSrcD),
    .ImmExtend(ImmExtendD)

);

always_ff @(posedge clk or negedge rst)
begin

    if(!rst)
    begin

        RegWriteE<=0;
        ResultSrcE<=0;
        MemWriteE<=0;
        jumpE<=0;
        BranchE<=0;
        ALUControlE<=0;
        ALUSrcE<=0;

        csr_enE<=0;
        csr_opE<=0;
        mretE<=0;
        ecallE<=0;
        csr_addrE<=0;
        csr_use_immE<=0;
        zimmE<=0;
        RD1E<=0;
        RD2E<=0;
        PCE<=0;

        RdE<=0;
        RS1E<=0;
        RS2E<=0;

        ImmExtendE<=0;
        PcPlus4E<=0;

        funct3E<=0;

    end

    else if(FlushD)
    begin

        RegWriteE<=0;
        ResultSrcE<=0;
        MemWriteE<=0;
        jumpE<=0;
        BranchE<=0;
        ALUControlE<=0;
        ALUSrcE<=0;

        csr_enE<=0;
        csr_opE<=0;
        mretE<=0;
        ecallE<=0;
        csr_addrE<=0;
        csr_use_immE<=0;
        zimmE<=0;

        RD1E<=0;
        RD2E<=0;
        PCE<=0;

        RdE<=0;
        RS1E<=0;
        RS2E<=0;

        ImmExtendE<=0;
        PcPlus4E<=0;

        funct3E<=0;

    end

    else if(!StallD)
    begin

        RegWriteE<=RegWriteD;
        ResultSrcE<=ResultSrcD;
        MemWriteE<=MemWriteD;
        jumpE<=jumpD;
        BranchE<=BranchD;
        ALUControlE<=ALUControlD;
        ALUSrcE<=ALUSrcD;

        csr_enE<=csr_enD;
        csr_opE<=csr_opD;
        csr_use_immE<=csr_use_immD;

        mretE<=mretD;
        ecallE<=ecallD;

        csr_addrE<=csr_addrD;
        zimmE<=zimmD;

        RD1E<=RD1D;
        RD2E<=RD2D;
        PCE<=PCD;

        RdE<=RdD;
        RS1E<=RS1D;
        RS2E<=RS2D;

        ImmExtendE<=ImmExtendD;
        PcPlus4E<=PcPlus4D;

        funct3E<=InstrD[14:12];

    end

end

endmodule
