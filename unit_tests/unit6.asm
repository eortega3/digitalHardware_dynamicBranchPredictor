# unit6.asm
# test of stalling caused by addi to beq
        addi $1, $0, 3      # R[1] = 3; causes 1-cycle stall 
        beq $1, $0, target  # shouldn't be taken
        addi $1, $1, 1      # R[1]++
target:
        addi $0, $0, 0      # nop
        
	# nops to avoid fetching illegal instructions
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0