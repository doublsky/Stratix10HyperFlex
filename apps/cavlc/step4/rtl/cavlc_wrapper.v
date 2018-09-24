//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2018 Tian Tan                                  ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

// module cavlc_wrapper
module top
(
	input		CLK,
	input		RESETn,
	input		ENA,
	input		START,
	input	[0:15]	RBSP,
	input	signed	[5:0]	nC,
	input	[4:0]	MAX_COEFF_NUM,
	output	signed	[8:0]	COEFF_0,
	output	signed	[8:0]	COEFF_1,
	output	signed	[8:0]	COEFF_2,
	output	signed	[8:0]	COEFF_3,
	output	signed	[8:0]	COEFF_4,
	output	signed	[8:0]	COEFF_5,
	output	signed	[8:0]	COEFF_6,
	output	signed	[8:0]	COEFF_7,
	output	signed	[8:0]	COEFF_8,
	output	signed	[8:0]	COEFF_9,
	output	signed	[8:0]	COEFF_10,
	output	signed	[8:0]	COEFF_11,
	output	signed	[8:0]	COEFF_12,
	output	signed	[8:0]	COEFF_13,
	output	signed	[8:0]	COEFF_14,
	output	signed	[8:0]	COEFF_15,
	output	[4:0]	TOTALCOEFF,
	output	[4:0]	LEN_COMB,
	output		IDLE,
	output		VALID
);

`ifdef TTDSE
parameter NFRONT = `NUM_FRONT;
parameter NBACK = `NUM_BACK;
`else
// was 2 originally
parameter NFRONT = 3;
parameter NBACK = 1;
`endif


	wire		idle, valid;
	wire	[4:0]	resetn, ena, start;
	wire	[0:15]	rbsp;
	wire	signed	[5:0]	nc;
	wire	[4:0]	max_coeff_num, totalcoeff, len_comb;
	wire	signed	[8:0]	coeff_0, coeff_1, coeff_2, coeff_3,
				coeff_4, coeff_5, coeff_6, coeff_7,
				coeff_8, coeff_9, coeff_10, coeff_11,
				coeff_12, coeff_13, coeff_14, coeff_15;

	regchain #(NFRONT, 5) reset_hp(CLK, { 5{RESETn} }, resetn);
	regchain #(NFRONT, 5) ena_hp(CLK, {5{ENA}}, ena);
	regchain #(NFRONT, 5) start_hp(CLK, {5{START}}, start);
	regchain #(NFRONT, 16) rbsp_hp(CLK, RBSP, rbsp);
	regchain #(NFRONT, 6) nc_hp(CLK, nC, nc);
	regchain #(NFRONT, 5) max_coeff_num_hp(CLK, MAX_COEFF_NUM, max_coeff_num);
    
	cavlc_top core
	(
		.clk(CLK),
		.rst_n(resetn),
		.ena(ena),
		.start(start),
		.rbsp(rbsp),
		.nC(nc),
		.max_coeff_num(max_coeff_num),
		.coeff_0(coeff_0),
		.coeff_1(coeff_1),
		.coeff_2(coeff_2),
		.coeff_3(coeff_3),
		.coeff_4(coeff_4),
		.coeff_5(coeff_5),
		.coeff_6(coeff_6),
		.coeff_7(coeff_7),
		.coeff_8(coeff_8),
		.coeff_9(coeff_9),
		.coeff_10(coeff_10),
		.coeff_11(coeff_11),
		.coeff_12(coeff_12),
		.coeff_13(coeff_13),
		.coeff_14(coeff_14),
		.coeff_15(coeff_15),
		.TotalCoeff(totalcoeff),
		.len_comb(len_comb),
		.idle(idle),
		.valid(valid)
	);

	regchain #(NBACK, 9) coeff_0_hp(CLK, coeff_0, COEFF_0);
	regchain #(NBACK, 9) coeff_1_hp(CLK, coeff_1, COEFF_1);
	regchain #(NBACK, 9) coeff_2_hp(CLK, coeff_2, COEFF_2);
	regchain #(NBACK, 9) coeff_3_hp(CLK, coeff_3, COEFF_3);
	regchain #(NBACK, 9) coeff_4_hp(CLK, coeff_4, COEFF_4);
	regchain #(NBACK, 9) coeff_5_hp(CLK, coeff_5, COEFF_5);
	regchain #(NBACK, 9) coeff_6_hp(CLK, coeff_6, COEFF_6);
	regchain #(NBACK, 9) coeff_7_hp(CLK, coeff_7, COEFF_7);
	regchain #(NBACK, 9) coeff_8_hp(CLK, coeff_8, COEFF_8);
	regchain #(NBACK, 9) coeff_9_hp(CLK, coeff_9, COEFF_9);
	regchain #(NBACK, 9) coeff_10_hp(CLK, coeff_10, COEFF_10);
	regchain #(NBACK, 9) coeff_11_hp(CLK, coeff_11, COEFF_11);
	regchain #(NBACK, 9) coeff_12_hp(CLK, coeff_12, COEFF_12);
	regchain #(NBACK, 9) coeff_13_hp(CLK, coeff_13, COEFF_13);
	regchain #(NBACK, 9) coeff_14_hp(CLK, coeff_14, COEFF_14);
	regchain #(NBACK, 9) coeff_15_hp(CLK, coeff_15, COEFF_15);
	regchain #(NBACK, 5) totalcoeff_hp(CLK, totalcoeff, TOTALCOEFF);
	regchain #(NBACK, 5) len_comb_hp(CLK, len_comb, LEN_COMB);
	regchain #(NBACK, 1) idle_hp(CLK, idle, IDLE);
	regchain #(NBACK, 1) valid_hp(CLK, valid, VALID);

endmodule
