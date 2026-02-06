`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2026 21:25:55
// Design Name: 
// Module Name: eventcap
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module eventcap(
input logic clk,rst,evt,
output logic cap
);
logic trig;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        cap<=0;
        trig<=0;
    end else begin
        if(!trig && evt) begin
            cap<=1;
            trig<=1;
        end
    end
end

endmodule

