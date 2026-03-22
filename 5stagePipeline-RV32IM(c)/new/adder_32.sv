`timescale 1ns/1ps

module adder_32 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] sum
);

    logic [31:0] carry;

    genvar i;

    generate
        for (i = 0; i < 32; i++) begin : FA_GEN

            if (i == 0) begin
                full_adder FA (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(1'b0),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                full_adder FA (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end

        end
    endgenerate

endmodule