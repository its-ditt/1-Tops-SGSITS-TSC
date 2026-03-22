`timescale 1ns/1ps

module full_adder (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);

    logic s1, c1, c2;

    half_adder HA1 (
        .a(a),
        .b(b),
        .sum(s1),
        .carry(c1)
    );

    half_adder HA2 (
        .a(s1),
        .b(cin),
        .sum(sum),
        .carry(c2)
    );

    assign cout = c1 | c2;

endmodule