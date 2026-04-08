`timescale 1ns / 1ps

module tb_bcd_ex3;

reg  [3:0] bcd;
wire [3:0] ex3;

bcd_ex3 uut (
    .bcd(bcd),
    .ex3(ex3)
);

integer i;
integer pass = 0, fail = 0;
reg [3:0] exp;

initial begin
    for (i = 0; i < 16; i = i + 1) begin
        bcd = i; #5;

        if (bcd <= 9)
            exp = bcd + 4'd3;
        else
            exp = 4'bxxxx;

        if ((bcd <= 9 && ex3 !== exp) || 
            (bcd > 9 && ex3 !== 4'bxxxx)) begin
            $display("FAIL bcd=%0d exp=%b got=%b", bcd, exp, ex3);
            fail = fail + 1;
        end else begin
            pass = pass + 1;
        end
    end

    $display("\nSUMMARY: PASS=%0d FAIL=%0d", pass, fail);

    if (fail == 0)
        $display("ALL TESTS for BCD to Ex3 converter PASSED ✅");
    else
        $display("SOME TESTS FAILED ❌");

    $finish;
end

endmodule
