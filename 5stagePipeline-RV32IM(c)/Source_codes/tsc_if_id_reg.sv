`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 24-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: IF/ID Reg                                                      //
// Module Name: tsc_if_id_reg                                                  //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_if_id_reg (

    input  logic        clk,
    input  logic        rst,

    input  logic        en_i,      // stall
    input  logic        flush_i,   // branch flush

    input  logic [31:0] instr_i,
    input  logic [31:0] pc_i,
    input  logic [31:0] pc4_i,

    output logic [31:0] instr_o,
    output logic [31:0] pc_o,
    output logic [31:0] pc4_o

);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            instr_o <= 32'h00000013; // NOP
            pc_o    <= 0;
            pc4_o   <= 0;
        end
        else if (flush_i) begin
            instr_o <= 32'h00000013; // insert NOP
            pc_o    <= 0;
            pc4_o   <= 0;
        end
        else if (en_i) begin
            instr_o <= instr_i;
            pc_o    <= pc_i;
            pc4_o   <= pc4_i;
        end
    end

endmodule
