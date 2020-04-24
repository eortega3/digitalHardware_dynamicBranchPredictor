/*
 * Module to check equality of 2 inputs.
 */
module eq#(parameter WIDTH=32)
			 (input  logic [WIDTH-1:0] a, b,
              output logic equal);

	assign equal = (a == b) ? 1 : 0;
endmodule
