`timescale 1ns / 1ps

module clk_div_even #(parameter N=2)(
    input clk,
    input rst,
    output reg clk_out
);

reg [$clog2(N/2)-1:0] c;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        c <= 0;
        clk_out <= 0;
    end else begin
        if(c == (N/2)-1) begin
            c <= 0;
            clk_out <= ~clk_out;
        end else begin
            c <= c + 1;
        end
    end
end
endmodule
