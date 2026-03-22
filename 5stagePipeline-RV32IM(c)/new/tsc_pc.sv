`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 17-03-2026                                                     //
// Design Name: Program Counter                                                //
// Module Name: tsc_pc                                                         //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_pc (
    input  logic        clk,
    input  logic        rst,

    input  logic        pc_src_i,       // 0 = PC+4, 1 = branch/jump
    input  logic [31:0] pc_target_i,    // branch or jump address

    output logic [31:0] pc_o,
    output logic [31:0] pc_plus4_o
);

    logic [31:0] pc_reg;
    logic [31:0] pc_next;

    // PC + 4
    assign pc_plus4_o = pc_reg + 32'd4;

    // Next PC logic
    always_comb begin
        if (pc_src_i)
            pc_next = pc_target_i;
        else
            pc_next = pc_plus4_o;
    end

    // PC register
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 32'h00000000;
        else
            pc_reg <= pc_next;
    end

    assign pc_o = pc_reg;

endmodule
