`timescale 1ns / 1ps

module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//		address		instruction
//		-------		-----------
		8'h00: instr = 32'h20020005;  	
		8'h04: instr = 32'h2003000c;  	
		8'h08: instr = 32'h2067fff7; 
		8'h0c: instr = 32'h00e22025;  	
		8'h10: instr = 32'h00642824;
		8'h14: instr = 32'h00a42820;
		8'h18: instr = 32'h10a7000a;
		8'h1c: instr = 32'h0064202a;
		8'h20: instr = 32'h10800001;
		8'h24: instr = 32'h20050000;
		8'h28: instr = 32'h00e2202a;
		8'h2c: instr = 32'h00853820;
		8'h30: instr = 32'h00e23822; 
		8'h34: instr = 32'h20e70061; // add, $7,$7,97 // $7 = 104(68 in hex)
		8'h38: instr = 32'hac670044; // [80] = 8
		8'h3c: instr = 32'h8c020050;
		8'h40: instr = 32'h08000011;
		8'h44: instr = 32'h20020001;
		8'h48: instr = 32'hac020054;
		8'h4c: instr = 32'hcc440002; //bge  bge $2,$4,2  =  bge 7,1,2 (7 > 1, go to 58)
		8'h50: instr = 32'h2067fff7; //add will be skiped
		8'h54: instr = 32'h2067fff7; //add will be skiped
		8'h58: instr = 32'h2067fff7; // bge jums here
		8'h5c: instr = 32'hc8000050; //jm 80($0)  (go to adress 68)
		8'h60: instr = 32'h2067fff7; //add will be skiped
		8'h64: instr = 32'h2067fff7; //add will be skiped
		8'h68: instr = 32'h2067fff7; //add   jm will jump here
		8'h6c: instr = 32'h0800001b; // loop here
	     default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule
