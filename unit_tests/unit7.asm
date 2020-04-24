# unit7.asm
# test of stalling caused by addi to beq
        addi $1, $0, 3      # R[1] = 3
        beq $0, $0, target  # should be taken
        addi $1, $1, 1      # should be fetched then flushed
target:
        addi $1, $1, 1      # R[1] = 3 + 1 = 4
        
	# nops to avoid fetching illegal instructions
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0