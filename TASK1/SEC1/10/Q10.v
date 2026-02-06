`timescale 1ns / 1ps

module gtbtg #(parameter N = 8)(
    input en,
    input mode,   
    input [N-1:0] x,
    output reg [N-1:0] y
);

integer i;
reg [N-1:0] gtb;
always @(*) begin
    gtb[N-1] = x[N-1];
    for (i=N-2; i>=0; i = i-1)
        gtb[i] = gtb[i+1] ^ x[i];
end
always @(*) begin
    if (!en)
        y = 0;
    else if (mode)
        y = gtb;              
    else
        y = x ^ (x >> 1);     
end
endmodule

