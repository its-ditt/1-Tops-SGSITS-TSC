`timescale 1ns / 1ps

module jtsc_EXStage(

input logic clk,
input logic rst,

//////////////////////////////////////////////////////
// Control Signals from Decode Stage
//////////////////////////////////////////////////////

input logic RegWriteE,
input logic [2:0] ResultSrcE,
input logic MemWriteE,
input logic jumpE,
input logic BranchE,
input logic [3:0] ALUControlE,
input logic ALUSrcE,
//////////////////////////////////////////////////////
// CSR Appendments
//////////////////////////////////////////////////////
input logic csr_enE,
input logic [1:0] csr_opE,

input logic mretE,
input logic ecallE,

input logic [11:0] csr_addrE,
input logic csr_use_immE,
input logic [4:0] zimmE,
//////////////////////////////////////////////////////
// Data Signals from Decode Stage
//////////////////////////////////////////////////////

input logic [31:0] RD1E,
input logic [31:0] RD2E,
input logic [31:0] PCE,

input logic [4:0] RdE,
input logic [4:0] RS1E,
input logic [4:0] RS2E,

input logic [31:0] ImmExtendE,
input logic [31:0] PcPlus4E,

//////////////////////////////////////////////////////
// Forwarding Inputs
//////////////////////////////////////////////////////

input logic [31:0] ResultW,
input logic [1:0] ForwardAE,
input logic [1:0] ForwardBE,

input logic [31:0] ALUResultM_forward,

//////////////////////////////////////////////////////
// Flush
//////////////////////////////////////////////////////

input logic FlushE,

//////////////////////////////////////////////////////
// Branch Function
//////////////////////////////////////////////////////

input logic [2:0] funct3E,

//////////////////////////////////////////////////////
// Outputs to Memory Stage
//////////////////////////////////////////////////////

output logic RegWriteM,
output logic [2:0] ResultSrcM,
output logic MemWriteM,

output logic [31:0] ALUResultM,
output logic [31:0] WriteDataM,
output logic [31:0] CSRDataM,
output logic [4:0] RdM,

output logic [31:0] PcPlus4M,

output logic [2:0] funct3M,

//////////////////////////////////////////////////////
// Branch Outputs
//////////////////////////////////////////////////////

output logic [31:0] PcTargetE,
output logic PcSrcE

);

//////////////////////////////////////////////////////
// Internal Signals
//////////////////////////////////////////////////////
logic [31:0] PcPlusImm;
logic [31:0] SrcAE;
logic [31:0] SrcBE;

logic [31:0] ForwardBData;

logic [31:0] ALUOut;

logic BranchTaken;

logic signed [31:0] sA;
logic signed [31:0] sB;

logic [31:0] uA;
logic [31:0] uB;

logic [31:0] csr_rdata;
logic [31:0] csr_wdata;

logic [31:0] mtvec;
logic [31:0] mepc;
logic [31:0] mstatus;

logic trapE;
assign trapE = ecallE;
//////////////////////////////////////////////////////
// Forwarding MUX A
//////////////////////////////////////////////////////

mux_3_1 mux_hazard_1 (

    .a(RD1E),
    .b(ResultW),
    .c(ALUResultM_forward),
    .s(ForwardAE),

    .muxout(SrcAE)
);

//////////////////////////////////////////////////////
// Forwarding MUX B
//////////////////////////////////////////////////////

mux_3_1 mux_hazard_2 (

    .a(RD2E),
    .b(ResultW),
    .c(ALUResultM_forward),
    .s(ForwardBE),

    .muxout(ForwardBData)
);

//////////////////////////////////////////////////////
// ALU Source MUX
//////////////////////////////////////////////////////

MUX_2_1 alu_src_mux (

    .a(ForwardBData),
    .b(ImmExtendE),
    .sel(ALUSrcE),

    .c(SrcBE)
);



//////////////////////////////////////////////////////
// ALU
//////////////////////////////////////////////////////

logic zeroE;

jtsc_ALU alu (

    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .ALUControlE(ALUControlE),

    .ALUResult(ALUOut),
    .zeroE(zeroE)
);

//////////////////////////////////////////////////////
// CSR call
//////////////////////////////////////////////////////
assign csr_wdata =
    csr_use_immE ?
    {27'b0,zimmE} :
    SrcAE;
    
tsc_csr CSR(

    .clk(clk),
    .rst(rst),

    .csr_en_i(csr_enE),

    .csr_op_i(csr_opE),

    .csr_addr_i(csr_addrE),

    .csr_wdata_i(csr_wdata),

    .csr_rdata_o(csr_rdata),

    .trap_i(trapE),

    .trap_pc_i(PCE),

    .trap_cause_i(32'd11),

    .mret_i(mretE),

    .mtvec_o(mtvec),
    .mepc_o(mepc),
    .mstatus_o(mstatus)

);
//////////////////////////////////////////////////////
// PC Target Adder
//////////////////////////////////////////////////////

adder pc_adder (

    .PCE(PCE),
    .ImmExtendE(ImmExtendE),

    .PcTargetE(PcPlusImm)
);

//////////////////////////////////////////////////////
// Branch Logic
//////////////////////////////////////////////////////

assign sA = SrcAE;
assign sB = SrcBE;
assign uA = SrcAE;
assign uB = SrcBE;

always_comb
begin
    BranchTaken = 1'b0;
    if(BranchE)
    begin

        case(funct3E)

            3'b000: BranchTaken = (SrcAE == SrcBE); // BEQ
            3'b001: BranchTaken = (SrcAE != SrcBE); // BNE
            3'b100: BranchTaken = (sA < sB);        // BLT
            3'b101: BranchTaken = (sA >= sB);       // BGE
            3'b110: BranchTaken = (uA < uB);        // BLTU
            3'b111: BranchTaken = (uA >= uB);       // BGEU

            default:
                BranchTaken = 1'b0;
        endcase
    end
end
assign PcTargetE =
    (trapE) ? mtvec :
    (mretE) ? mepc :
    ((jumpE && ALUSrcE) ?
    (ALUOut & 32'hFFFFFFFE)
    : PcPlusImm);
//////////////////////////////////////////////////////
// PC Source Decision
//////////////////////////////////////////////////////
assign PcSrcE = BranchTaken |
       jumpE |
       trapE |
       mretE;
//////////////////////////////////////////////////////
// EX/MEM Pipeline Register
//////////////////////////////////////////////////////

always_ff @(posedge clk or negedge rst)
begin

    if(!rst)
    begin
        RegWriteM   <= 0;
        ResultSrcM  <= 0;
        MemWriteM   <= 0;
        ALUResultM  <= 0;
        WriteDataM  <= 0;
        RdM         <= 0;
        PcPlus4M    <= 0;
        funct3M     <= 0;
        CSRDataM    <= 0;
    end

//    else if(FlushE)
//    begin
//        RegWriteM   <= 0;
//        ResultSrcM  <= 0;
//        MemWriteM   <= 0;
//        ALUResultM  <= 0;
//        WriteDataM  <= 0;
//        RdM         <= 0;
//        PcPlus4M    <= 0;
//        funct3M     <= 0;
//    end
    else
    begin

        RegWriteM   <= RegWriteE;
        ResultSrcM  <= ResultSrcE;
        MemWriteM   <= MemWriteE;
        ALUResultM  <= ALUOut;
        CSRDataM <= csr_rdata;
        // Store forwarded store data
        WriteDataM  <= ForwardBData;
        RdM         <= RdE;
        PcPlus4M    <= PcPlus4E;
        funct3M     <= funct3E;
    end
end

endmodule