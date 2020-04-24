/*
 * core_datapath.sv
 *
 * Authors: David and Sarah Harris
 * Updated By: Sat Garcia
 *
 * Module that implements datapath component of MIPS core.
 */

module core_datapath(input  logic   clk, reset,
                	input  logic        mem_to_reg_w, pc_src_d,
                	input  logic        alu_src_x, reg_dest_x,
                	input  logic        reg_write_w, jump_d,
                	input  logic [2:0]  alu_ctrl_x,
			input  logic	    stall_f, stall_d, flush_x,
			input  logic	    fwd_a_d, fwd_b_d,
			input  logic [1:0]  fwd_a_x, fwd_b_x,
			input  logic	    fwd_m, update_en,
                	output logic        eq_d, pred_d,
			input logic 	    mispred_d, reset_d,
                	output logic [31:0] pc,
                	input  logic [31:0] instr_f,
                	output logic [31:0] instr_d,
                	output logic [31:0] alu_out_m, dmem_write_data_m,
                	input  logic [31:0] dmem_read_data_m,
			output logic [4:0] write_reg_x, write_reg_m, write_reg_w,
			output logic [4:0] rs_d, rt_d, rs_x, rt_x, rt_m
			);

	// Fetch (F) stage signals
	logic [31:0] pc_plus_4_f;
	logic [31:0] pc_next_br_f;
	logic [31:0] pc_next_f;
	logic [31:0] pc_pred_f;
	logic [31:0] target;
	//logic update_en;

	// Decode (D) stage signals
	logic [31:0] sign_imm_d;
	logic [31:0] sign_imm_shifted_d;
	logic [31:0] pc_plus_4_d;
	logic [31:0] srca_d;
	logic [31:0] dmem_write_data_d;
	logic [31:0] pc_branch_d;
	logic [31:0] pc_fixed_d;
	logic [31:0] rd1_out, rd2_out;
	logic [31:0] pc_d;
	logic [4:0] rd_d;
	

	// Execute (X) stage signals
	logic [31:0] sign_imm_x, srca_x, srcb_x;
	logic [4:0] rd_x;
	logic [31:0] alu_out_x, dmem_write_data_x;
	logic zero_x, carry_x, overflow_x;
	logic [31:0] alua_x, foo_x;

	// Memory (M) stage signals
	logic [31:0] dwd_tmp_m;
	
	// Writeback (W) stage signals
	logic [31:0] alu_out_w, dmem_read_data_w, result_w;


	// Fetch (F) stage datapath components
	
	flopenr #(32) pcreg(.clk, .reset, .en(~stall_f), .d(pc_next_f), .q(pc));

	adder #(32) pcadd1(.a(pc), .b(32'b100), .y(pc_plus_4_f));

	mux2 #(32) pcbrmux(.d0(pc_pred_f), .d1(pc_fixed_d), .sel(mispred_d),
						  .y(pc_next_br_f));

	mux2 #(32) pcmux(.d0(pc_next_br_f), 
					  .d1({pc_plus_4_d[31:28], instr_d[25:0], 2'b00}), 
					  .sel(jump_d), .y(pc_next_f));
	
	branch_target_buffer b_t_b(.clk, .clear(reset), .pc, .update_en, 
						.update_outcome(pc_src_d), .update_pc(pc_d), .update_target(pc_branch_d), 
						.target, .pred(pred_f));
	
	mux2 #(32) mux_pc_pred(.d0(pc_plus_4_f), .d1(target), .sel(pred_f), .y(pc_pred_f));

	// Fetch-to-Decode Inter-stage Registers
	flopenr #(32) pc_plus_4_reg_f_d(.clk, .reset(reset | reset_d), .en(~stall_d), .d(pc_plus_4_f), .q(pc_plus_4_d));
	flopenr #(32) instr_reg_f_d(.clk, .reset(reset | reset_d), .en(~stall_d), .d(instr_f), .q(instr_d));
	flopenr #(32) pc_reg_f_d(.clk, .reset(reset | reset_d), .en(~stall_d), .d(pc), .q(pc_d));
	flopenr #(1) pred_reg_f_d(.clk, .reset(reset | reset_d), .en(~stall_d), .d(pred_f), .q(pred_d));


	// Decode (D) stage datapath components 

	// Note: reg file also used WB
	regfile #(32,32) rf(.clk(~clk), .we3(reg_write_w & ~reset), 
						.ra1(instr_d[25:21]), .ra2(instr_d[20:16]),
						.rd1(rd1_out), .rd2(rd2_out),
						.wa3(write_reg_w), .wd3(result_w)
					);

	mux2 #(32) srca_mux_d(.d0(rd1_out), .d1(alu_out_m), .sel(fwd_a_d),
							.y(srca_d));
	mux2 #(32) srcb_mux_d(.d0(rd2_out), .d1(alu_out_m), .sel(fwd_b_d),
							.y(dmem_write_data_d));

	signext se(.a(instr_d[15:0]), .y(sign_imm_d));

	eq #(32) equals(.a(srca_d), .b(dmem_write_data_d), .equal(eq_d));

	shiftleft2 #(32) immsh(.a(sign_imm_d), .y(sign_imm_shifted_d));

	adder #(32) pcadd2(.a(pc_plus_4_d), .b(sign_imm_shifted_d), .y(pc_branch_d));

	mux2 #(32) pc_fix_mux(.d0(pc_branch_d), .d1(pc_plus_4_d), .sel(pred_d & mispred_d), .y(pc_fixed_d));

	assign rs_d = instr_d[25:21];
	assign rt_d = instr_d[20:16];
	assign rd_d = instr_d[15:11];

	// Decode-to-Execute Inter-stage Registers
	flopr #(32) srca_reg_d_x(.clk, .reset(reset | flush_x), .d(srca_d), .q(srca_x));
	flopr #(32) dmem_write_data__regd_x(.clk, .reset(reset | flush_x), .d(dmem_write_data_d), .q(foo_x));
	flopr #(5) rs_reg_d_x(.clk, .reset(reset | flush_x), .d(rs_d), .q(rs_x));
	flopr #(5) rt_reg_d_x(.clk, .reset(reset | flush_x), .d(rt_d), .q(rt_x));
	flopr #(5) rd_reg_d_x(.clk, .reset(reset | flush_x), .d(rd_d), .q(rd_x));
	flopr #(32) sign_imm_reg_d_x(.clk, .reset, .d(sign_imm_d), .q(sign_imm_x));

	

	// Execute (X) stage datapath components
	mux2 #(5) wrmux(.d0(rt_x), .d1(rd_x), .sel(reg_dest_x), 
					.y(write_reg_x));

	mux3 #(32) fwdaxmux(.d0(srca_x), .d1(result_w), .d2(alu_out_m),
						.sel(fwd_a_x), .y(alua_x));
	mux3 #(32) fwdbxmux(.d0(foo_x), .d1(result_w), .d2(alu_out_m),
						.sel(fwd_b_x), .y(dmem_write_data_x));

	// selects if alu's 2nd input is immediate or register
	mux2 #(32) srcbmux(.d0(dmem_write_data_x), .d1(sign_imm_x),
						.sel(alu_src_x), .y(srcb_x));

	alu #(32) alu(.a(alua_x), .b(srcb_x), .f(alu_ctrl_x), .y(alu_out_x),
					.zero(zero), .carry(carry_x), .overflow(overflow_x));

	// Execute-to-Memory Inter-stage Registers
	flopr #(32) alu_out_reg_x_m(.clk, .reset, .d(alu_out_x), .q(alu_out_m));
	flopr #(32) dmem_write_data_reg_x_m(.clk, .reset, .d(dmem_write_data_x), 
										.q(dwd_tmp_m));
	flopr #(5) rt_reg_x_m(.clk, .reset, .d(rt_x), .q(rt_m));

	mux2 #(32) fwdmemmux(.d0(dwd_tmp_m), .d1(result_w), .sel(fwd_m),
							.y(dmem_write_data_m));



	// "A foolish consistency is the hobgoblin of small minds..."
	flopr #(5) write_reg_reg_x_m(.clk, .reset, .d(write_reg_x), .q(write_reg_m));



	// Memory (M) stage datapath components
	
	// Wait, where are they?!?! 
	// Oh, that's right. Data memory is its own module that we hook up to via
	// inputs and outputs of this module.


	// Memory-to-Writeback Inter-stage Registers
	flopr #(32) alu_out_reg_m_w(.clk, .reset, .d(alu_out_m), .q(alu_out_w));
	flopr #(32) dmem_read_data_reg_m_w(.clk, .reset, 
										.d(dmem_read_data_m), .q(dmem_read_data_w));
	flopr #(5) write_reg_reg_m_w(.clk, .reset, .d(write_reg_m), .q(write_reg_w));



	// Writeback (W) stage datapath components
	
	mux2 #(32) resmux(.d0(alu_out_w), .d1(dmem_read_data_w),
						 .sel(mem_to_reg_w), .y(result_w));

endmodule
