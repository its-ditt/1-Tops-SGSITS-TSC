`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 24-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: Decode Stage                                                   //
// Module Name: tsc_id_stage                                                   //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_id_stage (

    input  logic clk,
    input  logic rst,

    input  logic [31:0] instr_i,
    input  logic [31:0] pc_i,

    // WB feedback
    input  logic [31:0] wb_data_i,
    input  logic [4:0]  wb_rd_i,
    input  logic        wb_we_i,

    input  logic        flush_i,

    // OUTPUT TO EX
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o,
    output logic [31:0] imm_o,
    output logic [31:0] pc_o,

    output logic [4:0] rs1_o,
    output logic [4:0] rs2_o,
    output logic [4:0] rd_o,

    output logic [2:0] funct3_o,

    output logic [3:0] alu_op_o,
    output logic       alu_src_o,
    output logic       branch_o,
    output logic       jump_o,

    output logic       mem_read_o,
    output logic       mem_write_o,
    output logic       reg_write_o,
    output logic       wb_sel_o,

    output logic       use_muldiv_o,
    output logic [1:0] muldiv_op_o
);

    // ================= DECODE =================
    logic [6:0] opcode = instr_i[6:0];
    logic [4:0] rs1    = instr_i[19:15];
    logic [4:0] rs2    = instr_i[24:20];
    logic [4:0] rd     = instr_i[11:7];
    logic [2:0] funct3 = instr_i[14:12];
    logic [6:0] funct7 = instr_i[31:25];

    // ================= REGFILE =================
    logic [31:0] rs1_data, rs2_data;

    tsc_regfile RF (
        .clk(clk),
        .rst(rst),
        .rs1_i(rs1),
        .rs2_i(rs2),
        .rd_i(wb_rd_i),
        .wd_i(wb_data_i),
        .we_i(wb_we_i),
        .rd1_o(rs1_data),
        .rd2_o(rs2_data)
    );

    // ================= IMM GEN =================
    logic [2:0] imm_sel;

    always_comb begin
        case (opcode)
            7'b0010011, 7'b0000011: imm_sel = 3'b000;
            7'b0100011: imm_sel = 3'b001;
            7'b1100011: imm_sel = 3'b010;
            default:    imm_sel = 3'b000;
        endcase
    end

    logic [31:0] imm;

    tsc_immgen IMM (
        .instr_i(instr_i),
        .imm_sel_i(imm_sel),
        .imm_o(imm)
    );

    // ================= CONTROL =================
    logic [3:0] alu_op;
    logic alu_src, branch, jump;
    logic mem_read, mem_write, reg_write, wb_sel;
    logic use_muldiv;
    logic [1:0] muldiv_op;

    tsc_ctrl_unit CU (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .alu_op_o(alu_op),
        .alu_src_o(alu_src),
        .branch_o(branch),
        .jump_o(jump),

        .mem_read_o(mem_read),
        .mem_write_o(mem_write),
        .reg_write_o(reg_write),
        .wb_sel_o(wb_sel),

        .use_muldiv_o(use_muldiv),
        .muldiv_op_o(muldiv_op)
    );

    // ================= ID/EX REGISTER =================
    tsc_id_ex_reg ID_EX (
        .clk(clk),
        .rst(rst),
        .flush_i(flush_i),

        .rs1_data_i(rs1_data),
        .rs2_data_i(rs2_data),
        .imm_i(imm),
        .pc_i(pc_i),

        .rs1_i(rs1),
        .rs2_i(rs2),
        .rd_i(rd),

        .funct3_i(funct3),

        .alu_op_i(alu_op),
        .alu_src_i(alu_src),
        .branch_i(branch),
        .jump_i(jump),

        .mem_read_i(mem_read),
        .mem_write_i(mem_write),
        .reg_write_i(reg_write),
        .wb_sel_i(wb_sel),

        .use_muldiv_i(use_muldiv),
        .muldiv_op_i(muldiv_op),

        .rs1_data_o(rs1_data_o),
        .rs2_data_o(rs2_data_o),
        .imm_o(imm_o),
        .pc_o(pc_o),

        .rs1_o(rs1_o),
        .rs2_o(rs2_o),
        .rd_o(rd_o),

        .funct3_o(funct3_o),

        .alu_op_o(alu_op_o),
        .alu_src_o(alu_src_o),
        .branch_o(branch_o),
        .jump_o(jump_o),

        .mem_read_o(mem_read_o),
        .mem_write_o(mem_write_o),
        .reg_write_o(reg_write_o),
        .wb_sel_o(wb_sel_o),

        .use_muldiv_o(use_muldiv_o),
        .muldiv_op_o(muldiv_op_o)
    );

endmodule