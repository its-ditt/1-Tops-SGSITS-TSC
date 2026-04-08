`timescale 1ns / 1ps

//`define STRUCTURAL2
// `define STRUCTURAL1
// `define DATA_FLOW

module mult_4x1 (
    input [3:0] d,
    input [1:0] s,
    output y
);

`ifdef STRUCTURAL1

    wire s0_n, s1_n;
    wire w0, w1, w2, w3;

    not N0(s0_n, s[0]);
    not N1(s1_n, s[1]);

    and A0(w0, d[0], s0_n, s1_n);
    and A1(w1, d[1], s[0], s1_n);
    and A2(w2, d[2], s0_n, s[1]);
    and A3(w3, d[3], s[0], s[1]);

    or O0(y, w0, w1, w2, w3);
    
`elsif STRUCTURAL2

    `define MUX2(out,a,b,sel) assign out = sel ? b : a;

    wire y0, y1;

    `MUX2(y0, d[0], d[1], s[0])
    `MUX2(y1, d[2], d[3], s[0])
    `MUX2(y,  y0,   y1,   s[1])

`elsif DATA_FLOW

    assign y = (s == 2'b00) ? d[0] :
               (s == 2'b01) ? d[1] :
               (s == 2'b10) ? d[2] :
                              d[3] ;

`else //BEHAVIORAL

    reg y_reg;
    assign y = y_reg;

    always @(*) begin
        case (s)
            2'b00: y_reg = d[0];
            2'b01: y_reg = d[1];
            2'b10: y_reg = d[2];
            2'b11: y_reg = d[3];
        endcase
    end

`endif

endmodule
