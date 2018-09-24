/*
 * Copyright 2018, Tian Tan
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

// module aes_256_wrapper
module top
(
	input		CLK,
	input	[127:0]	STATE,
	input	[255:0]	KEY,
	output	[127:0]	OUT
);

	wire	[127:0]	state;
	wire	[255:0]	key;
	wire	[127:0]	out;

`ifdef TTDSE
	regchain #(`NUM_FRONT, 128) state_hp(CLK, STATE, state);
	regchain #(`NUM_FRONT, 256) key_hp(CLK, KEY, key);
`else
	regchain #(0, 128) state_hp(CLK, STATE, state);

	regchain #(0, 256) key_hp(CLK, KEY, key);
`endif

	aes_256 core
	(
		.clk(CLK),
		.state(state),
		.key(key),
		.out(out)
	);

`ifdef TTDSE
	regchain #(`NUM_BACK, 128) out_hp(CLK, out, OUT);
`else
	regchain #(0, 128) out_hp(CLK, out, OUT);
`endif

endmodule
