`timescale 1ns / 1ps

module csr_mtvec(

input logic clk,
input logic rst,

input logic write_en,

input logic [1:0] csr_op,
input logic [31:0] wdata,

output logic [31:0] rdata

);

csr_gen  REG(

    .clk(clk),
    .rst(rst),

    .write_en(write_en),

    .csr_op(csr_op),
    .wdata(wdata),

    .rdata(rdata)

);

endmodule
