`timescale 1ns / 1ps

module csr_gen //#(parameter RESET_VALUE = 32'd0)
    (
    input clk,rst,
    
    input write_en,
    
    input logic [1:0] csr_op,
    input logic [31:0] wdata,

    output logic [31:0] rdata
    );
    
always_ff @(posedge clk or negedge rst)
begin

    if(rst)

        rdata <= 32'd0;//RESET_VALUE

    else if(write_en)
    begin

        case(csr_op)
            2'b00: rdata <= wdata;
            2'b01: rdata <= rdata | wdata;
            2'b10: rdata <= rdata & ~wdata;
            default: rdata <= rdata;
        endcase
    end
end

endmodule

//module csr_reg #(parameter RESET_VALUE = 32'd0)
