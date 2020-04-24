/*
 * Module for a 3 input multiplexer.
 */
module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       sel, 
              output logic [WIDTH-1:0] y);

	always_comb
	begin
		case(sel)
			2'b00: y = d0;
			2'b01: y = d1;
			2'b10: y = d2;
			default: y = {WIDTH{1'bx}};
		endcase
	end
endmodule
