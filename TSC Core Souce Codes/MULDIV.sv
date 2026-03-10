
module mul_unit(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        mul_req_i,
    input  logic [1:0]  mul_op_i,       // 00 MUL , 01 MULH , 10 MULHSU , 11 MULHU
    input  logic [31:0] op_a_i,
    input  logic [31:0] op_b_i,
    output logic [31:0] mul_result_o,
    output logic        mul_ready_o
);

logic [31:0] a;
logic [31:0] b;
logic [63:0] acc;
logic [5:0]  cycle;

logic sign_a;
logic sign_b;
logic result_sign;

typedef enum logic[1:0] {IDLE,BUSY,DONE} state_e;
state_e state,next_state;


// state register
always_ff @(posedge clk_i or posedge rst_i)
begin
    if(rst_i)
        state <= IDLE;
    else
        state <= next_state;
end


// next state logic
always_comb
begin
    next_state = state;

    case(state)
        IDLE: if(mul_req_i) next_state = BUSY;
        BUSY: if(cycle == 6'd31) next_state = DONE;
        DONE: next_state = IDLE;
    endcase
end


// main sequential block
always_ff @(posedge clk_i or posedge rst_i)
begin
    if(rst_i)
    begin
        acc   <= 64'd0;
        a     <= 32'd0;
        b     <= 32'd0;
        cycle <= 6'd0;
    end
    else
    begin
        // load operands
        if(state==IDLE && mul_req_i)
        begin
            sign_a = 0;
            sign_b = 0;

            case(mul_op_i)

                2'b00: begin // MUL
                    sign_a = op_a_i[31];
                    sign_b = op_b_i[31];
                end

                2'b01: begin // MULH signed x signed
                    sign_a = op_a_i[31];
                    sign_b = op_b_i[31];
                end

                2'b10: begin // MULHSU signed x unsigned
                    sign_a = op_a_i[31];
                    sign_b = 0;
                end

                2'b11: begin // MULHU unsigned
                    sign_a = 0;
                    sign_b = 0;
                end

            endcase

            result_sign = sign_a ^ sign_b;

            // take absolute values
            a <= sign_a ? -op_a_i : op_a_i;
            b <= sign_b ? -op_b_i : op_b_i;

            acc   <= 64'd0;
            cycle <= 6'd0;
        end

        // shift add multiplication
        else if(state==BUSY)
        begin
            if(b[0])
                acc <= acc + {32'd0,a};

            a <= a << 1;
            b <= b >> 1;

            cycle <= cycle + 1;
        end
    end
end


// result ready
assign mul_ready_o = (state==DONE);


// result selection
always_comb
begin

    logic [63:0] final_res;

    final_res = result_sign ? -acc : acc;

    case(mul_op_i)

        2'b00: mul_result_o = final_res[31:0];   // MUL
        2'b01: mul_result_o = final_res[63:32];  // MULH
        2'b10: mul_result_o = final_res[63:32];  // MULHSU
        2'b11: mul_result_o = final_res[63:32];  // MULHU

        default: mul_result_o = 32'd0;

    endcase

end

endmodule