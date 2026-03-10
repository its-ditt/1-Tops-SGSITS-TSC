`timescale 1ns / 1ps

module ALU (
    input  logic [31:0] op_a_i,
    input  logic [31:0] op_b_i,
    input  logic [3:0]  alu_op_i,
    output logic [31:0] alu_result_o
);

always_comb begin
    case (alu_op_i)

        4'b0000: alu_result_o = op_a_i + op_b_i;        // ADD
        4'b0001: alu_result_o = op_a_i - op_b_i;        // SUB
        4'b0010: alu_result_o = op_a_i & op_b_i;        // AND
        4'b0011: alu_result_o = op_a_i | op_b_i;        // OR
        4'b0100: alu_result_o = op_a_i ^ op_b_i;        // XOR

        4'b0101: alu_result_o = op_a_i << op_b_i[4:0];  // SLL
        4'b0110: alu_result_o = op_a_i >> op_b_i[4:0];  // SRL
        4'b0111: alu_result_o = $signed(op_a_i) >>> op_b_i[4:0]; // SRA

        4'b1000: alu_result_o = {31'b0, ($signed(op_a_i) < $signed(op_b_i))}; // SLT
        4'b1001: alu_result_o = {31'b0, (op_a_i < op_b_i)};                   // SLTU

        default: alu_result_o = 32'h00000000;

    endcase
end

endmodule