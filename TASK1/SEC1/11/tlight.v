`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2026 15:01:08
// Design Name: 
// Module Name: tlight
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


module tlight(
    input clk,
    input rst,
    input ped,
    output reg r,
    output reg y,
    output reg g
);

parameter RT=20, GT=10, YT=3, PT=5;

reg [7:0] t;
reg [7:0] green_rem;
reg [2:0] cs, ns;
reg pred;

localparam S_R=0,
           S_G=1,
           S_Y=2,
           S_PY=3,
           S_PR=4;

always @(posedge clk) begin
    if(rst) begin
        cs<=S_R;
        t<=0;
        green_rem<=0;
        pred<=0;
    end else begin
        cs<=ns;

        if(cs!=ns)
            t<=0;
        else
            t<=t+1;

        if(cs==S_G && ped)
            pred<=1;

        if(ns==S_PY)
            pred<=0;

        if(cs==S_G && ns==S_PY)
            green_rem <= (GT - t) + 2;

        if(cs==S_PR && ns==S_G)
            t <= (GT - green_rem);
    end
end

always @(*) begin
    r=0; y=0; g=0;
    ns=cs;

    case(cs)

        S_R: begin
            r=1;
            if(t>=RT) ns=S_G;
        end

        S_G: begin
            g=1;
            if(pred) ns=S_PY;
            else if(t>=GT) ns=S_Y;
        end

        S_Y: begin
            y=1;
            if(t>=YT) ns=S_R;
        end

        S_PY: begin
            y=1;
            if(t>=YT) ns=S_PR;
        end

        S_PR: begin
            r=1;
            if(t>=PT) ns=S_G;
        end

    endcase
end

endmodule
