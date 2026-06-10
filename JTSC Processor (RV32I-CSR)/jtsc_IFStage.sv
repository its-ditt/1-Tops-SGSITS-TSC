`timescale 1ns / 1ps

module jtsc_IFStage(

input logic clk,
input logic rst,

input logic PcSrcE,
input logic StallF,

input logic [31:0] PcTargetE,

output logic [31:0] InstrD,
output logic [31:0] PcD,
output logic [31:0] PcPlus4D

);

//////////////////////////////////////////////////////
// Internal Signals
//////////////////////////////////////////////////////

logic [31:0] PCF;
logic [31:0] PC_Next;
logic [31:0] InstrF;
logic [31:0] PcPlus4F;

//////////////////////////////////////////////////////
// PC MUX
//////////////////////////////////////////////////////

MUX_2_1 mux(

    .a(PcPlus4F),
    .b(PcTargetE),

    .sel(PcSrcE),

    .c(PC_Next)

);

//////////////////////////////////////////////////////
// Program Counter
//////////////////////////////////////////////////////

jtsc_pc_module Pc(

    .clk(clk),
    .rst(rst),

    .Pc_next(PC_Next),

    .Pc(PCF),

    .StallF(StallF)

);

//////////////////////////////////////////////////////
// Instruction Memory
//////////////////////////////////////////////////////

jtsc_imem inst_mem(

    .A(PCF),

    .RD(InstrF)

);

//////////////////////////////////////////////////////
// PC + 4 Adder
//////////////////////////////////////////////////////

jtsc_pc_adder pc_adder(

    .PcF(PCF),

    .PcF_4(PcPlus4F)

);

//////////////////////////////////////////////////////
// IF/ID Pipeline Register
//////////////////////////////////////////////////////

always_ff @(posedge clk or negedge rst)
begin

    if(!rst)
    begin

        InstrD<=32'h00000000;
        PcD<=32'h00000000;
        PcPlus4D<=32'h00000000;

    end

    else if(PcSrcE)
    begin

        InstrD<=32'h00000000;
        PcD<=32'h00000000;
        PcPlus4D<=32'h00000000;

    end

    else if(!StallF)
    begin

        InstrD<=InstrF;
        PcD<=PCF;
        PcPlus4D<=PcPlus4F;

    end

end

endmodule