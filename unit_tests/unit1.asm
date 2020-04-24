# unit1.asm
# test of MEM -> EX forwarding
addi $1, $0, 3      # forward to A input of ALU
add $2, $1, $0      # forward to B input of ALU
add $3, $0, $2

# nops to avoid fetching illegal instructions
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0