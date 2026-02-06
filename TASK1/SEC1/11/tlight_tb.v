`timescale 1ns / 1ps
module tb_tlight;

reg clk;
reg rst;
reg ped;
wire r,y,g;

tlight dut(
    .clk(clk),
    .rst(rst),
    .ped(ped),
    .r(r),
    .y(y),
    .g(g)
);

initial begin
    clk=0;
    forever #1 clk=~clk;
end

initial begin
    rst=1; ped=0;
    #5 rst=0;

    #10 ped=1;
    #2 ped=0;

    #40;

    #6 ped=1;
    #2 ped=0;

    #200 $finish;
end

endmodule

