`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 22-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: Instr. Memory                                                  //
// Module Name: tsc_imem                                                       //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_imem #(
    parameter N = 256
)(
    input  logic [31:0] addr_i,
    output logic [31:0] instr_o
);

    logic [31:0] mem [0:N-1];

    initial begin
        $readmemh("program.hex", mem);
    end

    assign instr_o = mem[addr_i[9:2]];

endmodule
