`timescale 1ns / 1ps

module Ripple_CA_tb;

    logic [7:0] A,B;
    logic [15:0] Sum;

    logic [15:0] exp;

    Ripple_CA dut(A,B,Sum);

    int unsigned i;
    int pass_cnt = 0, fail_cnt = 0;

    initial begin
        $display("Starting Self-Checking TB...\n");

        for (i = 0; i < 64; i++) begin
            A   = $urandom_range(0, 255);
            B   = $urandom_range(0, 255);

            #2;

            exp = A + B;

            if (Sum !== exp) begin
                $error("Mismatch: A=%0d B=%0d | DUT=%0d expected=%0d",
                        A, B, Sum, exp);
                fail_cnt++;
            end else
                pass_cnt++;
        end

        $display("\nPASSED=%0d FAILED=%0d", pass_cnt, fail_cnt);
        $finish;
    end

    initial begin
        $monitor("t=%0t | A=%b B=%b  | Sum=%b",
                  $time, A, B, Sum);
    end

endmodule
