`timescale 1ns/1ps
module tb_full_adder;

    logic a, b, cin;
    logic s, cout;

    // expected value must be declared here (module scope)
    logic [1:0] exp;

    Full_Adder dut(a, b, cin, s, cout);

    int unsigned i;
    int pass_cnt = 0, fail_cnt = 0;

    initial begin
        $display("Starting Self-Checking TB...\n");

        for (i = 0; i < 16; i++) begin
            a   = $urandom_range(0, 1);
            b   = $urandom_range(0, 1);
            cin = $urandom_range(0, 1);

            #2;

            exp = a + b + cin;  // now legal

            if ({cout, s} !== exp) begin
                $error("Mismatch: a=%0d b=%0d cin=%0d | DUT=%0d expected=%0d",
                        a, b, cin, {cout, s}, exp);
                fail_cnt++;
            end else
                pass_cnt++;
        end

        $display("\nPASSED=%0d FAILED=%0d", pass_cnt, fail_cnt);
        $finish;
    end

    initial begin
        $monitor("t=%0t | a=%b b=%b cin=%b | s=%b cout=%b",
                  $time, a, b, cin, s, cout);
    end

endmodule
