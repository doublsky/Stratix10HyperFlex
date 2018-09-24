/////////////////////////////////////////////////////////////////////
////                                                             ////
////  DES Top Level Wrapper for HyperFlex                        ////
////                                                             ////
////  Author: Tian Tan                                           ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2018 Tian Tan                                 ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

// module des_wrapper
module top
(
	input		CLK,
	input	[63:0]	DESIN,
	input	[55:0]	KEY,
	input		DECRYPT,
	output	[63:0]	DESOUT
);

	wire	[63:0]	desout, desin;
	wire	[55:0]	key;
	wire		decrypt;

`ifdef TTDSE
	regchain #(`NUM_FRONT, 64) desin_hp(CLK, DESIN, desin);
	regchain #(`NUM_FRONT, 56) key_hp(CLK, KEY, key);
	regchain #(`NUM_FRONT, 1) decrypt_hp(CLK, DECRYPT, decrypt);
`else
	regchain #(19, 64) desin_hp(CLK, DESIN, desin);
	regchain #(19, 56) key_hp(CLK, KEY, key);
	regchain #(19, 1) decrypt_hp(CLK, DECRYPT, decrypt);
`endif

	des core
	(
		.desOut(desout),
		.desIn(desin),
		.key(key),
		.decrypt(decrypt),
		.clk(CLK)
	);

`ifdef TTDSE
	regchain #(`NUM_BACK, 64) desout_hp(CLK, desout, DESOUT);
`else
	regchain #(0, 64) desout_hp(CLK, desout, DESOUT);
`endif

endmodule
