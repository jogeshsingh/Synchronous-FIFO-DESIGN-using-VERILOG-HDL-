`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2022 05:29:37 PM
// Design Name: 
// Module Name: Synchronous_FIFO
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


module Synchronous_FIFO
#(parameter A_WIDTH = 8, 
  parameter D_WIDTH = 48)
(
input i_clk    ,                                     // single clock domain  
input i_rst_n  ,                                   // active low reset     
input i_wr_en  ,                                 // write enable signal  
input i_rd_en  ,                               //  read enable signal  
input [D_WIDTH-1:0] i_data ,                 // data input //
output o_fifo_empty  ,                      // fifo empty flag     
output o_fifo_full  ,                     // fifo full flag   
output o_fifo_almst_full ,               // fifo almost full flag , for controlling the write enable //
output [D_WIDTH-1:0] o_fifo_data

    );
      
    
 reg [A_WIDTH:0] rd_cnt = 0 ;            // read counter 
 reg [A_WIDTH:0] wr_cnt = 0;           // write counter 
  
 reg [A_WIDTH:0] rd_cnt_nxt = 0;
 reg [A_WIDTH:0] wr_cnt_nxt = 0; 
  
 wire r_enable ;                      // read enable control   
 wire w_enable ;                      // write_enable control  
 
  
 assign r_enable = i_rd_en && ~o_fifo_empty ;
 assign w_enable = i_wr_en && ~o_fifo_full  ; 
 
 assign o_rd_addr = rd_cnt_nxt[A_WIDTH-1:0] ;
 assign o_wr_addr = wr_cnt_nxt[A_WIDTH-1:0] ; 
 
 
 //depth of fifo == 256//
 localparam DEPTH_FIFO = 2**A_WIDTH ;
 
 always @(posedge i_clk)
    begin
       if (~i_rst_n) begin
           rd_cnt <= 0;
           wr_cnt <= 0;
        end    
      else
        begin
           rd_cnt <= rd_cnt_nxt ;
           wr_cnt <= wr_cnt_nxt ;
      end           
 end 
 
 
 /// increment the read  pointer  //
 always @(posedge i_clk)
    begin
         if (~i_rst_n)
          rd_cnt_nxt  <= 0;
       else
          if (r_enable)
            rd_cnt_nxt <= rd_cnt_nxt + 1'b1 ;
       else
            rd_cnt_nxt <= rd_cnt_nxt ;
   end 
   
   // increment the  write pointer //
   
   always @(posedge i_clk) 
      begin
             if (~i_rst_n)
                wr_cnt_nxt <= 0;
           else
               if (w_enable)
                 wr_cnt_nxt <= wr_cnt_nxt + 1'b1 ; 
           else
                 wr_cnt_nxt <= wr_cnt_nxt ;
      end                                   
    
    
    assign o_fifo_empty = (wr_cnt[A_WIDTH-1:0] ==  rd_cnt[A_WIDTH-1:0] );
    assign o_fifo_full  = (wr_cnt == DEPTH_FIFO-1) ;
    assign o_fifo_almst_full = (wr_cnt == DEPTH_FIFO-2);
   
  
     D_PRAM 
#(.WIDTH_DATA(D_WIDTH) , 
  .WIDTH_ADDR(A_WIDTH) 
 )
BRAM_U1(
 ///write block signals//
  .i_wclk(i_clk) , 
  .i_wr_en(w_enable) , 
  .i_WADDR(o_wr_addr) , 
  .i_WDATA(i_data), 
 
 ///read block signals //
  .i_rdclk(i_clk) , 
  .i_rd_en(r_enable) ,
  .i_RADDR(o_rd_addr) , 
  .o_RDATA(o_fifo_data)   
);
  
    
    
endmodule
