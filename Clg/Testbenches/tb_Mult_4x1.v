`timescale 1ns / 1ps

module tb_mult_4x1;

reg [3:0] d;
reg [1:0] s;
wire y;

mult_4x1 uut (
    .d(d),
    .s(s),
    .y(y)
);

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_mult_4x1);

    d = 4'b1010;

    s = 2'b00; #10;
    s = 2'b01; #10;
    s = 2'b10; #10;
    s = 2'b11; #10;

    d = 4'b1100;

    s = 2'b00; #10;
    s = 2'b01; #10;
    s = 2'b10; #10;
    s = 2'b11; #10;

    $finish;
end

endmodule