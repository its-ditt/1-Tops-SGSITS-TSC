`timescale 1ns / 1ps
module csr_mepc(

input clk,rst,

input logic write_en, trap_i,
input logic [31:0] trap_pc_i,

input logic [1:0] csr_op,
input logic [31:0] wdata,

output logic [31:0] rdata

);

always_ff @(posedge clk or negedge rst)
begin

    if(rst)
        rdata <= 32'd0;
    else if(trap_i)
        rdata <= trap_pc_i;
    else if(write_en)
    begin
        case(csr_op)
            2'b00: rdata <= wdata;
            2'b01: rdata <= rdata | wdata;
            2'b10: rdata <= rdata & ~wdata;
            default: rdata <= rdata;
        endcase
    end
end

endmodule
