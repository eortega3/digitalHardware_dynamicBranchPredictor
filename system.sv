/*
 * system.sv
 * Author: David M. Harris
 * Updated By: Sat Garcia
 * Top level system with 1 32-bit MIPS core, data memory, and instruction memory
 */

module top(input         clk, reset, 
           output [31:0] dmem_write_data, dmem_addr, 
           output        dmem_write);

	wire [31:0] pc, instr, dmem_read_data;
	  
	// instantiate processor and memories
	mips_core core(.clk, .reset, .pc, .instr_f(instr), .dmem_write, .alu_out(dmem_addr), 
					.dmem_write_data, .dmem_read_data);

	imem imem(.addr(pc[7:2]), .read_data(instr));

	dmem dmem(.clk, .write_en(dmem_write & ~reset), .addr(dmem_addr), 
				.write_data(dmem_write_data),
				.read_data(dmem_read_data));

endmodule
