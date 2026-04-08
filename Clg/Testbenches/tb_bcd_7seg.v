`timescale 1ns / 1ps

module tb_bcd_7seg;

reg  [3:0] bcd;
wire [6:0] seg;

bcd_7seg uut (
    .bcd(bcd),
    .seg(seg)
);

integer i;
integer pass = 0, fail = 0;
reg [6:0] exp;

initial begin
    for (i = 0; i < 16; i = i + 1) begin
        bcd = i; #5;

        case(bcd)
            0: exp=7'b1000000;
            1: exp=7'b1111001;
            2: exp=7'b0100100;
            3: exp=7'b0110000;
            4: exp=7'b0011001;
            5: exp=7'b0010010;
            6: exp=7'b0000010;
            7: exp=7'b1111000;
            8: exp=7'b0000000;
            9: exp=7'b0010000;
            default: exp=7'b1111111;
        endcase

        if (seg !== exp) begin
            $display("FAIL bcd=%0d exp=%b got=%b", bcd, exp, seg);
            fail = fail + 1;
        end else begin
            pass = pass + 1;
        end
    end

    $display("\nSUMMARY: PASS=%0d FAIL=%0d", pass, fail);

    if (fail == 0)
        $display("ALL TESTS PASSED ✅");
    else
        $display("SOME TESTS FAILED ❌");

    $finish;
end

endmodule