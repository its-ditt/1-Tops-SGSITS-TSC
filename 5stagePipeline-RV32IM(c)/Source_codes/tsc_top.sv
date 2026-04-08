`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 25-03-2026                                                     //
// Latest revision: 25-03-2026                                                 //
// Design Name: TSCSoC Core Top Module                                         //
// Module Name: tsc_top                                                        //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_top (

    input logic clk,
    input logic rst

);

    // ================= GLOBAL =================
    logic hazard_stall, ex_stall, stall;
    assign stall = hazard_stall | ex_stall;

    logic pc_src;
    logic [31:0] pc_target;

    // ================= IF =================
    logic [31:0] instr_if, pc_if, pc4_if;

    tsc_if_stage IF (
        .clk(clk),
        .rst(rst),
        .stall_i(stall),
        .flush_i(pc_src),
        .pc_src_i(pc_src),
        .pc_target_i(pc_target),
        .instr_o(instr_if),
        .pc_o(pc_if),
        .pc4_o(pc4_if)
    );

    // ================= ID =================
    logic [31:0] rs1_data_ex, rs2_data_ex, imm_ex, pc_ex;
    logic [4:0] rs1_ex, rs2_ex, rd_ex;
    logic [2:0] funct3_ex;

    logic [3:0] alu_op_ex;
    logic alu_src_ex, branch_ex, jump_ex;

    logic mem_read_ex, mem_write_ex, reg_write_ex, wb_sel_ex;

    logic use_muldiv_ex;
    logic [1:0] muldiv_op_ex;

    logic [31:0] wb_data;
    logic [4:0] wb_rd;
    logic wb_we;

    tsc_id_stage ID (
        .clk(clk),
        .rst(rst),
        .instr_i(instr_if),
        .pc_i(pc_if),

        .wb_data_i(wb_data),
        .wb_rd_i(wb_rd),
        .wb_we_i(wb_we),

        .flush_i(pc_src),

        .rs1_data_o(rs1_data_ex),
        .rs2_data_o(rs2_data_ex),
        .imm_o(imm_ex),
        .pc_o(pc_ex),

        .rs1_o(rs1_ex),
        .rs2_o(rs2_ex),
        .rd_o(rd_ex),

        .funct3_o(funct3_ex),

        .alu_op_o(alu_op_ex),
        .alu_src_o(alu_src_ex),
        .branch_o(branch_ex),
        .jump_o(jump_ex),

        .mem_read_o(mem_read_ex),
        .mem_write_o(mem_write_ex),
        .reg_write_o(reg_write_ex),
        .wb_sel_o(wb_sel_ex),

        .use_muldiv_o(use_muldiv_ex),
        .muldiv_op_o(muldiv_op_ex)
    );

    // ================= HAZARD =================
    tsc_hazard HAZARD (
        .id_rs1_i(rs1_ex),
        .id_rs2_i(rs2_ex),
        .ex_rd_i(rd_ex),
        .ex_mem_read_i(mem_read_ex),
        .stall_o(hazard_stall)
    );

    // ================= FORWARD =================
    logic [1:0] forward_a, forward_b;
    logic [4:0] mem_rd;
    logic mem_reg_write;

    tsc_forward FWD (
        .ex_rs1_i(rs1_ex),
        .ex_rs2_i(rs2_ex),
        .mem_rd_i(mem_rd),
        .mem_reg_write_i(mem_reg_write),
        .wb_rd_i(wb_rd),
        .wb_reg_write_i(wb_we),
        .forward_a_o(forward_a),
        .forward_b_o(forward_b)
    );

    // ================= EX =================
    logic [31:0] ex_result, ex_rs2;
    logic [4:0] ex_rd;

    logic ex_mem_read, ex_mem_write, ex_reg_write, ex_wb_sel;
    logic branch_taken;
    logic [31:0] pc_target_ex;

    logic [31:0] mem_alu_result; // needed for forwarding

    tsc_ex_unit EX (
        .clk(clk),
        .rst(rst),

        .rs1_data_i(rs1_data_ex),
        .rs2_data_i(rs2_data_ex),
        .imm_i(imm_ex),
        .pc_i(pc_ex),

        .rs1_i(rs1_ex),
        .rs2_i(rs2_ex),
        .rd_i(rd_ex),

        .funct3_i(funct3_ex),

        .alu_op_i(alu_op_ex),
        .alu_src_i(alu_src_ex),
        .branch_i(branch_ex),
        .jump_i(jump_ex),

        .mem_read_i(mem_read_ex),
        .mem_write_i(mem_write_ex),
        .reg_write_i(reg_write_ex),
        .wb_sel_i(wb_sel_ex),

        .use_muldiv_i(use_muldiv_ex),
        .muldiv_op_i(muldiv_op_ex),

        .forward_a_i(forward_a),
        .forward_b_i(forward_b),
        .mem_result_i(mem_alu_result),
        .wb_data_i(wb_data),

        .alu_result_o(ex_result),
        .rs2_forward_o(ex_rs2),
        .rd_o(ex_rd),

        .mem_read_o(ex_mem_read),
        .mem_write_o(ex_mem_write),
        .reg_write_o(ex_reg_write),
        .wb_sel_o(ex_wb_sel),

        .branch_taken_o(branch_taken),
        .pc_target_o(pc_target_ex),

        .stall_o(ex_stall)
    );

    assign pc_src = branch_taken;
    assign pc_target = pc_target_ex;

    // ================= EX/MEM =================
    logic [31:0] mem_rs2;
    logic mem_mem_read, mem_mem_write, mem_wb_sel;

    tsc_ex_mem_reg EX_MEM (
        .clk(clk),
        .rst(rst),

        .alu_result_i(ex_result),
        .rs2_data_i(ex_rs2),
        .rd_i(ex_rd),

        .mem_read_i(ex_mem_read),
        .mem_write_i(ex_mem_write),
        .reg_write_i(ex_reg_write),
        .wb_sel_i(ex_wb_sel),

        .alu_result_o(mem_alu_result),
        .rs2_data_o(mem_rs2),
        .rd_o(mem_rd),

        .mem_read_o(mem_mem_read),
        .mem_write_o(mem_mem_write),
        .reg_write_o(mem_reg_write),
        .wb_sel_o(mem_wb_sel)
    );

    // ================= MEM =================
    // 👉 NEW WIRES (IMPORTANT FIX)
    logic [31:0] wb_alu_result, wb_mem_data;
    logic [4:0]  wb_rd_mem;
    logic        wb_reg_write_mem, wb_sel_mem;

    tsc_mem_stage MEM (
        .clk(clk),
        .rst(rst),

        .alu_result_i(mem_alu_result),
        .rs2_data_i(mem_rs2),
        .rd_i(mem_rd),

        .mem_read_i(mem_mem_read),
        .mem_write_i(mem_mem_write),
        .reg_write_i(mem_reg_write),
        .wb_sel_i(mem_wb_sel),

        // OUTPUT → NEW WIRES
        .mem_data_o(wb_mem_data),
        .alu_result_o(wb_alu_result),
        .rd_o(wb_rd_mem),

        .reg_write_o(wb_reg_write_mem),
        .wb_sel_o(wb_sel_mem)
    );

    // ================= WB =================
    tsc_wb_stage WB (
        .mem_data_i(wb_mem_data),
        .alu_result_i(wb_alu_result),

        .rd_i(wb_rd_mem),
        .reg_write_i(wb_reg_write_mem),
        .wb_sel_i(wb_sel_mem),

        .wb_data_o(wb_data),
        .wb_rd_o(wb_rd),
        .wb_we_o(wb_we)
    );

endmodule