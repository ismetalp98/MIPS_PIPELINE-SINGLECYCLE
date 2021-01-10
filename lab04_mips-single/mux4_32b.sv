`timescale 1ns / 1ps

module mux4_32b(input logic [31:0] a,b,c,d,
                input logic [1:0] alucont,
                output logic [31:0] y);
         
         wire [31:0] mux1_out;
         wire [31:0] mux2_out;
         
         mux2 #(32) mux1 (a,c,alucont[1],mux1_out);       
         mux2 #(32) mux2 (b,d,alucont[1],mux2_out);      
         mux2 #(32) mux3 (mux1_out,mux2_out,alucont[0],y);
               
endmodule         


