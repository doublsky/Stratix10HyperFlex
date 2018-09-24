//
// Copyright (c) 2018, Tian Tan
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

module top
#(
    parameter DATA_WIDTH = 8,
    parameter MULT_LATENCY = 4,
    parameter TREE_DELAY = 1
)
(
    input           clk,
    input           rst,
    input           ena,

    input   [DATA_WIDTH-1:0]       a1_in,
    input   [DATA_WIDTH-1:0]       a2_in,
    input   [DATA_WIDTH-1:0]       a3_in,
    input   [DATA_WIDTH-1:0]       a4_in,
    input   [DATA_WIDTH-1:0]       a5_in,
    input   [DATA_WIDTH-1:0]       a6_in,
    input   [DATA_WIDTH-1:0]       a7_in,
    input   [DATA_WIDTH-1:0]       a8_in,
    input   [DATA_WIDTH-1:0]       a9_in,
    input   [DATA_WIDTH-1:0]       a10_in,
    input   [DATA_WIDTH-1:0]       a11_in,
    input   [DATA_WIDTH-1:0]       a12_in,
    input   [DATA_WIDTH-1:0]       a13_in,
    input   [DATA_WIDTH-1:0]       a14_in,
    input   [DATA_WIDTH-1:0]       a15_in,
    input   [DATA_WIDTH-1:0]       a16_in,
 
    input   [DATA_WIDTH-1:0]       b1_in,
    input   [DATA_WIDTH-1:0]       b2_in,
    input   [DATA_WIDTH-1:0]       b3_in,
    input   [DATA_WIDTH-1:0]       b4_in,
    input   [DATA_WIDTH-1:0]       b5_in,
    input   [DATA_WIDTH-1:0]       b6_in,
    input   [DATA_WIDTH-1:0]       b7_in,
    input   [DATA_WIDTH-1:0]       b8_in,
    input   [DATA_WIDTH-1:0]       b9_in,
    input   [DATA_WIDTH-1:0]       b10_in,
    input   [DATA_WIDTH-1:0]       b11_in,
    input   [DATA_WIDTH-1:0]       b12_in,
    input   [DATA_WIDTH-1:0]       b13_in,
    input   [DATA_WIDTH-1:0]       b14_in,
    input   [DATA_WIDTH-1:0]       b15_in,
    input   [DATA_WIDTH-1:0]       b16_in,
 
    output  [DATA_WIDTH*2-1+4:0]   res_out
);

    localparam NUM_FRONT = 1;
    localparam NUM_BACK = 0;

    wire    rst_dff, end_dff;

    wire    [DATA_WIDTH-1:0]    a1_in_dff,
                                a2_in_dff,
                                a3_in_dff,
                                a4_in_dff,
                                a5_in_dff,
                                a6_in_dff,
                                a7_in_dff,
                                a8_in_dff,
                                a9_in_dff,
                                a10_in_dff,
                                a11_in_dff,
                                a12_in_dff,
                                a13_in_dff,
                                a14_in_dff,
                                a15_in_dff,
                                a16_in_dff;

    wire    [DATA_WIDTH-1:0]    b1_in_dff,
                                b2_in_dff,
                                b3_in_dff,
                                b4_in_dff,
                                b5_in_dff,
                                b6_in_dff,
                                b7_in_dff,
                                b8_in_dff,
                                b9_in_dff,
                                b10_in_dff,
                                b11_in_dff,
                                b12_in_dff,
                                b13_in_dff,
                                b14_in_dff,
                                b15_in_dff,
                                b16_in_dff;

    regchain #(NUM_FRONT, 1) rst_regchain(clk, rst, rst_dff);
    regchain #(NUM_FRONT, 1) ena_regchain(clk, ena, ena_dff);

    regchain #(NUM_FRONT, DATA_WIDTH) a1_in_regchain(clk, a1_in, a1_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a2_in_regchain(clk, a2_in, a2_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a3_in_regchain(clk, a3_in, a3_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a4_in_regchain(clk, a4_in, a4_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a5_in_regchain(clk, a5_in, a5_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a6_in_regchain(clk, a6_in, a6_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a7_in_regchain(clk, a7_in, a7_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a8_in_regchain(clk, a8_in, a8_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a9_in_regchain(clk, a9_in, a9_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a10_in_regchain(clk, a10_in, a10_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a11_in_regchain(clk, a11_in, a11_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a12_in_regchain(clk, a12_in, a12_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a13_in_regchain(clk, a13_in, a13_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a14_in_regchain(clk, a14_in, a14_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a15_in_regchain(clk, a15_in, a15_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) a16_in_regchain(clk, a16_in, a16_in_dff);

    regchain #(NUM_FRONT, DATA_WIDTH) b1_in_regchain(clk, b1_in, b1_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b2_in_regchain(clk, b2_in, b2_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b3_in_regchain(clk, b3_in, b3_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b4_in_regchain(clk, b4_in, b4_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b5_in_regchain(clk, b5_in, b5_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b6_in_regchain(clk, b6_in, b6_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b7_in_regchain(clk, b7_in, b7_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b8_in_regchain(clk, b8_in, b8_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b9_in_regchain(clk, b9_in, b9_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b10_in_regchain(clk, b10_in, b10_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b11_in_regchain(clk, b11_in, b11_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b12_in_regchain(clk, b12_in, b12_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b13_in_regchain(clk, b13_in, b13_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b14_in_regchain(clk, b14_in, b14_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b15_in_regchain(clk, b15_in, b15_in_dff);
    regchain #(NUM_FRONT, DATA_WIDTH) b16_in_regchain(clk, b16_in, b16_in_dff);
    
	 dot16_alm # ( DATA_WIDTH, MULT_LATENCY, TREE_DELAY) dot16_alm_core (
									.clk        (clk),
									.rst        (rst_dff),
									.ena        (ena_dff),

									.a1_in      (a1_in_dff),
									.a2_in      (a2_in_dff),
									.a3_in      (a3_in_dff),
									.a4_in      (a4_in_dff),
									.a5_in      (a5_in_dff),
									.a6_in      (a6_in_dff),
									.a7_in      (a7_in_dff),
									.a8_in      (a8_in_dff),
									.a9_in      (a9_in_dff),
									.a10_in     (a10_in_dff),
									.a11_in     (a11_in_dff),
									.a12_in     (a12_in_dff),
									.a13_in     (a13_in_dff),
									.a14_in     (a14_in_dff),
									.a15_in     (a15_in_dff),
									.a16_in     (a16_in_dff),

									.b1_in      (b1_in_dff),
									.b2_in      (b2_in_dff),
									.b3_in      (b3_in_dff),
									.b4_in      (b4_in_dff),
									.b5_in      (b5_in_dff),
									.b6_in      (b6_in_dff),
									.b7_in      (b7_in_dff),
									.b8_in      (b8_in_dff),
									.b9_in      (b9_in_dff),
									.b10_in     (b10_in_dff),
									.b11_in     (b11_in_dff),
									.b12_in     (b12_in_dff),
									.b13_in     (b13_in_dff),
									.b14_in     (b14_in_dff),
									.b15_in     (b15_in_dff),
									.b16_in     (b16_in_dff),

									.res_out    (res_out)
									);

endmodule
