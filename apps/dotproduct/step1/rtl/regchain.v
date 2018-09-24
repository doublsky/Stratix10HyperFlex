// regshifter, used to add pipeline stages
// TT

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *)
module regchain
#(
	parameter NUM_STG = 8,
	parameter WIDTH = 32
)
(
	input			CLK,
	input	[WIDTH-1:0]	IN,
	output	[WIDTH-1:0]	OUT
);

	reg	[WIDTH-1:0]	tmp[0:NUM_STG];
	integer			i;

	always @(*)
		tmp[0] = IN;

	always @(posedge CLK)
		for (i = 0; i < NUM_STG; i = i + 1)
			tmp[i+1] <= tmp[i];

	assign OUT = tmp[NUM_STG];

endmodule
