/////////////////////////////////////////////////////////////////////
////                                                             ////
////  DES                                                        ////
////  DES Top Level module                                       ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
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

module des
(
	output	reg	[63:0]	desOut,
	input	[63:0]	desIn,
	input	[55:0]	key,
	input		decrypt,
	input		clk
);

wire	[1:64]	IP, FP;
(* altera_attribute = "-name DONT_MERGE_REGISTER ON" *) wire [1:64] IP_dup;
reg	[63:0]	desIn_r;
(* altera_attribute = "-name DONT_MERGE_REGISTER ON" *) reg	[63:0]	desIn_r_dup;
reg	[55:0]	key_r;
reg		decrypt_r;	// added by TT
reg	[1:32]	L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15;
reg	[1:32]	R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15;
(* altera_attribute = "-name DONT_MERGE_REGISTER OFF" *) reg	[1:32]	R0_dup, R1_dup, R2_dup, R3_dup, R4_dup, R5_dup, R6_dup, R7_dup, R8_dup, R9_dup, R10_dup, R11_dup, R12_dup, R13_dup, R14_dup, R15_dup;
wire	[1:32]	out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15;
wire	[1:48]	K1, K2, K3, K4, K5, K6, K7, K8, K9;
wire	[1:48]	K10, K11, K12, K13, K14, K15, K16;

/* for hyper pipeline
wire	[63:0]	desIn_dff;
wire	[55:0]	key_dff;
wire		decrypt_dff;
reg	[63:0]	desOut_dff;

regshf #(16, 64) desIn_hp(clk, desIn, desIn_dff);
regshf #(16, 56) key_hp(clk, key, key_dff);
regshf #(16, 1) decrypt_hp(clk, decrypt, decrypt_dff);
regshf #(16, 64) desOut_hp(clk, desOut_dff, desOut);*/

// Register the 56 bit key
always @(posedge clk)
	key_r <= key;

// Register the 64 bit input
always @(posedge clk) begin
	desIn_r <= desIn;
	desIn_r_dup <= desIn;
end

// Register decrypt bit
always @(posedge clk)
	decrypt_r <= decrypt;

// XOR 32 bit out15 with 32 bit L14         ( FP  1:32 )
//    then concatinate the 32 bit R14 value ( FP 33:64 )
//       This value ( FP 1:64 ) is then registered by the desOut[63:0] register
assign FP = { (out15 ^ L14), R14};

// Key schedule provides a linear means of intermixing the 56 bit key to form a
//   different 48 bit key for each of the 16 bit rounds
key_sel uk(
	.clk(		clk		),
	.K(		key_r		),
	.decrypt(	decrypt_r	),
	.K1(		K1		),
	.K2(		K2		),
	.K3(		K3		),
	.K4(		K4		),
	.K5(		K5		),
	.K6(		K6		),
	.K7(		K7		),
	.K8(		K8		),
	.K9(		K9		),
	.K10(		K10		),
	.K11(		K11		),
	.K12(		K12		),
	.K13(		K13		),
	.K14(		K14		),
	.K15(		K15		),
	.K16(		K16		)
	);

// 16 CRP blocks
crp u0( .P(out0), .R(IP[33:64]), .K_sub(K1) );
crp u1( .P(out1), .R(R0), .K_sub(K2) );
crp u2( .P(out2), .R(R1), .K_sub(K3) );
crp u3( .P(out3), .R(R2), .K_sub(K4) );
crp u4( .P(out4), .R(R3), .K_sub(K5) );
crp u5( .P(out5), .R(R4), .K_sub(K6) );
crp u6( .P(out6), .R(R5), .K_sub(K7) );
crp u7( .P(out7), .R(R6), .K_sub(K8) );
crp u8( .P(out8), .R(R7), .K_sub(K9) );
crp u9( .P(out9), .R(R8), .K_sub(K10) );
crp u10( .P(out10), .R(R9), .K_sub(K11) );
crp u11( .P(out11), .R(R10), .K_sub(K12) );
crp u12( .P(out12), .R(R11), .K_sub(K13) );
crp u13( .P(out13), .R(R12), .K_sub(K14) );
crp u14( .P(out14), .R(R13), .K_sub(K15) );
crp u15( .P(out15), .R(R14), .K_sub(K16) );

// 32 bit L0 get upper 32 bits of IP
always @(posedge clk)
        L0 <= IP_dup[33:64];

// 32 bit R0 gets lower 32 bits of IP XOR'd with 32 bit out0
always @(posedge clk) begin
        R0 <= IP_dup[01:32] ^ out0;
        R0_dup <= IP_dup[01:32] ^ out0;
end

// 32 bit L1 gets 32 bit R0
always @(posedge clk)
        L1 <= R0_dup;

// 32 bit R1 gets 32 bit L0 XOR'd with 32 bit out1
always @(posedge clk) begin
        R1 <= L0 ^ out1;
        R1_dup <= L0 ^ out1;
end

// 32 bit L2 gets 32 bit R1
always @(posedge clk)
        L2 <= R1_dup;

// 32 bit R2 gets 32 bit L1 XOR'd with 32 bit out2
always @(posedge clk) begin
        R2 <= L1 ^ out2;
        R2_dup <= L1 ^ out2;
end

always @(posedge clk)
        L3 <= R2_dup;

always @(posedge clk) begin
        R3 <= L2 ^ out3;
        R3_dup <= L2 ^ out3;
end

always @(posedge clk)
        L4 <= R3_dup;

always @(posedge clk) begin
        R4 <= L3 ^ out4;
        R4_dup <= L3 ^ out4;
end

always @(posedge clk)
        L5 <= R4_dup;

always @(posedge clk) begin
        R5 <= L4 ^ out5;
				R5_dup <= L4 ^ out5;
end

always @(posedge clk)
        L6 <= R5_dup;

always @(posedge clk) begin
        R6 <= L5 ^ out6;
        R6_dup <= L5 ^ out6;
end

always @(posedge clk)
        L7 <= R6_dup;

always @(posedge clk) begin
        R7 <= L6 ^ out7;
        R7_dup <= L6 ^ out7;
end

always @(posedge clk)
        L8 <= R7_dup;

always @(posedge clk) begin
        R8 <= L7 ^ out8;
        R8_dup <= L7 ^ out8;
end

always @(posedge clk)
        L9 <= R8_dup;

always @(posedge clk) begin
        R9 <= L8 ^ out9;
        R9_dup <= L8 ^ out9;
end

always @(posedge clk)
        L10 <= R9_dup;

always @(posedge clk)
begin
        R10 <= L9 ^ out10;
				R10_dup <= L9 ^ out10;
end

always @(posedge clk)
        L11 <= R10_dup;

always @(posedge clk) begin
        R11 <= L10 ^ out11;
        R11_dup <= L10 ^ out11;
end

always @(posedge clk)
        L12 <= R11_dup;

always @(posedge clk) begin
        R12 <= L11 ^ out12;
        R12_dup <= L11 ^ out12;
end

always @(posedge clk)
        L13 <= R12_dup;

always @(posedge clk) begin
        R13 <= L12 ^ out13;
        R13_dup <= L12 ^ out13;
end

always @(posedge clk)
        L14 <= R13_dup;

always @(posedge clk) begin
        R14 <= L13 ^ out14;
        R14_dup <= L13 ^ out14;
end

// 32 bit L15 gets 32 bit R14
always @(posedge clk)
        L15 <= R14_dup;

// 32 bit R15 gets 32 bit L14 XOR'd with 32 bit out15
always @(posedge clk)
        R15 <= L14 ^ out15;

// Perform the initial permutationi with the registerd desIn
assign IP[1:64] = {	desIn_r[06], desIn_r[14], desIn_r[22], desIn_r[30], desIn_r[38], desIn_r[46],
			desIn_r[54], desIn_r[62], desIn_r[04], desIn_r[12], desIn_r[20], desIn_r[28],
			desIn_r[36], desIn_r[44], desIn_r[52], desIn_r[60], desIn_r[02], desIn_r[10],
			desIn_r[18], desIn_r[26], desIn_r[34], desIn_r[42], desIn_r[50], desIn_r[58],
			desIn_r[00], desIn_r[08], desIn_r[16], desIn_r[24], desIn_r[32], desIn_r[40],
			desIn_r[48], desIn_r[56], desIn_r[07], desIn_r[15], desIn_r[23], desIn_r[31],
			desIn_r[39], desIn_r[47], desIn_r[55], desIn_r[63], desIn_r[05], desIn_r[13],
			desIn_r[21], desIn_r[29], desIn_r[37], desIn_r[45], desIn_r[53], desIn_r[61],
			desIn_r[03], desIn_r[11], desIn_r[19], desIn_r[27], desIn_r[35], desIn_r[43],
			desIn_r[51], desIn_r[59], desIn_r[01], desIn_r[09], desIn_r[17], desIn_r[25],
			desIn_r[33], desIn_r[41], desIn_r[49], desIn_r[57] };

assign IP_dup[1:64] = {	desIn_r_dup[06], desIn_r_dup[14], desIn_r_dup[22], desIn_r_dup[30], desIn_r_dup[38], desIn_r_dup[46],
			desIn_r_dup[54], desIn_r_dup[62], desIn_r_dup[04], desIn_r_dup[12], desIn_r_dup[20], desIn_r_dup[28],
			desIn_r_dup[36], desIn_r_dup[44], desIn_r_dup[52], desIn_r_dup[60], desIn_r_dup[02], desIn_r_dup[10],
			desIn_r_dup[18], desIn_r_dup[26], desIn_r_dup[34], desIn_r_dup[42], desIn_r_dup[50], desIn_r_dup[58],
			desIn_r_dup[00], desIn_r_dup[08], desIn_r_dup[16], desIn_r_dup[24], desIn_r_dup[32], desIn_r_dup[40],
			desIn_r_dup[48], desIn_r_dup[56], desIn_r_dup[07], desIn_r_dup[15], desIn_r_dup[23], desIn_r_dup[31],
			desIn_r_dup[39], desIn_r_dup[47], desIn_r_dup[55], desIn_r_dup[63], desIn_r_dup[05], desIn_r_dup[13],
			desIn_r_dup[21], desIn_r_dup[29], desIn_r_dup[37], desIn_r_dup[45], desIn_r_dup[53], desIn_r_dup[61],
			desIn_r_dup[03], desIn_r_dup[11], desIn_r_dup[19], desIn_r_dup[27], desIn_r_dup[35], desIn_r_dup[43],
			desIn_r_dup[51], desIn_r_dup[59], desIn_r_dup[01], desIn_r_dup[09], desIn_r_dup[17], desIn_r_dup[25],
			desIn_r_dup[33], desIn_r_dup[41], desIn_r_dup[49], desIn_r_dup[57] };

// Perform the final permutation
always @(posedge clk)
	desOut <= {	FP[40], FP[08], FP[48], FP[16], FP[56], FP[24], FP[64], FP[32],
			FP[39], FP[07], FP[47], FP[15], FP[55], FP[23], FP[63], FP[31],
			FP[38], FP[06], FP[46], FP[14], FP[54], FP[22], FP[62], FP[30],
			FP[37], FP[05], FP[45], FP[13], FP[53], FP[21], FP[61], FP[29],
			FP[36], FP[04], FP[44], FP[12], FP[52], FP[20], FP[60], FP[28],
			FP[35], FP[03], FP[43], FP[11], FP[51], FP[19], FP[59], FP[27],
			FP[34], FP[02], FP[42], FP[10], FP[50], FP[18], FP[58], FP[26],
			FP[33], FP[01], FP[41], FP[09], FP[49], FP[17], FP[57], FP[25] };


endmodule
