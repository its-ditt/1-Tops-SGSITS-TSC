`timescale 1ns / 1ps

module jtsc_dmem(
input logic clk,

input logic [31:0] A,
input logic [31:0] WD,

input logic MemWrite,

input logic [2:0] funct3M,

output logic [31:0] RD
);

logic [7:0] Mem [0:1023];
logic [9:0] addr;
logic [31:0] word;

assign addr = A[9:0];

//////////////////////////////////////////////////////
// WRITE LOGIC
//////////////////////////////////////////////////////

always_ff @(posedge clk)
begin
    if(MemWrite)
    begin
        case(funct3M)

            3'b000:
            begin
                Mem[addr] <= WD[7:0];
            end
            3'b001:
            begin
                Mem[addr]     <= WD[7:0];
                Mem[addr + 1] <= WD[15:8];
            end

            3'b010:
            begin
                Mem[addr]     <= WD[7:0];
                Mem[addr + 1] <= WD[15:8];
                Mem[addr + 2] <= WD[23:16];
                Mem[addr + 3] <= WD[31:24];
            end
            default: ;
        endcase
    end
end

//////////////////////////////////////////////////////
// READ WORD
//////////////////////////////////////////////////////

assign word = {
    Mem[addr + 3],
    Mem[addr + 2],
    Mem[addr + 1],
    Mem[addr]
};

//////////////////////////////////////////////////////
// LOAD LOGIC
//////////////////////////////////////////////////////

always_comb
begin
    case(funct3M)

        3'b000:
            RD = {{24{Mem[addr][7]}}, Mem[addr]};
        3'b001:
            RD = {{16{Mem[addr+1][7]}}, Mem[addr+1], Mem[addr]};
        3'b010:
            RD = word;
        3'b100:
            RD = {24'b0, Mem[addr]};
        3'b101:
            RD = {16'b0, Mem[addr+1], Mem[addr]};
        default:
            RD = 32'b0;

    endcase
end

endmodule