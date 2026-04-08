`timescale 1ns/1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 26-03-2026                                                 //
// Design Name: Writeback                                                      //
// Module Name: tsc_wb_stage                                                   //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////

module tsc_wb_stage (

    input logic [31:0] mem_data_i,
    input logic [31:0] alu_result_i,

    input logic [4:0] rd_i,
    input logic reg_write_i,
    input logic wb_sel_i,

    output logic [31:0] wb_data_o,
    output logic [4:0] wb_rd_o,
    output logic wb_we_o
);

    // ================= WRITEBACK MUX =================
    always_comb begin
        if (wb_sel_i)
            wb_data_o = mem_data_i;   // load
        else
            wb_data_o = alu_result_i; // ALU result
    end

    assign wb_rd_o = rd_i;
    assign wb_we_o = reg_write_i;

endmodule