`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 17-03-2026                                                     //
// Design Name: Control Unit                                                   //
// Module Name: tsc_ctrl_unit                                                  //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_ctrl_unit (

    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    // ALU
    output logic [3:0] alu_op_o,
    output logic       alu_src_o,

    // CONTROL FLOW
    output logic       branch_o,
    output logic       jump_o,

    // MEMORY
    output logic       mem_read_o,
    output logic       mem_write_o,

    // WRITEBACK
    output logic       reg_write_o,
    output logic       wb_sel_o,   // 0: ALU, 1: MEM

    // MUL/DIV
    output logic       use_muldiv_o,
    output logic [1:0] muldiv_op_o

);

    // =====================================================
    // DEFAULTS (VERY IMPORTANT)
    // =====================================================
    always_comb begin

        // defaults
        alu_op_o      = 4'd0;
        alu_src_o     = 0;

        branch_o      = 0;
        jump_o        = 0;

        mem_read_o    = 0;
        mem_write_o   = 0;

        reg_write_o   = 0;
        wb_sel_o      = 0;

        use_muldiv_o  = 0;
        muldiv_op_o   = 2'b00;

        // =================================================
        // OPCODE DECODE
        // =================================================
        case (opcode)

        // ================= R-TYPE =================
        7'b0110011: begin
            reg_write_o = 1;
            alu_src_o   = 0;

            // ===== M EXTENSION =====
            if (funct7 == 7'b0000001) begin
                use_muldiv_o = 1;

                case (funct3)
                    3'b000: muldiv_op_o = 2'b00; // MUL
                    3'b100: muldiv_op_o = 2'b01; // DIV
                    3'b110: muldiv_op_o = 2'b10; // REM
                    default: muldiv_op_o = 2'b00;
                endcase
            end
            else begin
                // ===== NORMAL ALU =====
                case ({funct7, funct3})
                    {7'b0000000,3'b000}: alu_op_o = 4'd0; // ADD
                    {7'b0100000,3'b000}: alu_op_o = 4'd1; // SUB
                    {7'b0000000,3'b111}: alu_op_o = 4'd2; // AND
                    {7'b0000000,3'b110}: alu_op_o = 4'd3; // OR
                    {7'b0000000,3'b100}: alu_op_o = 4'd4; // XOR
                    {7'b0000000,3'b001}: alu_op_o = 4'd5; // SLL
                    {7'b0000000,3'b101}: alu_op_o = 4'd6; // SRL
                    {7'b0100000,3'b101}: alu_op_o = 4'd7; // SRA
                    {7'b0000000,3'b010}: alu_op_o = 4'd8; // SLT
                    default: alu_op_o = 4'd0;
                endcase
            end
        end

        // ================= I-TYPE ALU =================
        7'b0010011: begin
            reg_write_o = 1;
            alu_src_o   = 1;

            case (funct3)
                3'b000: alu_op_o = 4'd0; // ADDI
                3'b111: alu_op_o = 4'd2; // ANDI
                3'b110: alu_op_o = 4'd3; // ORI
                3'b100: alu_op_o = 4'd4; // XORI
                default: alu_op_o = 4'd0;
            endcase
        end

        // ================= LOAD =================
        7'b0000011: begin
            reg_write_o = 1;
            mem_read_o  = 1;
            alu_src_o   = 1;
            wb_sel_o    = 1; // from memory
            alu_op_o    = 4'd0; // ADD for address
        end

        // ================= STORE =================
        7'b0100011: begin
            mem_write_o = 1;
            alu_src_o   = 1;
            alu_op_o    = 4'd0; // ADD for address
        end

        // ================= BRANCH =================
        7'b1100011: begin
            branch_o = 1;
            alu_op_o = 4'd1; // SUB for comparison
        end

        // ================= JUMP =================
        7'b1101111: begin
            jump_o      = 1;
            reg_write_o = 1;
        end

        // ================= JALR =================
        7'b1100111: begin
            jump_o      = 1;
            reg_write_o = 1;
            alu_src_o   = 1;
        end

        endcase
    end

endmodule
