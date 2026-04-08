`timescale 1ns / 1ps

module tb_4x2_parity_encoder;

logic  [3:0] d;
logic [1:0] y;

_4x2_parity_encoder uut (
    .d(d),
    .y(y)
);

integer i;
logic [1:0] exp;

initial begin
    for (i = 0; i < 16; i = i + 1) begin
        d = i; #5;

        exp[1] = d[2] ^ d[3];
        exp[0] = d[1] ^ d[3];

        if (y !== exp)
            $display("FAIL d=%b exp=%b got=%b", d, exp, y);
        else
            $display("PASS d=%b y=%b", d, y);
    end

    $finish;
end

endmodule
