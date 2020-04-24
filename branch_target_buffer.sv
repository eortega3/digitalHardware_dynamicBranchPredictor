/**
 *
 * SystemVerilog module for a branch target buffer (BTB).
 * This BTB will contain 4 entries and implement a 2-bit dynamic branch
 * predictor.
 *
 * @author Partner 1's name Eduardo Ortega
 * @author Partner 2's name Nick Loyd
 *
 */
module branch_target_buffer(input logic clk, clear,
							input logic [31:0] pc,
							input logic update_en, update_outcome,
							input logic [31:0] update_pc, update_target,
							output logic [31:0] target,
							output logic pred);

	typedef struct packed {
		logic        valid;
		logic [31:0] pc;
		logic [31:0] target;
		logic [1:0]  state;
	} btb_entry;

	btb_entry entries [3:0]; // create 4 btb_entry structs

	logic [1:0] next_state;

	always_ff @ (posedge clk)
	  begin
		if (clear)
		  begin
			entries[0].valid <= 0;
			entries[1].valid <= 0;
			entries[2].valid <= 0;
			entries[3].valid <= 0;
		  end
		else if (update_en)
		  begin
		  	// TODO: update the entry selected by update_pc
			entries[update_pc[3:2]].pc <= update_pc;
			entries[update_pc[3:2]].target <= update_target;
			entries[update_pc[3:2]].valid <= 1;
			entries[update_pc[3:2]].state <= next_state;
		  end
	  end

	// Compute next_state for the selected BTB entry.
	// This will be used when update_en is asserted.
	always_comb
	  begin
	  	// TODO: implement logic for calculating next_state
		if( entries[update_pc[3:2]].valid == 1 && entries[update_pc[3:2]].pc == update_pc )
		begin 
			case( entries[update_pc[3:2]].state )
			2'b11: if( ~update_outcome ) next_state = 2'b10;
			else next_state = 2'b11;

			2'b10: if( update_outcome ) next_state = 2'b11;
		   	else next_state = 2'b01;

			2'b01: if( update_outcome ) next_state = 2'b10;
		   	else next_state = 2'b00;

			2'b00: if( update_outcome ) next_state = 2'b01;
			else next_state = 2'b00;
			endcase
		end
		else
		begin
			if( update_outcome ) next_state = 2'b10;
			else next_state = 2'b01;
		end
	   end

	// Compute the outputs (target and pred) of the circuit.
	always_comb
	  begin
	    // TODO: implement logic for calculating outputs
	    	target = ( entries[pc[3:2]].valid & ( pc == entries[pc[3:2]].pc ) ) ? entries[pc[3:2]].target : pc;
		pred = entries[pc[3:2]].state[1] & ( entries[pc[3:2]].valid & ( pc == entries[pc[3:2]].pc ));
	  end


endmodule
