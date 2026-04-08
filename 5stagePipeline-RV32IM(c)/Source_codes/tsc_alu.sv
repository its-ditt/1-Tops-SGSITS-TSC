`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 17-03-2026                                                     //
// Latest revision: 17-03-2026                                                 //
// Design Name: ALU                                                            //
// Module Name: tsc_alu                                                        //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_alu(
    input  logic [31:0] i_op_A, i_op_B,
    input  logic [3:0]  i_opc,
    output logic [31:0] o_result,
    output logic        o_lt, o_ltu, o_zero
);

    logic signed [31:0] A_sign;
    logic signed [31:0] B_sign;

    assign A_sign = i_op_A;
    assign B_sign = i_op_B;

    assign o_lt  = (A_sign < B_sign);
    assign o_ltu = (i_op_A < i_op_B);

    always_comb begin
        case(i_opc)

            4'h0: o_result = i_op_A + i_op_B; // ADD
            4'h1: o_result = i_op_A - i_op_B; // SUB

            4'h2: o_result = i_op_A & i_op_B; // AND
            4'h3: o_result = i_op_A | i_op_B; // OR
            4'h4: o_result = i_op_A ^ i_op_B; // XOR

            4'h5: o_result = i_op_A << i_op_B[4:0]; // SLL
            4'h6: o_result = i_op_A >> i_op_B[4:0]; // SRL
            4'h7: o_result = A_sign >>> i_op_B[4:0]; // SRA

            4'h8: o_result = o_lt  ? 32'd1 : 32'd0; // SLT
            4'h9: o_result = o_ltu ? 32'd1 : 32'd0; // SLTU

            default: o_result = 32'd0;

        endcase
    end

    assign o_zero = (o_result == 32'd0);

endmodule
