`timescale 1ns / 1ps


module csr_mstatus(

input logic clk,rst,

input logic write_en,

input logic [1:0] csr_op,
input logic [31:0] wdata,

output logic [31:0] rdata

);

csr_gen #(32'd0) REG(

    .clk(clk),
    .rst(rst),

    .write_en(write_en),

    .csr_op(csr_op),
    .wdata(wdata),

    .rdata(rdata)

);

endmodule
