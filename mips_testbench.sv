/*
 * mips_testbench.sv
 *
 * Author: David Harris
 *
 * Testbench for MIPS processor.
 */

module testbench();

	logic        clk;
	logic        reset;

	logic [31:0] write_data, data_addr;
	logic        mem_write;

	// instantiate device to be tested
	top dut(.clk, .reset, .dmem_write_data(write_data), 
			.dmem_addr(data_addr), .dmem_write(mem_write));
	  
	// initialize test
	initial
	begin
		reset = 1; 
		#7; 
		reset = 0;
	end

	// generate clock to sequence tests
	initial
		forever
		begin
			clk = 0; #5; clk = 1; #5;
		end

	// check that 7 gets written to address 84
	always@(negedge clk)
	begin
		if(mem_write) begin
			if(data_addr === 84 & write_data === 7)
			 begin
				$display("Simulation succeeded!");
				$stop;
			 end
			else if (data_addr !== 80)
			 begin
				$display("Simulation failed! Incorrect result: %d (should be 7)", write_data);
				$stop;
			 end
		end
	end
endmodule
