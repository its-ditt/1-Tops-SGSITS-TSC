`timescale 1ns / 1ps

module tb_mod16_counter;
reg clk;
wire [3:0] count;

mod16_counter uut(clk, count);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    #160 $finish;
end
endmodule
