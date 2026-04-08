`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: ID/EX Reg                                                      //
// Module Name: tsc_id_ex_reg                                                  //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////
module tsc_id_ex_reg (

    input  logic        clk,
    input  logic        rst,
    input  logic        flush_i,

    // DATA
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] rs2_data_i,
    input  logic [31:0] imm_i,
    input  logic [31:0] pc_i,

    input  logic [4:0]  rs1_i,
    input  logic [4:0]  rs2_i,
    input  logic [4:0]  rd_i,

    input  logic [2:0]  funct3_i,

    // CONTROL
    input  logic [3:0]  alu_op_i,
    input  logic        alu_src_i,
    input  logic        branch_i,
    input  logic        jump_i,

    input  logic        mem_read_i,
    input  logic        mem_write_i,
    input  logic        reg_write_i,
    input  logic        wb_sel_i,

    input  logic        use_muldiv_i,
    input  logic [1:0]  muldiv_op_i,

    // OUTPUTS
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o,
    output logic [31:0] imm_o,
    output logic [31:0] pc_o,

    output logic [4:0]  rs1_o,
    output logic [4:0]  rs2_o,
    output logic [4:0]  rd_o,

    output logic [2:0]  funct3_o,

    output logic [3:0]  alu_op_o,
    output logic        alu_src_o,
    output logic        branch_o,
    output logic        jump_o,

    output logic        mem_read_o,
    output logic        mem_write_o,
    output logic        reg_write_o,
    output logic        wb_sel_o,

    output logic        use_muldiv_o,
    output logic [1:0]  muldiv_op_o
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst || flush_i) begin
            rs1_data_o <= 0;
            rs2_data_o <= 0;
            imm_o      <= 0;
            pc_o       <= 0;

            rs1_o <= 0;
            rs2_o <= 0;
            rd_o  <= 0;

            funct3_o <= 0;

            alu_op_o   <= 0;
            alu_src_o  <= 0;
            branch_o   <= 0;
            jump_o     <= 0;

            mem_read_o  <= 0;
            mem_write_o <= 0;
            reg_write_o <= 0;
            wb_sel_o    <= 0;

            use_muldiv_o <= 0;
            muldiv_op_o  <= 0;
        end
        else begin
            rs1_data_o <= rs1_data_i;
            rs2_data_o <= rs2_data_i;
            imm_o      <= imm_i;
            pc_o       <= pc_i;

            rs1_o <= rs1_i;
            rs2_o <= rs2_i;
            rd_o  <= rd_i;

            funct3_o <= funct3_i;

            alu_op_o   <= alu_op_i;
            alu_src_o  <= alu_src_i;
            branch_o   <= branch_i;
            jump_o     <= jump_i;

            mem_read_o  <= mem_read_i;
            mem_write_o <= mem_write_i;
            reg_write_o <= reg_write_i;
            wb_sel_o    <= wb_sel_i;

            use_muldiv_o <= use_muldiv_i;
            muldiv_op_o  <= muldiv_op_i;
        end
    end

endmodule
