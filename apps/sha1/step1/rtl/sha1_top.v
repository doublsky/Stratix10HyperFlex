//======================================================================
//
// sha1_top.v
// -----------
// This is the top level wrapper for hyperflex pipelining
//
//
// Copyright (c) 2018 Tian Tan
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

`ifndef TTDSE
`define NUM_FRONT 1
`define NUM_BACK 0
`endif

// module sha1_top
module top
(
	input		CLK,
	input		RESETn,
	input		INIT,
	input		NEXT,
	input	[511:0]	BLOCK,
	output		READY,
	output	[159:0]	DIGEST,
	output		DIGEST_VALID
);

	wire		resetn, init, next, ready, digest_valid;
	wire	[511:0]	block;
	wire	[159:0]	digest;

	regchain #(`NUM_FRONT, 1) resetn_hp(CLK, RESETn, resetn);
	regchain #(`NUM_FRONT, 1) init_hp(CLK, INIT, init);
	regchain #(`NUM_FRONT, 1) next_hp(CLK, NEXT, next);
	regchain #(`NUM_FRONT, 512) block_hp(CLK, BLOCK, block);

	sha1_core core
	(
		.clk(CLK),
		.reset_n(resetn),
		.init(init),
		.next(next),
		.block(block),
		.ready(ready),
		.digest(digest),
		.digest_valid(digest_valid)
	);

	regchain #(`NUM_BACK, 1) ready_hp(CLK, ready, READY);
	regchain #(`NUM_BACK, 1) digest_valid_hp(CLK, digest_valid, DIGEST_VALID);
	regchain #(`NUM_BACK, 160) digest_hp(CLK, digest, DIGEST);

endmodule
