`timescale 1ns / 1ps

module RED(
    input  clk,
    input  signal,
    output pulse
);

reg prev;

always @(posedge clk) begin
    prev <= signal;
end

assign pulse = signal & ~prev;  // 1-cycle pulse
endmodule

