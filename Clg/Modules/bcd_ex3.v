`timescale 1ns / 1ps

module bcd_ex3(
    input  [3:0] bcd,
    output reg [3:0] ex3
);

always @(*) begin
    if (bcd <= 4'd9)
        ex3 = bcd + 4'd3;
    else
        ex3 = 4'bxxxx;   // invalid BCD
end

endmodule