/*
 * File: imem.sv
 *
 * Module for an asynchronous read, synchronous write memory module.
 * The contents of memory is initialized from imem.dat, which should
 * contain MIPS instructions in HEX format (one per line).
 *
 * @note This is NOT synthesizable. Only use this for simulation.
 */
module imem(input  logic [5:0]  addr,
            output logic [31:0] read_data);

	logic [31:0] RAM [0:63];

	initial
	  begin
		$readmemh("imem.dat", RAM); // load memory contents from file
	  end

	assign read_data = RAM[addr]; // word aligned
endmodule
