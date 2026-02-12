`timescale 1ns/1ps
`define DATAFLOW

module Or_gate(input A, B, output Y);

// STRUCTURAL MODEL
`ifdef STRUCTURAL

    or O1(Y, A, B);

// DATAFLOW MODEL
`elsif DATAFLOW

    assign Y = A | B;

// BEHAVIORAL MODEL
`else
    reg Y_reg;
    assign Y = Y_reg;

    always @(*) begin
        if (A | B)
            Y_reg = 1'b1;
        else
            Y_reg = 1'b0;
    end
`endif

endmodule
