`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Project Owner: Team Silicon Crystals (SGSITS Indore) [1-TOPS by VSI]        //
// Engineer: Divyansh Tyagi                                                    //
//                                                                             //
// Create Date: 23-03-2026                                                     //
// Latest revision: 25-03-2026                                                 //
// Design Name: Mult-Div Unit                                                  //
// Module Name: tsc_mult_div                                                   //
// Project Name: TSCSoC                                                        //
/////////////////////////////////////////////////////////////////////////////////


module tsc_mult_div (

    input  logic        clk,
    input  logic        rst,
    input  logic        start_i,

    input  logic [1:0]  op_i,        // 00=MUL, 01=DIV, 10=REM
    input  logic [31:0] a_i,
    input  logic [31:0] b_i,

    output logic [31:0] result_o,
    output logic        done_o,
    output logic        busy_o

);

    // ================= INTERNAL REGISTERS =================
    logic [63:0] acc;
    logic [63:0] multiplicand;
    logic [31:0] multiplier;

    logic [63:0] rem;
    logic [31:0] divisor;

    logic [5:0] count;

    typedef enum logic [1:0] {
        IDLE,
        RUN,
        DONE
    } state_t;

    state_t state;

    // ================= FSM =================
    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin
            state   <= IDLE;
            done_o  <= 0;
            count   <= 0;
        end

        else begin
            case (state)

                // ================= IDLE =================
                IDLE: begin
                    done_o <= 0;

                    if (start_i) begin
                        count <= 0;

                        if (op_i == 2'b00) begin
                            // MUL INIT
                            multiplicand <= {32'd0, a_i};
                            multiplier   <= b_i;
                            acc          <= 64'd0;
                        end else begin
                            // DIV / REM INIT
                            rem     <= {32'd0, a_i};
                            divisor <= b_i;
                        end

                        state <= RUN;
                    end
                end

                // ================= RUN =================
                RUN: begin

                    // -------- MULTIPLICATION --------
                    if (op_i == 2'b00) begin
                        if (multiplier[0])
                            acc <= acc + multiplicand;

                        multiplicand <= multiplicand << 1;
                        multiplier   <= multiplier >> 1;
                    end

                    // -------- DIVISION / REM --------
                    else begin
                        rem = rem << 1;
                        rem[31:0] = rem[31:0] - divisor;

                        if (rem[31] == 1) begin
                            rem[31:0] = rem[31:0] + divisor;
                            rem[0] = 0;
                        end else begin
                            rem[0] = 1;
                        end
                    end

                    count <= count + 1;

                    if (count == 31)
                        state <= DONE;
                end

                // ================= DONE =================
                DONE: begin
                    done_o <= 1;

                    case (op_i)
                        2'b00: result_o <= acc[31:0];      // MUL (lower 32 bits)
                        2'b01: result_o <= rem[31:0];      // DIV (quotient)
                        2'b10: result_o <= rem[63:32];     // REM (remainder)
                        default: result_o <= 32'd0;
                    endcase

                    state <= IDLE;
                end

            endcase
        end
    end

    assign busy_o = (state == RUN);

endmodule
