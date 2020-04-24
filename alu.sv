/*
 * alu.sv
 *
 * Module for an ALU with support for the following operations: AND, OR, ADD,
 * XOR, NOR, SUB, and SLT.
 */
module alu #(parameter WIDTH=16)
			(input logic [WIDTH-1:0] a, b, 
			 input logic [2:0] f,
			 output logic [WIDTH-1:0] y,
			 output logic zero, carry, overflow);

logic [WIDTH:0] sum, diff;

always_comb
  begin
	sum = a + b;
	diff = a - b;

	// compute the carry and overflow outputs
	if (f === 3'b010)
	  begin
		overflow = (a[WIDTH-1] ~^ b[WIDTH-1]) & (a[WIDTH-1] ^ sum[WIDTH-1]);
		carry = sum[WIDTH];
	  end
	else if (f === 3'b110 | f === 3'b111)
	  begin
		overflow = (a[WIDTH-1] ^ b[WIDTH-1]) & (a[WIDTH-1] ^ diff[WIDTH-1]);
		carry = diff[WIDTH];
	  end
	else
	  begin
		overflow = 0;
		carry = 0;
	  end

	// compute the y output
	casez (f)
		3'b000: // and
			y = a & b;
		3'b001: // or
			y = a | b;
		3'b010: // add
			y = sum[WIDTH-1:0];
		3'b100: // xor
			y = a ^ b;
		3'b101: // nor
			y = ~(a | b);
		3'b110: // sub
			y = diff[WIDTH-1:0];
		3'b111: // slt
		  begin
			y = { {(WIDTH-1){1'b0}}, diff[WIDTH-1] };
		  end
		default: // 3'b011 is unused
		  begin
			y = 0;
		  end
	endcase

	// compute the zero output
	if (y === 0)
		zero = 1;
	else
		zero = 0;
  end

endmodule
