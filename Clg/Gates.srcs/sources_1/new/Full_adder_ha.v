`timescale 1ns / 1ps

module Full_adder_ha(input A,B,Ci, output Sum,Carry);

Half_adder H1(A,B,S1,C1);
Half_adder H2(S1,Ci,Sum,C2);
or O1(Carry,C1,C2);

endmodule
