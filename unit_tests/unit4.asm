# unit4.asm
# test of stalling caused by lw to R-type dependency
addi $1, $0, 3  # R[1] = 3
sw $1, 80($0)   # Mem[80] = 3
lw $1, 80($0)   # causes a stall for following instruction
add $2, $1, $0  # R[2] = R[1] + 0 = 3

# nops to avoid fetching illegal instructions
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
