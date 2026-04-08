`timescale 1ns / 1ps

module tb_btg_gtb;

parameter N = 8;

reg en, mode;
reg [N-1:0] x;
wire [N-1:0] y;

btg_gtb #(N) uut (
    .en(en),
    .mode(mode),
    .x(x),
    .y(y)
);

integer i;
reg [N-1:0] exp, temp;

// test en = 0
initial begin
    en = 0; mode = 0;

    for (i = 0; i < 5; i = i + 1) begin
        x = i; #5;
        if (y !== 0)
            $display("FAIL en=0 x=%b y=%b", x, y);
        else
            $display("PASS en=0 x=%b y=%b", x, y);
    end
end

// main test
initial begin
    #30;
    en = 1;

    for (i = 0; i < 16; i = i + 1) begin
        x = i;

        // mode = 0 (binary → gray)
        mode = 0; #5;
        exp = x ^ (x >> 1);

        if (y !== exp)
            $display("FAIL B2G x=%b exp=%b got=%b", x, exp, y);
        else
            $display("PASS B2G x=%b y=%b", x, y);

        // mode = 1 (gray → binary)
        mode = 1; #5;

        temp[N-1] = x[N-1];
        for (integer j = N-2; j >= 0; j = j - 1)
            temp[j] = temp[j+1] ^ x[j];

        exp = temp;

        if (y !== exp)
            $display("FAIL G2B x=%b exp=%b got=%b", x, exp, y);
        else
            $display("PASS G2B x=%b y=%b", x, y);
    end

    $finish;
end

endmodule
