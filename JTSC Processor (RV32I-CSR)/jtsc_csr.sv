module tsc_csr(

input logic clk,rst,

input logic csr_en_i,
input logic [1:0] csr_op_i,
input logic [11:0] csr_addr_i,

input logic [31:0] csr_wdata_i,
output logic [31:0] csr_rdata_o,

input logic trap_i,
input logic [31:0] trap_pc_i,
input logic [31:0] trap_cause_i,

input logic mret_i,

output logic [31:0] mtvec_o,
output logic [31:0] mepc_o,
output logic [31:0] mstatus_o

);

//////////////////////////////////////////////////////
// CSR REGISTER OUTPUTS
//////////////////////////////////////////////////////

wire [31:0] mstatus;
wire [31:0] mtvec;
wire [31:0] mepc;
wire [31:0] mcause;

//////////////////////////////////////////////////////
// WRITE ENABLES
//////////////////////////////////////////////////////

logic wr_mstatus;
logic wr_mtvec;
logic wr_mepc;
logic wr_mcause;

assign wr_mstatus =
    csr_en_i &&
    (csr_addr_i == 12'h300);

assign wr_mtvec =
    csr_en_i &&
    (csr_addr_i == 12'h305);

assign wr_mepc =
    csr_en_i &&
    (csr_addr_i == 12'h341);

assign wr_mcause =
    csr_en_i &&
    (csr_addr_i == 12'h342);

//////////////////////////////////////////////////////
// MSTATUS
//////////////////////////////////////////////////////

csr_mstatus MSTATUS(

    .clk(clk),
    .rst(rst),

    .write_en(wr_mstatus),

    .csr_op(csr_op_i),
    .wdata(csr_wdata_i),

    .rdata(mstatus)

);

//////////////////////////////////////////////////////
// MTVEC
//////////////////////////////////////////////////////

csr_mtvec MTVEC(

    .clk(clk),
    .rst(rst),

    .write_en(wr_mtvec),

    .csr_op(csr_op_i),
    .wdata(csr_wdata_i),

    .rdata(mtvec)

);

//////////////////////////////////////////////////////
// MEPC
//////////////////////////////////////////////////////

csr_mepc MEPC(

    .clk(clk),
    .rst(rst),

    .write_en(wr_mepc),

    .trap_i(trap_i),
    .trap_pc_i(trap_pc_i),

    .csr_op(csr_op_i),
    .wdata(csr_wdata_i),

    .rdata(mepc)

);

//////////////////////////////////////////////////////
// MCAUSE
//////////////////////////////////////////////////////

csr_mcause MCAUSE(

    .clk(clk),
    .rst(rst),

    .write_en(wr_mcause),

    .trap_i(trap_i),
    .trap_cause_i(trap_cause_i),

    .csr_op(csr_op_i),
    .wdata(csr_wdata_i),

    .rdata(mcause)

);

//////////////////////////////////////////////////////
// CSR READ MUX
//////////////////////////////////////////////////////

always_comb begin

    case(csr_addr_i)

        12'h300:
            csr_rdata_o = mstatus;

        12'h305:
            csr_rdata_o = mtvec;

        12'h341:
            csr_rdata_o = mepc;

        12'h342:
            csr_rdata_o = mcause;

        default:
            csr_rdata_o = 32'd0;

    endcase

end

//////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////

assign mtvec_o   = mtvec;
assign mepc_o    = mepc;
assign mstatus_o = mstatus;

endmodule

