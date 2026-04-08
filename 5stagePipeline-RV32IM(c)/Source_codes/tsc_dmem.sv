`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 20-03-2026                                                     //
// Latest revision: 26-03-2026                                                 //
// Design Name: Data Memory                                                    //
// Module Name: tsc_dmem                                                       //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_dmem #(
    parameter N = 64
)(
    input logic clk,

    input logic [31:0] addr_i,
    input logic [31:0] wdata_i,

    input logic mem_read_i,
    input logic mem_write_i,

    output logic [31:0] rdata_o
);

    logic [31:0] mem [0:N-1];

    integer i;
    initial begin
        for (i = 0; i < N; i = i + 1)
            mem[i] = 32'd0;
    end

    logic [5:0] addr_index;
    assign addr_index = addr_i[7:2];

    always_ff @(posedge clk) begin
        if (mem_write_i)
            mem[addr_index] <= wdata_i;
    end

    always_comb begin
        if (mem_read_i)
            rdata_o = mem[addr_index];
        else
            rdata_o = 32'd0;
    end

endmodule