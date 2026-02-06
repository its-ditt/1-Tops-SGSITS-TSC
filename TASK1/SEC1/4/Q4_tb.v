`timescale 1ns / 1ps

module barrel_shifter_tb;

parameter N = 32;

reg  [N-1:0] a;
reg  [$clog2(N)-1:0] shamt;
reg  [1:0] mode;
wire [N-1:0] y;

barrel_shifter #(N) dut(a,shamt,mode,y);

initial begin
    a=32'h12345678; shamt=0; mode=0;
    #5 shamt=4;
    #5 shamt=8;

    #5 mode=1; shamt=4;
    #5 shamt=12;

    #5 mode=2; a=32'hF2345678; shamt=1;
    #5 shamt=4;

    #5 mode=0; a=32'h00000001; shamt=31;

    #10 $finish;
end

initial begin
    $monitor("t=%0t a=%h shamt=%0d mode=%b y=%h",$time,a,shamt,mode,y);
end

endmodule

