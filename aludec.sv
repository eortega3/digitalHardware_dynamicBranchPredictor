/*
 * aludec.sv
 *
 * Authors: David and Sarah Harris
 * Updated By: Sat Garcia
 *
 * Module that computes ALU control signals.
 *
 * Note: You should NOT modify this file at all.
 */
module aludec(input  logic [5:0] funct,
              input  logic [1:0] alu_op,
              output logic [2:0] alu_ctrl);

	always_comb
		case(alu_op)
			2'b00: alu_ctrl = 3'b010;  // add
			2'b01: alu_ctrl = 3'b110;  // sub
			default: // R-type
				case(funct)
					6'b100000: alu_ctrl = 3'b010; // ADD
					6'b100010: alu_ctrl = 3'b110; // SUB
					6'b100100: alu_ctrl = 3'b000; // AND
					6'b100101: alu_ctrl = 3'b001; // OR
					6'b101010: alu_ctrl = 3'b111; // SLT
					default:   alu_ctrl = 3'bxxx; // ???
				endcase
		endcase
endmodule
