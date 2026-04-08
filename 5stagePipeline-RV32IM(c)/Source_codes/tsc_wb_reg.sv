`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 23-03-2026                                                 //
// Design Name: MEM/WB Reg                                                     //
// Module Name: tsc_wb    _reg                                                 //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////

module tsc_wb_reg (

    input logic clk,
    input logic rst,

    // INPUT
    input logic [31:0] mem_data_i,
    input logic [31:0] alu_result_i,
    input logic [4:0]  rd_i,

    input logic reg_write_i,
    input logic wb_sel_i,

    // OUTPUT
    output logic [31:0] mem_data_o,
    output logic [31:0] alu_result_o,
    output logic [4:0]  rd_o,

    output logic reg_write_o,
    output logic wb_sel_o
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_data_o   <= 0;
            alu_result_o <= 0;
            rd_o         <= 0;
            reg_write_o  <= 0;
            wb_sel_o     <= 0;
        end
        else begin
            mem_data_o   <= mem_data_i;
            alu_result_o <= alu_result_i;
            rd_o         <= rd_i;
            reg_write_o  <= reg_write_i;
            wb_sel_o     <= wb_sel_i;
        end
    end

endmodule
