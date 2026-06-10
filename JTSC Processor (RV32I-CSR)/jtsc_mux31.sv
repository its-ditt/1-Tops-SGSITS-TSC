`timescale 1ns / 1ps

module mux_3_1(
input logic [31:0] a,b,c,
input logic [1:0] s,
output logic [31:0] muxout
    );
    always_comb begin
     case (s)
        2'b00: muxout = a;
        2'b01: muxout = b;
        2'b10: muxout = c;
        default: muxout = 32'b0; 
    endcase
    end
   
endmodule
