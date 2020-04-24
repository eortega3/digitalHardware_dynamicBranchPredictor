# unit3b.asm
# test of MEM -> ID forwarding
        addi $1, $0, 3      # forward to input B of equality checker
        addi $0, $0, 0      # nop
        beq $0, $1, target  # not taken
        addi $1, $1, 1      # should execute
target:
        addi $2, $0, 5
         
	# nops to avoid fetching illegal instructions
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0