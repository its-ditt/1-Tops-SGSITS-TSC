`timescale 1ns / 1ps

module t_ff(
    input clk, t,
    output reg q
);
always @(posedge clk)
    if(t) q <= ~q;
endmodule
