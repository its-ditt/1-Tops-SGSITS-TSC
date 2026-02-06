`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2026 14:25:04
// Design Name: 
// Module Name: Assert1
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


module Assert1;

logic clk,evt;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    evt = 0;
    #30 evt = 1;  
    #10 evt = 0;
    #20 evt = 1;
    #10 $finish;
end


property evtoccured;
    @(posedge evt) evt==0;
endproperty

assert property(evtoccured)
else begin
    $display("FIRST EVENT OCCURRED at time=%0t", $time);
    $fatal("Stopping simulation due to event.");
end
endmodule
