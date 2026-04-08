`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 26-03-2026                                                 //
// Design Name: Memory tage (top)                                              //
// Module Name: tsc_mem_stage                                                  //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////

module tsc_mem_stage (

    input logic clk,
    input logic rst,

    input logic [31:0] alu_result_i,
    input logic [31:0] rs2_data_i,
    input logic [4:0] rd_i,

    input logic mem_read_i,
    input logic mem_write_i,
    input logic reg_write_i,
    input logic wb_sel_i,

    output logic [31:0] mem_data_o,
    output logic [31:0] alu_result_o,
    output logic [4:0] rd_o,

    output logic reg_write_o,
    output logic wb_sel_o

);

    // ================= DMEM =================
    tsc_dmem DMEM (
        .clk(clk),
        .addr_i(alu_result_i),
        .wdata_i(rs2_data_i),
        .mem_read_i(mem_read_i),
        .mem_write_i(mem_write_i),
        .rdata_o(mem_data_o)
    );

    // ================= PASS THROUGH =================
    assign alu_result_o = alu_result_i;
    assign rd_o         = rd_i;

    assign reg_write_o  = reg_write_i;   // IMPORTANT
    assign wb_sel_o     = wb_sel_i;

endmodule
