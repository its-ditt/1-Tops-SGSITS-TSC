`timescale 1ns / 1ps
`define STRUCTURAL


module Half_adder(input A,B, output Sum,Carry);

// STRUCTURAL MODEL
`ifdef STRUCTURAL

    xor X1(Sum, A, B);
    and A1(Carry, A, B);
    
// DATAFLOW MODEL
`elsif DATAFLOW

    assign Sum=A^B;
    assign Carry=A&B;

// BEHAVIORAL MODEL
`else
   
    always @(*) begin
    
    reg Sum_reg,Carry_reg;
    
    assign Sum = Sum_reg; assign Carry = Carry_reg;
    Sum_reg = 0; Carry_reg = 0;
    
    Sum = 0; Carry = 0;
        if (A^B)
            Sum_reg = 1'b1;
        else if (A&B)
            Carry_reg = 1'b1;
    end
`endif

endmodule
