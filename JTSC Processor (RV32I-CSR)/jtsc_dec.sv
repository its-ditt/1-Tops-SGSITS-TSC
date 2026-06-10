`timescale 1ns / 1ps

module jtsc_dec(

input logic [6:0] op,
input logic [2:0] funct3,

output logic [2:0] ResultSrc,
output logic MemWrite,
output logic ALUSrc,
output logic [1:0] ImmSrc,
output logic RegWrite,
output logic jump,
output logic Branch,
output logic [1:0] ALUOp,

output logic csr_en,
output logic [1:0] csr_op,
output logic csr_use_imm,
output logic mret,
output logic ecall

);

always_comb begin

RegWrite=0;
MemWrite=0;
ALUSrc=0;
ResultSrc=3'b000;
Branch=0;
jump=0;
ALUOp=2'b00;
ImmSrc=2'b00;

csr_use_imm=0;
csr_en=0;
csr_op=2'b00;
mret=0;
ecall=0;

case(op)

7'b0110011: begin
    RegWrite=1;
    ALUSrc=0;
    ALUOp=2'b10;
end

7'b0010011: begin
    RegWrite=1;
    ALUSrc=1;
    ALUOp=2'b10;
end

7'b0000011: begin
    RegWrite=1;
    ALUSrc=1;
    ResultSrc=3'b001;
    ALUOp=2'b00;
end

7'b0100011: begin
    MemWrite=1;
    ALUSrc=1;
    ImmSrc=2'b01;
    ALUOp=2'b00;
end

7'b1100011: begin
    Branch=1;
    ALUOp=2'b01;
    ImmSrc=2'b10;
end

7'b1101111: begin
    RegWrite=1;
    ResultSrc=3'b010;
    jump=1;
    ImmSrc=2'b11;
end

7'b1100111: begin
    RegWrite=1;
    ALUSrc=1;
    ResultSrc=3'b010;
    jump=1;
    ImmSrc=2'b00;
end

7'b1110011: begin

    case(funct3)

        // ECALL / MRET
        3'b000: begin
            ecall=1;
        end

        // CSRRW
        3'b001: begin
            csr_en=1;
            csr_op=2'b00;
            RegWrite=1;
            ResultSrc=3'b011;
        end

        // CSRRS
        3'b010: begin
            csr_en=1;
            csr_op=2'b01;
            RegWrite=1;
            ResultSrc=3'b011;
        end

        // CSRRC
        3'b011: begin
            csr_en=1;
            csr_op=2'b10;
            RegWrite=1;
            ResultSrc=3'b011;
        end

        // CSRRWI
        3'b101: begin
            csr_en=1;
            csr_op=2'b00;
            csr_use_imm=1;
            RegWrite=1;
            ResultSrc=3'b011;
        end

        // CSRRSI
        3'b110: begin
            csr_en=1;
            csr_op=2'b01;
            csr_use_imm=1;
            RegWrite=1;
            ResultSrc=3'b011;
        end

        // CSRRCI
        3'b111: begin
            csr_en=1;
            csr_op=2'b10;
            csr_use_imm=1;
            RegWrite=1;
            ResultSrc=3'b011;
        end
        default: ;
    endcase
end

default: ;

endcase

end

endmodule
