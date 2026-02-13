`timescale 1ns / 1ps

module gtbtg_tb_Sysver;

parameter N = 8;

reg en;
reg mode;
reg [N-1:0] x;
wire [N-1:0] y;

integer i;
integer errors = 0;

gtbtg #(N) dut(en, mode, x, y);

function automatic [N-1:0] gtb(input [N-1:0] a);
    integer j;
    begin
        gtb[N-1] = a[N-1];
        for (j = N-2; j >= 0; j = j - 1)
            gtb[j] = gtb[j+1] ^ a[j];
    end
endfunction

task automatic check(input en, input mode, input [N-1:0] a);
    reg [N-1:0] expected;

    if (en&~mode)
        expected = {a[N-1], a[N-1]^a[N-2], a[N-2]^a[N-3],
                    a[N-3]^a[N-4], a[N-4]^a[N-5],
                    a[N-5]^a[N-6], a[N-6]^a[N-7],
                    a[1]^a[0]};
    else if (en&mode)
        expected = gtb(a);
    else
        expected = 0;

    #1;

    if (y !== expected) begin
        $display("ERROR @ %0t: x=%0b | DUT=%0b | REF=%0b",
                 $time, a, y, expected);
        errors = errors + 1;
    end
endtask

initial begin

    for (i = 0; i < (1<<N); i = i + 1) begin
        
        x = i;

        en = 1; mode = 1;
        #5;
        check(en, mode, x);

        en = 1; mode = 0;
        #5;
        check(en, mode, x);

        en = 0;
        #5;
        check(en, mode, x);
    end

    if (errors == 0)
        $display("TEST PASSED");
    else
        $display("TEST FAILED | Total Errors = %0d", errors);

    $finish;
end

endmodule
