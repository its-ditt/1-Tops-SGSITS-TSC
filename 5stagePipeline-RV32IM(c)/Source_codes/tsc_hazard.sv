`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 27-03-2026                                                 //
// Design Name: Hazard Unit                                                    //
// Module Name: tsc_hazard                                                     //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_hazard (

    // FROM ID STAGE (DECODED REGISTERS)
    input logic [4:0] id_rs1_i,
    input logic [4:0] id_rs2_i,

    // FROM EX STAGE
    input logic [4:0] ex_rd_i,
    input logic       ex_mem_read_i,

    output logic stall_o
);

    always_comb begin
        stall_o = 0;

        // Load-use hazard
        if (ex_mem_read_i &&
            (ex_rd_i != 0) &&
            ((ex_rd_i == id_rs1_i) || (ex_rd_i == id_rs2_i))) begin

            stall_o = 1;
        end
    end

endmodule
