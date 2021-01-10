`timescale 1ns / 1ps

module top(input   logic 	 clk, reset,            
	     output  logic[31:0] writedata, dataadr,pc_out,inst_out,          
	     output  logic       memwrite
	     );  

   logic [31:0] pc, instr, readdata;    

   // instantiate processor and memories  
   mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);  
   imem imem (pc[7:2], instr);  
   dmem dmem (clk, memwrite, dataadr, writedata, readdata);
   
   assign pc_out = pc;
   assign inst_out = instr;

endmodule

module tb();

    logic clk,reset,memwrite;
    logic [31:0] writedata, dataadr,pc_out,instr_out;
    
    top dut(clk,reset,writedata, dataadr,pc_out,instr_out,memwrite);
    
    initial 
        begin
            $display("clk   ", "reset   ","memwrite    ","writedata    dataadr       pc       instruction");
            reset <= 1; #22; reset <= 0;
        end
    
    always
        begin  
            clk <= 0; #5;   
            clk <= 1; #5; 
            $displayh(clk,"        ",reset,"       ",memwrite,"        ",writedata,"     ", dataadr,"   ",pc_out,"      ",instr_out);  
        end
        
endmodule