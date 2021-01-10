`timescale 1ns / 1ps

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite, jump,jm,bge,
	              output logic[1:0] aluop );
   logic [10:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop, jump,jm,bge} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 11'b11000010000; // R-type
      6'b100011: controls <= 11'b10100100000; // LW
      6'b101011: controls <= 11'b00101000000; // SW
      6'b000100: controls <= 11'b00010001000; // BEQ
      6'b001000: controls <= 11'b10100000000; // ADDI
      6'b000010: controls <= 11'b00000000100; // J
      6'b110010: controls <= 11'b00100100010; // JM
      6'b110011: controls <= 11'b00010011001; // BGE
      default:   controls <= 11'bxxxxxxxxxx; // illegal op
    endcase
endmodule