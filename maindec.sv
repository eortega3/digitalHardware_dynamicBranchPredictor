/*
 * maindec.sv
 *
 * Authors: David and Sarah Harris
 * Updated By: Sat Garcia
 *
 * Module that computes all non-ALU control signals.
 *
 * Note: You should NOT modify this file at all.
 */
module maindec(input  logic [5:0] op,
               output logic       mem_to_reg, dmem_write,
               output logic       branch, alu_src,
               output logic       reg_dest, reg_write,
               output logic       jump,
               output logic [1:0] alu_op);

	logic [8:0] controls;

	assign {reg_write, reg_dest, alu_src,
			  branch, dmem_write,
			  mem_to_reg, jump, alu_op} = controls;

	always_comb
	begin
		case(op)
			6'b000000: controls = 9'b110000010; // Rtype
			6'b100011: controls = 9'b101001000; // LW
			6'b101011: controls = 9'b001010000; // SW
			6'b000100: controls = 9'b000100001; // BEQ
			6'b001000: controls = 9'b101000000; // ADDI
			6'b000010: controls = 9'b000000100; // J
			default:   controls = 9'bxxxxxxxxx; // ???
		endcase
	end
endmodule
