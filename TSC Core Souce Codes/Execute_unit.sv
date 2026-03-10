`timescale 1ns / 1ps

module execute_unit(

    input  logic clk_i,
    input  logic rst_i,

    input  logic valid_i,

    input  logic use_mul_i,
    input  logic use_div_i,

    input  logic [3:0] alu_op_i,
    input  logic [1:0] mul_op_i,
    input  logic [1:0] div_op_i,

    input  logic [31:0] op_a_i,
    input  logic [31:0] op_b_i,

    output logic [31:0] result_o,
    output logic ready_o

);

logic [31:0] alu_result;
logic [31:0] mul_result;
logic [31:0] div_result;

logic mul_ready;
logic div_ready;


ALU u_alu(
    .op_a_i(op_a_i),
    .op_b_i(op_b_i),
    .alu_op_i(alu_op_i),
    .alu_result_o(alu_result)
);


mul_unit u_mul(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .mul_req_i(valid_i & use_mul_i),
    .mul_op_i(mul_op_i),
    .op_a_i(op_a_i),
    .op_b_i(op_b_i),
    .mul_result_o(mul_result),
    .mul_ready_o(mul_ready)
);


div_unit u_div(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .div_req_i(valid_i & use_div_i),
    .div_op_i(div_op_i),
    .op_a_i(op_a_i),
    .op_b_i(op_b_i),
    .div_result_o(div_result),
    .div_ready_o(div_ready)
);


always_comb begin

    if(use_mul_i)
        result_o = mul_result;

    else if(use_div_i)
        result_o = div_result;

    else
        result_o = alu_result;

end


always_comb begin

    if(use_mul_i)
        ready_o = mul_ready;

    else if(use_div_i)
        ready_o = div_ready;

    else
        ready_o = valid_i;

end

endmodule
