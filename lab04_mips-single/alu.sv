`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2020 19:26:24
// Design Name: 
// Module Name: alu
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


module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);

  wire [31:0] bNot;
  wire [31:0] or_out;
  wire [31:0] mux_out;
  wire [31:0] and_out;
  wire [31:0] adder_out;
  wire adder_out_firstBit;
  wire [31:0] signExt_out;
  wire tempt;
   
  assign bNot = ~b + 1;
  
  mux2 #(32) mux1 (b,bNot,alucont[2],mux_out);
  
  adder add(a,mux_out,adder_out);
  
  assign and_out = a & mux_out;
  assign or_out = a | mux_out;


  assign adder_out_firstBit = adder_out[31];
  assign signExt_out = {31'b0000000000000000000000000000000, adder_out_firstBit};
  
  always @(adder_out) 
  begin
		if (adder_out == 0) 
		begin
			zero <= 1;
		end 
		else 
		begin
			zero <= 0;
		end
	
	end
 
 
  mux4_32b mux(and_out,or_out,adder_out,signExt_out,alucont[1:0],result);
  

endmodule


//module tba();

//    logic [31:0]a, b,result;
//    logic [2:0]alucont;
//    logic zero;
    
//    alu dut(a, b,alucont,result,zero);
    
    
//    initial begin
//        a = 8'h00000004; b= 8'h00000001; alucont = 000; #10;
//        a = 8'h00000004; b= 8'h00000001; alucont = 111; #10;
//        a = 8'h00000004; b= 8'h00000001; alucont = 110; #10;
//        a = 8'h00000001; b= 8'h00000004; alucont = 111; #10;

//    end
//endmodule