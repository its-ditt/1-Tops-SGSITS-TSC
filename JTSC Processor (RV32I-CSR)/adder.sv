`timescale 1ns / 1ps

module adder(
input logic [31:0] PCE,
input logic [31:0] ImmExtendE,
output logic [31:0] PcTargetE
    );
    assign PcTargetE = PCE +ImmExtendE;

endmodule
