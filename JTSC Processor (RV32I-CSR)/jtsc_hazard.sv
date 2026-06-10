`timescale 1ns / 1ps

module jtsc_hazard(

input logic rst,

input logic RegWriteM,
input logic RegWriteW,

input logic [4:0] RdM,
input logic [4:0] RdW,

input logic [4:0] Rs1E,
input logic [4:0] Rs2E,

input logic [4:0] Rs1D,
input logic [4:0] Rs2D,

input logic [4:0] RdE,

input logic [2:0] ResultSrcE,

input logic PcSrcE,

output logic StallF,
output logic StallD,
output logic FlushE,
output logic FlushD,

output logic [1:0] ForwardAE,
output logic [1:0] ForwardBE,

output logic lw_stall

);

assign ForwardAE =
    (!rst) ? 2'b00 :
    ((RegWriteM)&&(RdM!=0)&&(RdM==Rs1E)) ? 2'b10 :
    ((RegWriteW)&&(RdW!=0)&&(RdW==Rs1E)) ? 2'b01 :
    2'b00;

assign ForwardBE =
    (!rst) ? 2'b00 :
    ((RegWriteM)&&(RdM!=0)&&(RdM==Rs2E)) ? 2'b10 :
    ((RegWriteW)&&(RdW!=0)&&(RdW==Rs2E)) ? 2'b01 :
    2'b00;

assign lw_stall =
       (ResultSrcE==3'b001) &&
       (RdE!=5'b00000) &&
       ((RdE==Rs1D)||(RdE==Rs2D));

assign StallF = lw_stall;

assign StallD = lw_stall;

assign FlushE = PcSrcE;

assign FlushD = lw_stall | PcSrcE;

endmodule