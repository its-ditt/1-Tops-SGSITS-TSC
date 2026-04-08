`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 22-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: Inst. Fetch (top)                                              //
// Module Name: tsc_if_stage                                                   //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_if_stage (

    input  logic        clk,
    input  logic        rst,

    input  logic        stall_i,
    input  logic        flush_i,

    input  logic        pc_src_i,
    input  logic [31:0] pc_target_i,

    output logic [31:0] instr_o,
    output logic [31:0] pc_o,
    output logic [31:0] pc4_o

);

    // ================= PC =================
    logic [31:0] pc, pc4;

    tsc_pc PC (
        .clk(clk),
        .rst(rst),
        .en_i(~stall_i),
        .pc_src_i(pc_src_i),
        .pc_target_i(pc_target_i),
        .pc_o(pc),
        .pc_plus4_o(pc4)
    );

    // ================= IMEM =================
    logic [31:0] instr;

    tsc_imem IMEM (
        .addr_i(pc),
        .instr_o(instr)
    );

    // ================= IF/ID REGISTER =================
    tsc_if_id_reg IF_ID (
        .clk(clk),
        .rst(rst),
        .en_i(~stall_i),
        .flush_i(flush_i),

        .instr_i(instr),
        .pc_i(pc),
        .pc4_i(pc4),

        .instr_o(instr_o),
        .pc_o(pc_o),
        .pc4_o(pc4_o)
    );

endmodule
