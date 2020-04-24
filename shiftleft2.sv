/*
 * Module whose output is the result of shifting the input left by 2.
 */
module shiftleft2#(parameter WIDTH=32)
		   (input  logic [WIDTH-1:0] a,
           	output logic [WIDTH-1:0] y);

	assign y = {a[WIDTH-3:0], 2'b00};
endmodule
