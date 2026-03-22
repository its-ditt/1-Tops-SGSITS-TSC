`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2026 17:50:41
// Design Name: 
// Module Name: tsc_ctrl_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tsc_ctrl_unit (

    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic       alu_src_o,
    output logic [3:0] alu_op_o,

    output logic       mem_read_o,
    output logic       mem_write_o,

    output logic       reg_write_o,
    output logic       wb_sel_o,

    output logic       branch_o,
    output logic       jump_o

);

always_comb begin

    // DEFAULT VALUES (VERY IMPORTANT)
    alu_src_o   = 0;
    alu_op_o    = 4'd0;

    mem_read_o  = 0;
    mem_write_o = 0;

    reg_write_o = 0;
    wb_sel_o    = 0;

    branch_o    = 0;
    jump_o      = 0;

    case(opcode)

        // ================= R-TYPE =================
        7'b0110011: begin
            reg_write_o = 1;

            case({funct7, funct3})
                10'b0000000_000: alu_op_o = 4'h0; // ADD
                10'b0100000_000: alu_op_o = 4'h1; // SUB
                10'b0000000_111: alu_op_o = 4'h2; // AND
                10'b0000000_110: alu_op_o = 4'h3; // OR
                10'b0000000_100: alu_op_o = 4'h4; // XOR
                10'b0000000_001: alu_op_o = 4'h5; // SLL
                10'b0000000_101: alu_op_o = 4'h6; // SRL
                10'b0100000_101: alu_op_o = 4'h7; // SRA
                10'b0000000_010: alu_op_o = 4'h8; // SLT
                10'b0000000_011: alu_op_o = 4'h9; // SLTU
            endcase
        end

        // ================= I-TYPE =================
        7'b0010011: begin
            alu_src_o   = 1;
            reg_write_o = 1;

            case(funct3)
                3'b000: alu_op_o = 4'h0; // ADDI
                3'b111: alu_op_o = 4'h2; // ANDI
                3'b110: alu_op_o = 4'h3; // ORI
                3'b100: alu_op_o = 4'h4; // XORI
            endcase
        end

        // ================= LOAD =================
        7'b0000011: begin
            alu_src_o   = 1;
            mem_read_o  = 1;
            reg_write_o = 1;
            wb_sel_o    = 1;   // from memory
            alu_op_o    = 4'h0; // ADD for address
        end

        // ================= STORE =================
        7'b0100011: begin
            alu_src_o    = 1;
            mem_write_o  = 1;
            alu_op_o     = 4'h0;
        end

        // ================= BRANCH =================
        7'b1100011: begin
            branch_o = 1;
            alu_op_o = 4'h1; // SUB for comparison
        end

        // ================= JAL =================
        7'b1101111: begin
            jump_o      = 1;
            reg_write_o = 1;
        end

        // ================= LUI =================
        7'b0110111: begin
            reg_write_o = 1;
        end

    endcase

end

endmodule
