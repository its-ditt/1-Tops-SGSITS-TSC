`timescale 1ns / 1ps

module tb_t_ff;
reg clk, t;
wire q;

t_ff uut(clk, t, q);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    t=1;
    #40 $finish;
end
endmodule
