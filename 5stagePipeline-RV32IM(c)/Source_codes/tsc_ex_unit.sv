`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 19-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: Execute Unit (top)                                             //
// Module Name: tsc_ex_unit                                                    //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////

module tsc_ex_unit (

    input logic clk,
    input logic rst,

    // FROM ID/EX
    input logic [31:0] rs1_data_i,
    input logic [31:0] rs2_data_i,
    input logic [31:0] imm_i,
    input logic [31:0] pc_i,

    input logic [4:0] rs1_i,
    input logic [4:0] rs2_i,
    input logic [4:0] rd_i,

    input logic [2:0] funct3_i,

    input logic [3:0] alu_op_i,
    input logic alu_src_i,
    input logic branch_i,
    input logic jump_i,

    input logic mem_read_i,
    input logic mem_write_i,
    input logic reg_write_i,
    input logic wb_sel_i,

    input logic use_muldiv_i,
    input logic [1:0] muldiv_op_i,

    // FORWARDING
    input logic [1:0] forward_a_i,
    input logic [1:0] forward_b_i,
    input logic [31:0] mem_result_i,
    input logic [31:0] wb_data_i,

    // OUTPUT
    output logic [31:0] alu_result_o,
    output logic [31:0] rs2_forward_o,
    output logic [4:0] rd_o,

    output logic mem_read_o,
    output logic mem_write_o,
    output logic reg_write_o,
    output logic wb_sel_o,

    output logic branch_taken_o,
    output logic [31:0] pc_target_o,

    output logic stall_o
);

    // ================= FORWARDING =================
    logic [31:0] opA, opB_raw;

    always_comb begin
        case (forward_a_i)
            2'b00: opA = rs1_data_i;
            2'b01: opA = mem_result_i;
            2'b10: opA = wb_data_i;
            default: opA = rs1_data_i;
        endcase

        case (forward_b_i)
            2'b00: opB_raw = rs2_data_i;
            2'b01: opB_raw = mem_result_i;
            2'b10: opB_raw = wb_data_i;
            default: opB_raw = rs2_data_i;
        endcase
    end

    logic [31:0] opB;
    assign opB = (alu_src_i) ? imm_i : opB_raw;

    // ================= ALU =================
    logic [31:0] alu_result;

    tsc_alu ALU (
        .i_op_A(opA),
        .i_op_B(opB),
        .i_opc(alu_op_i),
        .o_result(alu_result),
        .o_lt(),
        .o_ltu(),
        .o_zero()
    );

    // ================= MUL/DIV =================
    logic [31:0] muldiv_result;
    logic muldiv_busy;

    tsc_mult_div MULDIV (
        .clk(clk),
        .rst(rst),
        .start_i(use_muldiv_i),
        .op_i(muldiv_op_i),
        .a_i(opA),
        .b_i(opB_raw),
        .result_o(muldiv_result),
        .busy_o(muldiv_busy)
    );

    // ================= RESULT SELECT =================
    always_comb begin
        if (use_muldiv_i)
            alu_result_o = muldiv_result;
        else
            alu_result_o = alu_result;
    end

    // ================= STALL =================
    assign stall_o = muldiv_busy;

    // ================= BRANCH =================
    logic eq;
    assign eq = (opA == opB_raw);

    always_comb begin
        branch_taken_o = 0;

        if (branch_i) begin
            case (funct3_i)
                3'b000: branch_taken_o = eq;
                3'b001: branch_taken_o = ~eq;
            endcase
        end

        if (jump_i)
            branch_taken_o = 1;
    end

    assign pc_target_o = pc_i + imm_i;

    // ================= PASS =================
    assign rs2_forward_o = opB_raw;
    assign rd_o = rd_i;

    assign mem_read_o  = mem_read_i;
    assign mem_write_o = mem_write_i;
    assign reg_write_o = reg_write_i;
    assign wb_sel_o    = wb_sel_i;

endmodule