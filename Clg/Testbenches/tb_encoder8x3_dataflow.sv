`timescale 1ns / 1ps

module tb_encoder8x3;

reg  [7:0] I;
wire [2:0] Y;

encoder8x3_dataflow uut (
    .I(I),
    .Y(Y)
);

integer i;
reg [2:0] exp;

initial begin
    for (i = 0; i < 256; i = i + 1) begin
        I = i; #5;

        exp[2] = I[4] | I[5] | I[6] | I[7];
        exp[1] = I[2] | I[3] | I[6] | I[7];
        exp[0] = I[1] | I[3] | I[5] | I[7];

        if (Y !== exp)
            $display("FAIL I=%b exp=%b got=%b", I, exp, Y);
        else
            $display("PASS I=%b Y=%b", I, Y);
    end

    $finish;
end

endmodule
