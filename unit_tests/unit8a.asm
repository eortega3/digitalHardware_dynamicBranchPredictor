# unit8a.asm
# test of forwarding from lw to dependent sw
addi $1, $0, 7      # R[1] = 3
sw $1, 80($0)       # Mem[80] = 3
lw $2, 80($0)       # Forward to sw's memory write
sw $2, 84($0)

# nops to avoid fetching illegal instructions
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
