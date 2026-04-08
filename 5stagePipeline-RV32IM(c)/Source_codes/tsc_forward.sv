`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: Forward Unit                                                   //
// Module Name: tsc_forward                                                    //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_forward(

    input logic [4:0] ex_rs1_i,
    input logic [4:0] ex_rs2_i,

    input logic [4:0] mem_rd_i,
    input logic       mem_reg_write_i,

    input logic [4:0] wb_rd_i,
    input logic       wb_reg_write_i,

    output logic [1:0] forward_a_o,
    output logic [1:0] forward_b_o

);

    always_comb begin
        forward_a_o = 2'b00;
        forward_b_o = 2'b00;

        // MEM stage forwarding
        if (mem_reg_write_i && mem_rd_i != 0 && mem_rd_i == ex_rs1_i)
            forward_a_o = 2'b01;

        if (mem_reg_write_i && mem_rd_i != 0 && mem_rd_i == ex_rs2_i)
            forward_b_o = 2'b01;

        // WB stage forwarding
        if (wb_reg_write_i && wb_rd_i != 0 && wb_rd_i == ex_rs1_i)
            forward_a_o = 2'b10;

        if (wb_reg_write_i && wb_rd_i != 0 && wb_rd_i == ex_rs2_i)
            forward_b_o = 2'b10;
    end

endmodule
