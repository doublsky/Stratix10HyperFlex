/*
 * Copyright 2012, Homer Hsing <homer.hsing@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

`timescale 1ns / 1ps

`define CLK_P (1000.00/466.2)
`define LATENCY 29

module test_aes_256;

	// Inputs
	reg clk;
	reg [127:0] state;
	reg [255:0] key;

	// Outputs
	wire [127:0] out;

	reg [127:0] plaintext[0:499];
	reg [255:0] keytext[0:499];
	reg [127:0] ciphertext[0:499];

	integer i, j;

	initial
	begin
		$readmemh("plaintext.txt", plaintext);
		$readmemh("key.txt", keytext);
		$readmemh("cipher.txt", ciphertext);
	end

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.state(state), 
		.key(key), 
		.out(out)
	);

	initial begin
		clk = 0;
		state = 0;
		key = 0;

		#(10*`CLK_P);
        /*
         * TIMEGRP "key" OFFSET = IN 6.4 ns VALID 6 ns AFTER "clk" HIGH;
         * TIMEGRP "state" OFFSET = IN 6.4 ns VALID 6 ns AFTER "clk" HIGH;
         * TIMEGRP "out" OFFSET = OUT 2.2 ns BEFORE "clk" HIGH;
         */
	for (i = 0; i < 500; i = i + 1)
	begin
		@(posedge clk)
		begin
			state = plaintext[i];
			key = keytext[i];
		end
	end
        /*@ (negedge clk);
        #0.0;
        state = 128'h3243f6a8885a308d313198a2e0370734;
        key   = 256'h2b7e151628aed2a6abf7158809cf4f3c_762e7160f38b4da56a784d9045190cfe;
        #(`CLK_P);
        state = 128'h00112233445566778899aabbccddeeff;
        key   = 256'h000102030405060708090a0b0c0d0e0f_101112131415161718191a1b1c1d1e1f;
        #(`CLK_P);
        state = 128'h7e4c7e6a48b32551943a5384909931fb;
        key   = 256'hee445732e5e9bc9bf508cf25535ee2e9b2d2aa6054fa85d0d4e835d898648266;
        #(`CLK_P);
        state = 128'h7587a8d98a5a70652980623fa57cde44;
        key   = 256'h59574e89acad51d3ec809586f185e417f1660c8cbb7cc07c66e4fc22630b61da;
        #(`CLK_P);
        state = 128'h83bc62af3a2f69b41627afff1f07ac93;
        key   = 256'h34116db84fef8d2d63b6d489e4c7c135d8678324ec1296edd80239459df80ae5;
        #(`CLK_P);
        state = 128'ha5d109771ff4c196ca82aa9590ae496c;
        key   = 256'hba6816cdf2a67aac99caa8b42a37c2b261cf08cb5e80c3c9da28036e196ad74c;
        #(`CLK_P);
        state = 128'h99d3d2ed008b794cd49a5622e4fed118;
        key   = 256'ha345cdd9ff01c69115d92ac9ee2f4301618702159e62137c8172fc69a66571cd;
        #(`CLK_P);
        state = 128'h0;
        key   = 256'h0;
        #(`CLK_P*28);
        if (out !== 128'h1a6e6c2c_662e7da6_501ffb62_bc9e93f3)
          begin $display("E"); $finish; end
        #(`CLK_P);
        if (out !== 128'h8ea2b7ca_516745bf_eafc4990_4b496089)
          begin $display("E"); $finish; end
        #(`CLK_P);
        if (out !== 128'h6ac83d115d0102158a6de49df3cf5de0)
          begin $display("E"); $finish; end
        #(`CLK_P);
        if (out !== 128'h345e7e819c25eaff48a96746ab6b67f8)
          begin $display("E"); $finish; end
        #(`CLK_P);
        if (out !== 128'h1da1f23a60591654577ffc2ed292c453)
          begin $display("E"); $finish; end
        #(`CLK_P);
        if (out !== 128'h8dec662a9414a4ef8a61c9de453de989)
          begin $display("E"); $finish; end
        #(`CLK_P);
        if (out !== 128'hb249b824399d75da858d88ea795d20a2)
          begin $display("E"); $finish; end
        $display("Good.");
        $finish;*/
	end

	initial
	begin
		#(10*`CLK_P)
		#((`LATENCY+1)*`CLK_P)
		for (j = 0; j < 500; j = j + 1)
		begin
			@(posedge clk)
			begin
				if (out !== ciphertext[j])
				begin
					$display("Error @ %d", j+1);
					$error;
                    $stop;
				end
			end
		end
		$display("All good!");
		$finish;
	end

    initial
    begin
	$dumpfile("aes_256.vcd");
	$dumpvars(0, uut);
    end

    always #(`CLK_P/2) clk = ~clk;
endmodule

