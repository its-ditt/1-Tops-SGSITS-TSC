`timescale 1ns / 1ps


module tb_cmp8sysver;

  logic [7:0] a, b;
  logic eq, gt, lt;

  cmp8 DUT (
    .a(a),
    .b(b),
    .eq(eq),
    .gt(gt),
    .lt(lt)
  );

  integer i, errors = 0;

  task check(input [7:0] aa, input [7:0] bb);
    logic geq, ggt, glt;

    geq = (aa == bb);
    ggt = (aa >  bb);
    glt = (aa <  bb);

    if (eq !== geq || gt !== ggt || lt !== glt) begin
      $display("ERROR @ %0t: a=%0d b=%0d | DUT: eq=%0b gt=%0b lt=%0b | REF: eq=%0b gt=%0b lt=%0b",
               $time, aa, bb, eq, gt, lt, geq, ggt, glt);
      errors++;
    end
  endtask

  initial begin
    $display("Starting self-testing testbench");

    a=0; b=0; #1 check(a,b);
    a=10; b=20; #1 check(a,b);
    a=200; b=120; #1 check(a,b);
    a=255; b=255; #1 check(a,b);

    for (i=0; i<5000; i++) begin
      a = $urandom_range(0,255);
      b = $urandom_range(0,255);
      #1 check(a,b);
    end

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("TEST FAILED   Total Errors = %0d", errors);

    $finish;
  end

endmodule
