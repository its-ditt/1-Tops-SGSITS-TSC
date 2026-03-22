`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 17-03-2026                                                     //
// Design Name: Koggstone-Semiproduct Mult.                                    //
// Module Name: multiplier                                                     //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module multiplier_32x32 (

    input  logic [31:0] A,
    input  logic [31:0] B,
    output logic [63:0] P

);

    logic [63:0] partial [31:0];
    logic [63:0] sum_stage [31:0];

    genvar i, j;

    // ================= PARTIAL PRODUCT GENERATION =================
    generate
        for (i = 0; i < 32; i++) begin : PARTIAL_GEN
            for (j = 0; j < 32; j++) begin : BIT_GEN
                assign partial[i][j+i] = A[j] & B[i];
            end

            // fill lower bits with 0
            for (j = 0; j < i; j++) begin
                assign partial[i][j] = 1'b0;
            end

            // fill upper bits with 0
            for (j = 32+i; j < 64; j++) begin
                assign partial[i][j] = 1'b0;
            end
        end
    endgenerate

    // ================= ADDITION TREE =================
    assign sum_stage[0] = partial[0];

    generate
        for (i = 1; i < 32; i++) begin : ADD_STAGE

            adder_32 ADD_LOW (
                .a(sum_stage[i-1][31:0]),
                .b(partial[i][31:0]),
                .sum(sum_stage[i][31:0])
            );

            adder_32 ADD_HIGH (
                .a(sum_stage[i-1][63:32]),
                .b(partial[i][63:32]),
                .sum(sum_stage[i][63:32])
            );

        end
    endgenerate

    assign P = sum_stage[31];

endmodule
