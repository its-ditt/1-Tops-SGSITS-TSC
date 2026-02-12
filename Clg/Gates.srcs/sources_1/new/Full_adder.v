`timescale 1ns / 1ps
`define STRUCTURAL


module Full_adder(input A,B,Ci, output Sum,Carry);

// STRUCTURAL MODEL
`ifdef STRUCTURAL

    wire s1,c1,c2;
    
    xor X1(s1, A, B);
    xor X2(Sum, s1, Ci);
    and A1(c1, A, B);
    and A2(c2, s1, Ci);
    or O1(Carry,c1,c2);
    
// DATAFLOW MODEL
`elsif DATAFLOW

    assign Sum=A^B^Ci;
    assign Carry=(A&B)|(Ci&(A^B));

// BEHAVIORAL MODEL
`else
   
    always @(*) begin
    
    reg Sum_reg,Carry_reg;
    
    assign Sum = Sum_reg; assign Carry = Carry_reg;
    Sum_reg = 0; Carry_reg = 0;
    
        if (A^B^Ci)
            Sum_reg = 1'b1;
        else if ((A&B)|(A&Ci)|(B&Ci))
            Carry_reg = 1'b1;
    end
`endif

endmodule
