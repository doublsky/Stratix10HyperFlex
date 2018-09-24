/*
Copyright (C) 2014 John Leitch (johnleitch@outlook.com)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
`timescale 1ns / 1ps

`include "Md5CoreTestMacros.v"

module Md5CoreTest;

reg clk, reset, test_all;
wire [31:0] a, b, c, d;
reg [31:0] count = 0;
reg [511:0] chunk;

top m (
  .clk(clk), 
  .wb(chunk), 
  .a0('h67452301), 
  .b0('hefcdab89), 
  .c0('h98badcfe), 
  .d0('h10325476), 
  .a64(a), 
  .b64(b), 
  .c64(c), 
  .d64(d)
);

initial
  begin
    clk = 0;
    forever #5 clk = !clk;
  end
  
initial
  begin
    reset = 0;
    #10 reset = 1;
    #20 reset = 0;
  end
 
`define DoneCount 6 + `Stages

//""
`TestCase(  
  0, 
  test0,
  'hd98c1dd4,
  'h04b2008f,
  'h980980e9,
  'h7e42f8ec,
  'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000)

//"A"
`TestCase(  
  1, 
  test1,
  'h7062c57f,
  'ha80fa7e7,
  'hb735591a,
  'h29beac2e,
  'b00000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000001000001)

//"AAA"
`TestCase(  
  2, 
  test2,
  'hb3fffae1,
  'hc2e614e6,
  'h9642a7fb,
  'hb7862396,
  'b00000000000000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000010000010100000101000001)

//"Hello World"
`TestCase(  
  3, 
  test3,
  'hb18d0ab1,
  'h4175e064,
  'h9ba9b705,
  'he53f2ee7,
  'b00000000000000000000000000000000000000000000000000000000010110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000110010001101100011100100110111101010111001000000110111101101100011011000110010101001000)

//"The quick brown fox jumps over the lazy dog"
`TestCase(  
  4, 
  test4,
  'h9d7d109e,
  'h82b62b37,
  'h351dd86b,
  'hd619a442,
  'b00000000000000000000000000000000000000000000000000000001010110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000001100111011011110110010000100000011110010111101001100001011011000010000001100101011010000111010000100000011100100110010101110110011011110010000001110011011100000110110101110101011010100010000001111000011011110110011000100000011011100111011101101111011100100110001000100000011010110110001101101001011101010111000100100000011001010110100001010100)

//"The quick brown fox jumps over the lazy dog."
`TestCase(  
  5, 
  test5,
  'hc209d9e4,
  'h1cfbd090,
  'hadff68a0,
  'hd0cb22df,
  'b00000000000000000000000000000000000000000000000000000001011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000010111001100111011011110110010000100000011110010111101001100001011011000010000001100101011010000111010000100000011100100110010101110110011011110010000001110011011100000110110101110101011010100010000001111000011011110110011000100000011011100111011101101111011100100110001000100000011010110110001101101001011101010111000100100000011001010110100001010100) 
    
`define TestAllExp test0&test1&test2&test3&test4&test5
    
always @(posedge clk) count <= count + 1;
always @(posedge clk) if (count == `DoneCount) test_all <= `TestAllExp;
always @(posedge clk) begin
    if (count == `DoneCount+1) begin
        if (test_all == 1'b1) begin
            $display("Good!");
        end else begin
            $display ("Bad @ %d", count);
            $error;
            $stop;
        end
    end
end
always @(posedge clk) if (count == `DoneCount+2) $finish;

initial begin
	$dumpfile("Md5Core.vcd");
	$dumpvars(0, m);
end
    
endmodule  

 

