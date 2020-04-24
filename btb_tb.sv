/**
 * 
 * Testbench for branch_target_buffer module.
 *
 * @author Sat Garcia (sat@sandiego.edu)
 */

// TODO: update NUM_TESTS based on how many tests you have.
`define NUM_TESTS 14		

module btb_tb();
	logic clk, clear;
	logic [31:0] pc;
	logic update_en, update_outcome;
	logic [31:0] update_pc, update_target;
	logic [31:0] target;
	logic pred;

	branch_target_buffer btb(.clk, .clear, .pc, .update_en, .update_outcome,
								.update_pc, .update_target, .target, .pred);

	logic [139:0] test_vectors [`NUM_TESTS:0];
	integer vector_num;

	// create a clock with 10ps period
	initial
	  begin
		forever
		  begin
			clk = 0; #5; clk = 1; #5;
		  end
	  end

	initial
	  begin
	    // read in the test vectors
	  	$readmemh("btb.tv", test_vectors);

		// Clear the contents of the BTB
		@(negedge clk);
		clear = 1;
		@(negedge clk);
		clear = 0;

	  	for (vector_num = 0; vector_num < `NUM_TESTS; vector_num++)
		  begin
		  	// apply the inputs from the test vector
			pc = test_vectors[vector_num][139:108];
			update_en = test_vectors[vector_num][104];
			update_outcome = test_vectors[vector_num][100];
			update_pc = test_vectors[vector_num][99:68];
			update_target = test_vectors[vector_num][67:36];

			@(negedge clk);

			// check that outputs match our expected values from the test vector
			assert (target === test_vectors[vector_num][35:4]) 
				else $error("target: error in vector %d (expected %h, got %h)\n",
					vector_num, test_vectors[vector_num][35:4], target);
			assert (pred === test_vectors[vector_num][0]) 
				else $error("pred: error in vector %d: (expected %b, got %b)\n",
					vector_num, test_vectors[vector_num][0], pred);
		  	
		  end

		$display("\n\nCompleted %3d tests.\n\n", vector_num);
		$stop;
	  end
endmodule
