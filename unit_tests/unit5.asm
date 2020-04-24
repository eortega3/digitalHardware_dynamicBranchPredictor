# unit5.asm
# test of stalling caused by lw to beq
        addi $1, $0, 3      # R[1] = 3
        sw $1, 80($0)       # Mem[80] = 3
        lw $1, 80($0)       # should cause 2 stalls in next instruction
        beq $1, $0, target  # shouldn't be taken
        addi $1, $1, 1      # R[1] = 3 + 1 = 4
target:
        addi $0, $0, 0      # nop
        
	# nops to avoid fetching illegal instructions
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
