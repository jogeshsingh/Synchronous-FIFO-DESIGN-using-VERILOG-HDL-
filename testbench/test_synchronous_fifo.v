`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2022 12:58:25 PM
// Design Name: 
// Module Name: test_synchronous_fifo
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


module test_synchronous_fifo();
reg i_clk ;
reg i_rst_n ;
reg i_wr_en ;
reg i_rd_en ;
reg[47:0] i_data ;
wire o_fifo_empty ; 
wire o_fifo_full ;
wire o_fifo_almst_full ; 
wire [47:0] o_fifo_data ;
 
 //instantiate the design module
 Synchronous_FIFO
DUT(
 i_clk    ,                                     // single clock domain  
 i_rst_n  ,                                   // active low reset     
 i_wr_en  ,                                 // write enable signal  
 i_rd_en  ,                               //  read enable signal  
 i_data ,                 // data input //
 o_fifo_empty  ,                      // fifo empty flag     
 o_fifo_full  ,                     // fifo full flag   
 o_fifo_almst_full ,               // fifo almost full flag , for controlling the write enable //
 o_fifo_data
    );


 initial
     begin
       i_clk = 1'b0 ;
       i_rst_n = 1'b0 ;
       i_wr_en = 1'b0 ;
       i_rd_en = 1'b0 ;
       i_data  = 48'h0;
    end 
    
   always #5 i_clk = ~i_clk;
   
  integer i ; 
   
   initial
      begin
         @(posedge i_clk);
           #4 i_rst_n = 1'b1 ;
           end 
   initial
     begin
       for (i= 0; i<48; i= i+1) begin
          #10  i_data = i_data + 48'h04 ;
        end  
    end 
    
    initial
      begin 
            for (i=0; i<47; i=i+1) begin
               #12 i_wr_en = 1'b1 ;
             end
             i_wr_en = 1'b0 ;
     end 
     
     integer j ;
     
    initial
       begin 
          for (j=0;  j<47 ; j=j+1) begin
              #50 i_rd_en = 1'b1 ;
           end 
             i_rd_en = 1'b0;
     end                                           

endmodule
