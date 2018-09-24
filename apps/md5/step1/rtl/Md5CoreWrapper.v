/*
Copyright (C) 2018 Tian Tan

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

**********************************************************************

Md5Core Hyper Pipelining Wrapper

**********************************************************************

*/

// module Md5CoreWrapper
module top
(
	input		CLK,
	input	[511:0]	WB_IN,
	input	[31:0]	A_IN,
	input	[31:0]	B_IN,
	input	[31:0]	C_IN,
	input	[31:0]	D_IN,
	output	[31:0]	A_OUT,
	output	[31:0]	B_OUT,
	output	[31:0]	C_OUT,
	output	[31:0]	D_OUT
);

	wire	[511:0]	wb_in;
	wire	[31:0]	a_in, b_in, c_in, d_in;
	wire	[31:0]	a_out, b_out, c_out, d_out;

`ifdef TTDSE
	regchain #(`NUM_FRONT, 512) wb_in_hp(CLK, WB_IN, wb_in);
	regchain #(`NUM_FRONT, 32) a_in_hp(CLK, A_IN, a_in);
	regchain #(`NUM_FRONT, 32) b_in_hp(CLK, B_IN, b_in);
	regchain #(`NUM_FRONT, 32) c_in_hp(CLK, C_IN, c_in);
	regchain #(`NUM_FRONT, 32) d_in_hp(CLK, D_IN, d_in);
`else
	regchain #(47, 512) wb_in_hp(CLK, WB_IN, wb_in);
	regchain #(47, 32) a_in_hp(CLK, A_IN, a_in);
	regchain #(47, 32) b_in_hp(CLK, B_IN, b_in);
	regchain #(47, 32) c_in_hp(CLK, C_IN, c_in);
	regchain #(47, 32) d_in_hp(CLK, D_IN, d_in);
`endif

	Md5Core core
	(
		.clk(CLK),
		.wb(wb_in),
		.a0(a_in),
		.b0(b_in),
		.c0(c_in),
		.d0(d_in),
		.a64(a_out),
		.b64(b_out),
		.c64(c_out),
		.d64(d_out)
	);

`ifdef TTDSE
	regchain #(`NUM_BACK, 32) a_out_hp(CLK, a_out, A_OUT);
	regchain #(`NUM_BACK, 32) b_out_hp(CLK, b_out, B_OUT);
	regchain #(`NUM_BACK, 32) c_out_hp(CLK, c_out, C_OUT);
	regchain #(`NUM_BACK, 32) d_out_hp(CLK, d_out, D_OUT);
`else
	regchain #(0, 32) a_out_hp(CLK, a_out, A_OUT);
	regchain #(0, 32) b_out_hp(CLK, b_out, B_OUT);
	regchain #(0, 32) c_out_hp(CLK, c_out, C_OUT);
	regchain #(0, 32) d_out_hp(CLK, d_out, D_OUT);
`endif

endmodule
