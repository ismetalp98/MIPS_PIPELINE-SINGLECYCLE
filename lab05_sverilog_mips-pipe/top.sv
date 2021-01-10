`timescale 1ns / 1ps


module top  (input logic clk, reset,
             output logic memwriteM,regwriteW,
             output logic [31:0] writedataM,instr,resultM,PCF);  

   mips mips (clk, reset,memwriteM,regwriteW,
		writedataM,instr,resultM,PCF);
   
endmodule



module tb();

logic clk, reset;
logic memwriteM,regwriteW;
logic [31:0] writedataM,instr,resultM,PCF;

 top dut(clk, reset,memwriteM,regwriteW,
		writedataM,instr,resultM,PCF);
 
 initial 
        begin
        $display("clk   ", "reset   ","memwriteM    ","regwriteW    writedataM       instr        resultM         PCF");
            reset <= 1; #22; reset <= 0;
        end
    
    always
        begin  
            clk <= 0; #5;   
            clk <= 1; #5; 
            $displayh(clk,"       ",reset,"        ",memwriteM,"              ",regwriteW,"         ", 
		writedataM,"      ",instr,"      ",resultM,"       ",PCF);  
        end

endmodule



module mips (input  logic clk, reset,
             output logic MemWriteM,regwriteW,
             output logic [31:0] writedataM,instr,resultM,PCF);
  
  logic RegWriteD,MemToRegD,MemWriteD,AluSrcD,RegDstD,BranchD;
  logic [2:0] ALUControlD;
  logic [31:0] instrD;

	
	controller c(instrD[31:26], instrD[5:0],MemToRegD, 
	MemWriteD,AluSrcD,RegDstD, RegWriteD,ALUControlD,BranchD);

	datapath dp(clk,reset,RegWriteD,MemToRegD,MemWriteD,
	AluSrcD,RegDstD,BranchD,ALUControlD,instrD,
	MemWriteM,regwriteW,writedataM,instr,resultM,PCF);

endmodule




module controller(input  logic[5:0] op, funct,
                  output logic     memtoreg, memwrite,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic[2:0] alucontrol,
                  output logic branch);

   logic [1:0] aluop;

   maindec md (op, memtoreg, memwrite, branch, alusrc, 
	regdst, regwrite, aluop);

   aludec  ad (funct, aluop, alucontrol);

endmodule









module PipeFtoD(input logic[31:0] instr, PCPlus4F,
                input logic StallD, clk,reset,		// StallD will be connected as this EN
                output logic[31:0] instrD, PCPlus4D);

                always_ff @(posedge clk)
                if(reset)
                begin
                instrD <= 0;
		PCPlus4D <= 0;
                end
                else if(!StallD)
                begin
                instrD<=instr;
                PCPlus4D <= PCPlus4F;
                end
endmodule




module PipeWtoF(input logic[31:0] PC,
                input logic StallF, clk, reset,		// StallF will be connected as this EN
                output logic[31:0] PCF);

                always_ff @(posedge clk)
		if(reset)
		begin
		PCF <=0;
		end  
		else if(!StallF)
		begin
		PCF<=PC;
		end
                
endmodule


// *******************************************************************************
// Below, write the modules for the pipes PipeDtoE, PipeEtoM, PipeMtoW yourselves.
// Don't forget to connect Control signals in these pipes as well.
// *******************************************************************************


module PipeDtoE(input logic clk,FlushE,reset,
                input logic RegWriteD,MemtoRegD,MemWriteD,BranchD,
                input logic [2:0] AluControlD,
                input logic AluSrcD,RegDstD,
                input logic [4:0] RsD,RtD,RdD,
                input logic [31:0] PcPlus4D,
                input logic [31:0] Rd1,Rd2,SignImmD,   
                output logic RegWriteE,MemtoRegE,MemWriteE,BranchE,AluSrcE,RegDstE,
                output logic [2:0] AluControlE,
                output logic [4:0] RsE,RtE,RdE,
                output logic [31:0] PcPlus4E,
                output logic [31:0] RdE1,RdE2,SignImmE);
                
                always_ff @(posedge clk)
                    if(reset )
                        begin
                        RegWriteE<=0;
                        MemtoRegE<=0;
                        MemWriteE<=0;
                        AluSrcE<=0;
                        RegDstE<=0;
                        BranchE<=0;
                        AluControlE<=0;
                        RdE1<=0;
                        RdE2<=0;
                        PcPlus4E<=0;
                        RsE<=0;
                        RtE<=0;
                        RdE<=0;     
                        SignImmE<=0;
                        end

                        else if(FlushE)
                        begin
                        RegWriteE<=0;
                        MemtoRegE<=0;
                        MemWriteE<=0;
                        AluSrcE<=0;
                        RegDstE<=0;
                        BranchE<=0;
                        AluControlE<=0;
                        RdE1<=0;
                        RdE2<=0;
                        PcPlus4E<=0;
                        RsE<=0;
                        RtE<=0;
                        RdE<=0;     
                        SignImmE<=0;
                        end

                    else
                        begin
                        RegWriteE<=RegWriteD;
                        MemtoRegE<=MemtoRegD;
                        MemWriteE<=MemWriteD;
                        AluSrcE<=AluSrcD;
                        RegDstE<=RegDstD;
                        BranchE<=BranchD;
                        AluControlE<=AluControlD;
                        RsE<=RsD;
                        RtE<=RtD;
                        RdE1<=Rd1;
                        RdE2<=Rd2;
                        RdE<=RdD;
                        PcPlus4E<=PcPlus4D;            
                        SignImmE<=SignImmD;
                        end     
endmodule


module PipeEtoM(input logic clk,reset,RegWriteE,MemtoRegE,MemWriteE,BranchE,ZeroE,
                input logic [31:0] AluOutE,WriteDataE,PcBranchE,
                input logic [4:0] WriteRegE,
                output logic RegWriteM,MemtoRegM,MemWriteM,BranchM,ZeroM,
                output logic [31:0] AluOutM,WriteDataM,PcBranchM,
                output logic [4:0] WriteRegM
                );
                always_ff@(posedge clk)
                    begin
                        begin
                        RegWriteM<=RegWriteE;
                        MemtoRegM<=MemtoRegE;
                        MemWriteM<=MemWriteE;
                        BranchM<=BranchE;
                        ZeroM<=ZeroE;
                        AluOutM<=AluOutE;
                        WriteDataM<=WriteDataE;
                        PcBranchM<=PcBranchE;
                        WriteRegM<=WriteRegE;
                        end
                    end             
endmodule


module PipeMtoW(input logic clk,reset,RegWriteM,MemtoRegM,
                input logic [31:0] ReadDataM,ALUOutM,
                input logic [4:0] WriteRegM,
                output logic RegWriteW,MemtoRegW,
                output logic [31:0] ReadDataW,ALUOutW,
                output logic [4:0] WriteRegW);
                
                always_ff@(posedge clk)
                    begin
                    RegWriteW<=RegWriteM;
                    MemtoRegW<=MemtoRegM;
                    ReadDataW<=ReadDataM;
                    ALUOutW<=ALUOutM;
                    WriteRegW<=WriteRegM;
                    end		
                                  
endmodule





module datapath (input  logic clk, reset,regwriteD,memtoregD,memwriteD,alusrcD,regdstD,branchD,
                 input logic [2:0] alucontrolD,
                 output logic [31:0] instrD,   
                 output logic memwriteM,regwriteW,
                 output logic [31:0] writedataM,instr,resultW,PCF);  


	// F stage var
	logic [31:0] PCPlus4F;
	
	
	// D stage var
	logic [31:0] shifted,SignImmD,PCPlus4D;
	logic [31:0] RD1,RD2;

	
	// E stage var
	logic [4:0] rsE,writeregE,rtE,rdE;
	logic regwriteE,memtoregE,memwriteE,alusrcE,regdstE,branchE,zeroE;
	logic [31:0] SrcAE,pcPlus4E,SrcBE,ALUOutE;
	logic [2:0] alucontrolE;
	logic [31:0] RDE1,RDE2;
	logic [31:0] SignImmE;
	logic [31:0] writedataE,pcbranchE;
	
	
	// M stage var
	logic regwriteM,memtoregM,branchM,zeroM;
	logic pcsrcM;
	logic [31:0] pcbranchM,readdataM,aluoutM;
	logic [4:0] writeregM;
	
	
	// W stage var
	logic memtoregW;
	logic [31:0] ALUOutW,ReadDataW,pcw;
	logic [4:0] writeregW;
	
	
	// hazards
	logic StallF,StallD,FlushE;
	logic [1:0] ForwardAE,ForwardBE;
	


	//F stage
	imem imem (PCF[7:2], instr);
	adder add(PCF,32'b100,PCPlus4F);
	PipeFtoD ftod(instr,PCPlus4F,StallD,clk,reset,instrD,PCPlus4D);
	

    	signext extend(instrD[15:0],SignImmD);
	regfile regfil(clk,regwriteW,instrD[25:21],instrD[20:16],writeregW,resultW,RD1,RD2);
	PipeDtoE dtoe(clk,FlushE,reset,regwriteD,memtoregD,memwriteD,branchD,alucontrolD,alusrcD,regdstD,
	instrD[25:21],instrD[20:16],instrD[15:11],PCPlus4D,RD1,RD2,SignImmD,regwriteE,memtoregE,memwriteE,branchE,
	alusrcE,regdstE,alucontrolE,rsE,rtE,rdE,pcPlus4E,RDE1,RDE2,SignImmE);
	
	
	
	// D stage
	mux2 #(5) dst(rtE,rdE,regdstE,writeregE);
	mux2 #(32) srcb(writedataE,SignImmE,alusrcE,SrcBE);
	mux4 #(32) srca(RDE1,resultW,aluoutM,ForwardAE,SrcAE);
	mux4 #(32) srcprev(RDE2,resultW,aluoutM,ForwardBE,writedataE);
	
	PipeEtoM etom(clk,reset,regwriteE,memtoregE,memwriteE,branchE,zeroE,ALUOutE, 
	writedataE,pcbranchE,writeregE,regwriteM,memtoregM,memwriteM,branchM,zeroM,
    aluoutM,writedataM,pcbranchM,writeregM);
    sl2 shifter(SignImmE,shifted);
	adder pcbr(shifted,pcPlus4E,pcbranchE);
	alu al(SrcAE,SrcBE,alucontrolE,ALUOutE,zeroE);
	


	// M stage
	dmem dmem (clk, memwriteM, aluoutM, writedataM, readdataM);
    PipeMtoW mtow(clk,reset,regwriteM,memtoregM,readdataM,aluoutM,writeregM,
    regwriteW,memtoregW,ReadDataW,ALUOutW,writeregW);
    
    assign pcsrcM = branchM & zeroM;
    
     // W stage
    mux2 #(32) res(ALUOutW,ReadDataW,memtoregW,resultW);
	mux2 #(32) pcn(PCPlus4F,pcbranchM,pcsrcM,pcw);
	PipeWtoF wtof(pcw,StallF,clk,reset,PCF);

 
    HazardUnit hazard(regwriteW,writeregW,regwriteM,memtoregM,branchD,
	writeregM,writeregE,regwriteE,memtoregE,rsE,rtE,instrD[25:21],
	instrD[20:16],ForwardAE,ForwardBE,FlushE,StallD,StallF);
	 
endmodule




module HazardUnit( input logic RegWriteW,
                input logic [4:0] WriteRegW,
                input logic RegWriteM,MemToRegM,BranchD,
                input logic [4:0] WriteRegM,WriteRegE,
                input logic RegWriteE,MemToRegE, 		
                input logic [4:0] rsE,rtE,
                input logic [4:0] rsD,rtD,
                output logic [1:0] ForwardAE,ForwardBE,
                output logic FlushE,StallD,StallF

    );
    logic lwstall,branchstall;
    
    always_comb begin

        if ((rsE != 0) && (rsE == WriteRegM) && RegWriteM)
            ForwardAE = 2'b10;
        else if ((rsE != 0) && (rsE == WriteRegW) && RegWriteW)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
 

        if ((rtE != 0) & (rtE == WriteRegM) & RegWriteM)
            ForwardBE = 2'b10;
        else if ((rtE != 0) & (rtE == WriteRegW) & RegWriteW)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
            
        branchstall = BranchD & RegWriteE & (WriteRegE == rsD | WriteRegE == rtD) | 
	BranchD & MemToRegM & (WriteRegM == rsD | WriteRegM == rtD);

        lwstall = ((rsD==rtE) || (rtD==rtE)) && MemToRegE;
        
        FlushE = (lwstall | branchstall);
        StallF = FlushE;
        StallD = FlushE;

        end
endmodule





module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		

// 	***************************************************************************
//	Here, you can paste your own test cases that you prepared for the part 1-e.
//	Below is a placeholder program from the single-cycle lab.
//	***************************************************************************   	

//
//		address		instruction
//		-------		-----------
		8'h00: instr = 32'h20020001;
		8'h04: instr = 32'h20030002;
		8'h08: instr = 32'h20500002;
		8'h0c: instr = 32'h20710002;
		8'h10: instr = 32'h02039022;
	     	default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule




module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule


module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite,
	              output logic[1:0] aluop );
   logic [7:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 8'b11000010; // R-type
      6'b100011: controls <= 8'b10100100; // LW
      6'b101011: controls <= 8'b00101000; // SW
      6'b000100: controls <= 8'b00010001; // BEQ
      6'b001000: controls <= 8'b10100000; // ADDI
      default:   controls <= 8'bxxxxxxxx; // illegal op
    endcase
endmodule


module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic[2:0] alucontrol);
  always_comb
    case(aluop)
      2'b00: alucontrol  = 3'b010;  // add  (for lw/sw/addi)
      2'b01: alucontrol  = 3'b110;  // sub   (for beq)
      default: case(funct)          // R-TYPE instructions
          6'b100000: alucontrol  = 3'b010; // ADD
          6'b100010: alucontrol  = 3'b110; // SUB
          6'b100100: alucontrol  = 3'b000; // AND
          6'b100101: alucontrol  = 3'b001; // OR
          6'b101010: alucontrol  = 3'b111; // SLT
          default:   alucontrol  = 3'bxxx; // ???
        endcase
    endcase
endmodule



module regfile (input    logic clk, we3, 
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2);

  logic [31:0] rf [31:0];



  always_ff @(negedge clk)
     if (we3) 
         rf [wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ ra2] : 0;

endmodule


module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);
    
    always_comb
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b111: result = (a < b) ? 1 : 0;
            default: result = {32{1'bx}};
        endcase
    
    assign zero = (result == 0) ? 1'b1 : 1'b0;
    
endmodule


module adder (input  logic[31:0] a, b,
              output logic[31:0] y);
     
     assign y = a + b;
endmodule

module sl2 (input  logic[31:0] a,
            output logic[31:0] y);
     
     assign y = {a[29:0], 2'b00}; // shifts left by 2
endmodule

module signext (input  logic[15:0] a,
                output logic[31:0] y);
              
  assign y = {{16{a[15]}}, a};    // sign-extends 16-bit a
endmodule



// paramaterized 2-to-1 MUX
module mux2 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1,  
              input  logic s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s ? d1 : d0; 
endmodule


module mux4 #(parameter WIDTH = 8)
            (input logic[WIDTH-1:0] d0,d1,d2,
             input logic [1:0] s,
             output logic[WIDTH-1:0] y);
             
             
             assign y = s[1] ?  d2 : (s[0] ? d1:d0);
endmodule