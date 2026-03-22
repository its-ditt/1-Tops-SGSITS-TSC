`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 18-03-2026                                                     //
// Design Name: Register File                                                //
// Module Name: tsc_regfile                                                    //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_regfile (

    input  logic        clk,
    input  logic        rst,

    input  logic [4:0]  rs1_i,
    input  logic [4:0]  rs2_i,
    input  logic [4:0]  rd_i,

    input  logic [31:0] wd_i,
    input  logic        we_i,

    output logic [31:0] rd1_o,
    output logic [31:0] rd2_o

);

    // 32 registers of 32 bits
    logic [31:0] regfile [31:0];

    // ================= WRITE LOGIC =================
    always_ff @(posedge clk) begin
        if (we_i && (rd_i != 5'd0))
            regfile[rd_i] <= wd_i;
    end

    // ================= READ LOGIC =================
    assign rd1_o = (rs1_i == 5'd0) ? 32'd0 : regfile[rs1_i];
    assign rd2_o = (rs2_i == 5'd0) ? 32'd0 : regfile[rs2_i];

endmodule
