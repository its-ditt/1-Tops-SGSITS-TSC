`timescale 1ns/1ps

module tb_jk_ff;
reg clk, j, k;
wire q;

jk_ff uut(clk, j, k, q);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    j=0; k=0;
    #10 j=1; k=0;
    #10 j=0; k=1;
    #10 j=1; k=1;
    #20 $finish;
end
endmodule