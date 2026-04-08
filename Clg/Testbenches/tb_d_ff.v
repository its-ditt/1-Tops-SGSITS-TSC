`timescale 1ns / 1ps

module tb_d_ff;
reg clk, d;
wire q;

d_ff uut(clk, d, q);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    d = 0;
    #10 d = 1;
    #10 d = 0;
    #20 $finish;
end
endmodule
