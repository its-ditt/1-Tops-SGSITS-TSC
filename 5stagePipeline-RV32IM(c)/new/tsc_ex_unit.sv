'timescale 1ns/1ps

/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 19-03-2026                                                     //
// Design Name: Execute unit                                                   //
// Module Name: tsc_ex_unit                                                    //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_ex_unit (

    // Inputs
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] rs2_data_i,
    input  logic [31:0] imm_i,
    input  logic [31:0] pc_i,

    input  logic        alu_src_i,
    input  logic [3:0]  alu_op_i,

    input  logic        branch_i,
    input  logic        jump_i,
    input  logic [2:0]  funct3_i,

    input  logic        use_mul_i,   // NEW

    // Outputs
    output logic [31:0] result_o,
    output logic        branch_taken_o,
    output logic [31:0] pc_target_o

);

    logic [31:0] operand_b;

    // ================= Operand Selection =================
    assign operand_b = (alu_src_i) ? imm_i : rs2_data_i;

    // ================= ALU =================
    logic [31:0] alu_result;

    tsc_alu ALU (
        .i_op_A(rs1_data_i),
        .i_op_B(operand_b),
        .i_opc(alu_op_i),
        .o_result(alu_result),
        .o_lt(),
        .o_ltu(),
        .o_zero()
    );

    // ================= MULTIPLIER =================
    logic [63:0] mul_result;

    multiplier_32x32 MUL (
        .A(rs1_data_i),
        .B(rs2_data_i),
        .P(mul_result)
    );

    // ================= RESULT MUX =================
    always_comb begin
        if (use_mul_i)
            result_o = mul_result[31:0]; // lower 32 bits
        else
            result_o = alu_result;
    end

    // ================= Branch Logic =================
    logic eq;

    assign eq = (rs1_data_i == rs2_data_i);

    always_comb begin
        branch_taken_o = 0;

        if (branch_i) begin
            case (funct3_i)
                3'b000: branch_taken_o = eq;  // BEQ
                3'b001: branch_taken_o = ~eq; // BNE
                3'b100: branch_taken_o = (rs1_data_i < rs2_data_i);
                3'b101: branch_taken_o = (rs1_data_i >= rs2_data_i);
            endcase
        end

        if (jump_i)
            branch_taken_o = 1;
    end

    // ================= PC Target =================
    assign pc_target_o = pc_i + imm_i;

endmodule
