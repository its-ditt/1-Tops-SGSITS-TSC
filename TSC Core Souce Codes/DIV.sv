`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2026 18:47:56
// Design Name: 
// Module Name: DIV
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


module div_unit(
    input  logic clk_i,
    input  logic rst_i,
    input  logic div_req_i,
    input  logic [1:0] div_op_i,     //00 DIV 01 DIVU 10 REM 11 REMU
    input  logic [31:0] op_a_i,
    input  logic [31:0] op_b_i,
    output logic [31:0] div_result_o,
    output logic div_ready_o
);

logic [63:0] dividend;
logic [31:0] divisor;
logic [31:0] quotient;
logic [31:0] remainder;

logic [5:0] cycle;

typedef enum logic[1:0] {IDLE,BUSY,DONE} state_e;
state_e state,next_state;


always_ff @(posedge clk_i or posedge rst_i)
begin
    if(rst_i)
        state <= IDLE;
    else
        state <= next_state;
end


always_comb begin
    next_state = state;

    case(state)
        IDLE: if(div_req_i) next_state = BUSY;
        BUSY: if(cycle == 32) next_state = DONE;
        DONE: next_state = IDLE;
    endcase
end


always_ff @(posedge clk_i or posedge rst_i)
begin
    if(rst_i)
    begin
        dividend <= 0;
        divisor <= 0;
        quotient <= 0;
        remainder <= 0;
        cycle <= 0;
    end
    else begin

        if(state==IDLE && div_req_i)
        begin
            dividend <= {32'd0,op_a_i};
            divisor  <= op_b_i;
            quotient <= 0;
            remainder <= 0;
            cycle <= 0;
        end

        else if(state==BUSY)
        begin
            dividend = dividend << 1;
            remainder = dividend[63:32];

            if(remainder >= divisor)
            begin
                remainder = remainder - divisor;
                quotient = (quotient << 1) | 1;
            end
            else
                quotient = quotient << 1;

            dividend[63:32] = remainder;

            cycle <= cycle + 1;
        end
    end
end


assign div_ready_o = (state == DONE);


always_comb begin

    case(div_op_i)

        2'b00: div_result_o = quotient;
        2'b01: div_result_o = quotient;
        2'b10: div_result_o = remainder;
        2'b11: div_result_o = remainder;

        default: div_result_o = 0;

    endcase

end

endmodule
