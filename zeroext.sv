/*
 * Module that zero-extends a value.
 */
module zeroext(input  logic [15:0] a,
               output logic [31:0] y);
              
	assign y = {{16{1'b0}}, a};
endmodule
