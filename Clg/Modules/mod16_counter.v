`timescale 1ns / 1ps

module mod10_counter(
    input clk, rst, mode,   
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst)
        count <= 4'b0000;

    else if (mode) begin
        if (count == 4'd0)
            count <= 4'd9;
        else
            count <= count - 1;
    end

    else begin
        if (count == 4'd9)
            count <= 4'd0;
        else
            count <= count + 1;
    end
end

endmodule
