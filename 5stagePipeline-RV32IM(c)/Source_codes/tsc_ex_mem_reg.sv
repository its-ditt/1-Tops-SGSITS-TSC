`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 23-03-2026                                                 //
// Design Name: EX/MEM Reg                                                     //
// Module Name: tsc_ex_mem_reg                                                 //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_ex_mem_reg (

    input logic clk,
    input logic rst,

    // DATA
    input logic [31:0] alu_result_i,
    input logic [31:0] rs2_data_i,

    input logic [4:0] rd_i,

    // CONTROL
    input logic mem_read_i,
    input logic mem_write_i,
    input logic reg_write_i,
    input logic wb_sel_i,

    // OUTPUT
    output logic [31:0] alu_result_o,
    output logic [31:0] rs2_data_o,
    output logic [4:0] rd_o,

    output logic mem_read_o,
    output logic mem_write_o,
    output logic reg_write_o,
    output logic wb_sel_o
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_result_o <= 0;
            rs2_data_o   <= 0;
            rd_o         <= 0;

            mem_read_o   <= 0;
            mem_write_o  <= 0;
            reg_write_o  <= 0;
            wb_sel_o     <= 0;
        end
        else begin
            alu_result_o <= alu_result_i;
            rs2_data_o   <= rs2_data_i;
            rd_o         <= rd_i;

            mem_read_o   <= mem_read_i;
            mem_write_o  <= mem_write_i;
            reg_write_o  <= reg_write_i;
            wb_sel_o     <= wb_sel_i;
        end
    end

endmodule
