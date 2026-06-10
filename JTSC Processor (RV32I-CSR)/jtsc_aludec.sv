`timescale 1ns / 1ps

module jtsc_aludec(
input logic [6:0] op,
input logic [2:0] funct3,
input logic [6:0]funct7 ,
input logic [1:0]ALUOp ,
output logic [3:0]ALUControl
    );
    always_comb begin
    case (ALUOp)
    //load /store add
    2'b00 : ALUControl = 4'b0000;
    //branch sub
    2'b01 : ALUControl = 4'b0001;
    //R-type /I-type
    2'b10 : begin
    case (funct3)
  
    3'b000: begin
    if({op[5],funct7[5]} == 2'b11)
    ALUControl = 4'b0001;////for sub///
    else 
    ALUControl = 4'b0000;////for add///
    end
    3'b111: ALUControl = 4'b0010;//AND
    3'b110: ALUControl = 4'b0011;//OR
    3'b100: ALUControl = 4'b0100;//XOR
    3'b001: ALUControl = 4'b0101;//SLL 
    3'b010: ALUControl = 4'b1000;//SLT
    3'B101: begin 
      if (funct7[5])
      ALUControl = 4'b0111; //SRA
      else
      ALUControl = 4'b0110;//SRL
      end
   
    3'b011: ALUControl = 4'b1001;//SLTU
    default:ALUControl = 4'b0000;
    endcase
    end  
    default:ALUControl = 4'b0000;
    endcase
    end
endmodule

