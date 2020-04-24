/*
 * Module for a resetable D flip-flop.
 */
module flopr #(parameter WIDTH = 8)
              (input  logic             clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

	always_ff @(posedge clk)
	begin
		if (reset) q <= 0;
		else       q <= d;
	end
endmodule

/*
 * Module for a resetable D flip-flop with an additional enable input.
 */
module flopenr #(parameter WIDTH = 8)
                (input  logic             clk, reset,
                 input  logic             en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);
 
	always_ff @(posedge clk)
	begin
		if      (reset) q <= 0;
		else if (en)    q <= d;
	end
endmodule
