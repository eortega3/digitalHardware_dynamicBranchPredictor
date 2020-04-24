/*
 * Register file module with 2 read ports and 1 write port.
 * Note that reading is asynchronous while writing is synchronous.
 * Register 0 (i.e. $zero in MIPS) is hardwired to 0 (even if you try to write
 * to it).
 */
module regfile#(parameter NUM_REG=32, WIDTH=32)
			   (input  logic        clk, 
                input  logic        we3, 
                input  logic [$clog2(NUM_REG)-1:0]  ra1, ra2, wa3, 
                input  logic [WIDTH-1:0] wd3, 
                output logic [WIDTH-1:0] rd1, rd2);

	logic [WIDTH-1:0] rf [0:NUM_REG-1];

	always_ff @(posedge clk)
	begin
		if (we3) rf[wa3] <= wd3;	
	end

	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
