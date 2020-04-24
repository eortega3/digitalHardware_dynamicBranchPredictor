/*
 * Hazard detection/correction module.
 *
 * @note: The starting code logic comes from Section 7.5.3 of the textbook.
 */
module hazard_unit( input logic [4:0]	rs_d, rt_d,
					input logic [4:0]	rs_x, rt_x, write_reg_x, 
					input logic [4:0]	rt_m,
					input logic [4:0]	write_reg_m, 
					input logic [4:0]	write_reg_w,
					input				branch_d, dmem_write_d,
					input				reg_write_x, mem_to_reg_x,
					input				reg_write_m, mem_to_reg_m,
					input				reg_write_w, mem_to_reg_w,
					output logic		stall_f, stall_d, flush_x,
					output logic		fwd_a_d, fwd_b_d,
					output logic [1:0]  fwd_a_x, fwd_b_x,
					output logic		fwd_m);

	logic lw_stall, branch_stall, stall;

	always_comb
	begin
		// Forwarding signals for instruction in the decode stage.
		fwd_a_d = (rs_d != 0  & reg_write_m & rs_d == write_reg_m);
		fwd_b_d = (rt_d != 0  & reg_write_m & rt_d == write_reg_m);

		// Forwarding signals for instruction in the execute stage.
		if (rs_x != 0 & reg_write_m & rs_x == write_reg_m) fwd_a_x = 2'b10;
		else if (rs_x != 0 & reg_write_w & rs_x == write_reg_w) fwd_a_x = 2'b01;
		else fwd_a_x = 2'b00;

		if (rt_x != 0 & reg_write_m & rt_x == write_reg_m) fwd_b_x = 2'b10;
		else if (rt_x != 0 & rt_x == write_reg_w & reg_write_w) fwd_b_x = 2'b01;
		else fwd_b_x = 2'b00;

		// Forwarding signals for instruction in the memory stage.
		fwd_m = (rt_m != 0 & mem_to_reg_w & reg_write_w & write_reg_w == rt_m);
		

		// Determine if we need to stall because of a data or control hazard
		lw_stall = ((rs_d == rt_x & rs_d != 0) 
						| (rt_d == rt_x & rt_d != 0 & ~dmem_write_d)) & mem_to_reg_x;
		branch_stall = (branch_d & reg_write_x & 
							(write_reg_x == rs_d & rs_d != 0 | write_reg_x == rt_d & rt_d != 0))
						| (branch_d & mem_to_reg_m & 
							(write_reg_m == rs_d & rs_d != 0 | write_reg_m == rt_d & rt_d != 0));
		stall = lw_stall | branch_stall;

		stall_f = stall;
		stall_d = stall;
		flush_x = stall;
	end

endmodule
