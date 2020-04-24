# unit8b.asm
# Test of forwarding from lw to dependent sw to show it doesn't forward 0
# register.
addi $1, $0, 7      # R[1] = 3
sw $1, 80($0)       # Mem[80] = 3
lw $0, 80($0)       # Should NOT forward 3
sw $0, 80($0)		# Mem[80] = 0

# nops to avoid fetching illegal instructions
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
