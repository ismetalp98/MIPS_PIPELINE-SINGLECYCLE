// single-cycle MIPS processor, with controller and datapath
`timescale 1ns / 1ps
module mips (input  logic        clk, reset,
             output logic[31:0]  pc,
             input  logic[31:0]  instr,
             output logic        memwrite,
             output logic[31:0]  aluout, writedata,
             input  logic[31:0]  readdata);

  logic        memtoreg, pcsrc, zero, alusrc, regdst, regwrite, jump,jm,bge,zeroa,zerob;
  logic [2:0]  alucontrol;
  
  assign zerob = ~aluout[0] & bge;
  assign zeroa = zero | zerob;

  controller c (instr[31:26], instr[5:0], zeroa, memtoreg, memwrite, pcsrc,
                        alusrc, regdst, regwrite, jump,jm,bge, alucontrol);

  datapath dp (clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump,jm,bge,
                          alucontrol, zero, pc, instr, aluout, writedata, readdata);

endmodule