`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 17-03-2026                                                     //
// Latest revision: 17-03-2026                                                 //
// Design Name: Register File                                                  //
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

    logic [31:0] regfile [0:31];
    integer i;

    // ================= WRITE + RESET =================
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 32'd0;
        end
        else if (we_i && (rd_i != 0)) begin
            regfile[rd_i] <= wd_i;
        end
    end

    // ================= READ =================
    assign rd1_o = (rs1_i == 0) ? 32'd0 : regfile[rs1_i];
    assign rd2_o = (rs2_i == 0) ? 32'd0 : regfile[rs2_i];

endmodule