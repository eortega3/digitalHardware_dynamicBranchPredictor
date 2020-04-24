/*
 * File: dmem.sv
 *
 * Module for an asynchronous read, synchronous write memory module.
 * The memory will have 64 words, each 32 bits in size.
 */
module dmem(input  logic        clk, write_en,
            input  logic [31:0] addr, write_data,
            output logic [31:0] read_data);

	logic [31:0] RAM[63:0];

	assign read_data = RAM[addr[31:2]]; // word aligned

	always @(posedge clk)
	  begin
		if (write_en)
			RAM[addr[31:2]] <= write_data;
	  end
endmodule
