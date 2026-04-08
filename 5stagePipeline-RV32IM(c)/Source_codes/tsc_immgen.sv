`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 25-03-2026                                                 //
// Design Name: Imm. generator                                                 //
// Module Name: tsc_imgen                                                      //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////

module tsc_immgen (

    input  logic [31:0] instr_i,
    input  logic [2:0]  imm_sel_i,

    output logic [31:0] imm_o

);

    always_comb begin
        case (imm_sel_i)

            // ================= I-TYPE =================
            3'b000: begin
                imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
            end

            // ================= S-TYPE =================
            3'b001: begin
                imm_o = {{20{instr_i[31]}},
                         instr_i[31:25],
                         instr_i[11:7]};
            end

            // ================= B-TYPE =================
            3'b010: begin
                imm_o = {{19{instr_i[31]}},
                         instr_i[31],
                         instr_i[7],
                         instr_i[30:25],
                         instr_i[11:8],
                         1'b0};
            end

            // ================= U-TYPE =================
            3'b011: begin
                imm_o = {instr_i[31:12], 12'b0};
            end

            // ================= J-TYPE =================
            3'b100: begin
                imm_o = {{11{instr_i[31]}},
                         instr_i[31],
                         instr_i[19:12],
                         instr_i[20],
                         instr_i[30:21],
                         1'b0};
            end

            default: imm_o = 32'd0;

        endcase
    end

endmodule
