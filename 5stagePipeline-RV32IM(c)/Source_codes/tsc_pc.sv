`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 17-03-2026                                                     //
// Latest revision: 25-03-2026                                                 //
// Design Name: Program Counter                                                //
// Module Name: tsc_pc                                                         //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_pc (

    input  logic        clk,
    input  logic        rst,
    input  logic        en_i,          // stall control
    input  logic        pc_src_i,      // branch select
    input  logic [31:0] pc_target_i,

    output logic [31:0] pc_o,
    output logic [31:0] pc_plus4_o

);

    logic [31:0] pc_reg, pc_next;

    assign pc_plus4_o = pc_reg + 32'd4;

    always_comb begin
        if (pc_src_i)
            pc_next = pc_target_i;
        else
            pc_next = pc_plus4_o;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 32'd0;
        else if (en_i)
            pc_reg <= pc_next;
    end

    assign pc_o = pc_reg;

endmodule