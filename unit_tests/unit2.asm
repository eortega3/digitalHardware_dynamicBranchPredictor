# unit2.asm
# test of WB -> EX forwarding
addi $1, $0, 3      # forward to A input of ALU
addi $0, $0, 1      # shouldn't forward
add $2, $1, $0      # forward to B input of ALU
addi $0, $0, 2      # shouldn't forward
add $3, $0, $2

# nops to avoid fetching illegal instructions
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0