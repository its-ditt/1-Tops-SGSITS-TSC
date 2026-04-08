`timescale 1ns / 1ps

module tb_johnson_8b;

reg clk, rst;
wire [7:0] q;

johnson_8b uut (
    .clk(clk),
    .rst(rst),
    .q(q)
);

// clock
initial clk = 0;
always #5 clk = ~clk;

// expected (aligned with first observed value after reset)
reg [7:0] exp [0:15];
integer i;

initial begin
    exp[0]=8'b10000000; exp[1]=8'b11000000;
    exp[2]=8'b11100000; exp[3]=8'b11110000;
    exp[4]=8'b11111000; exp[5]=8'b11111100;
    exp[6]=8'b11111110; exp[7]=8'b11111111;
    exp[8]=8'b01111111; exp[9]=8'b00111111;
    exp[10]=8'b00011111; exp[11]=8'b00001111;
    exp[12]=8'b00000111; exp[13]=8'b00000011;
    exp[14]=8'b00000001; exp[15]=8'b00000000;
end

initial begin
    rst = 1; #12; rst = 0;

    for (i=0; i<16; i=i+1) begin
        @(posedge clk); #1;
        if (q !== exp[i])
            $display("FAIL t=%0t exp=%b got=%b", $time, exp[i], q);
        else
            $display("PASS t=%0t val=%b", $time, q);
    end

    $finish;
end

endmodule