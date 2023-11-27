# Assuming A, B, and C are pointers and n is an integer
# A is in $a0, B is in $a1, C is in $a2, n is in $a3
# Assuming BLOCK_SIZE is a constant value

MADD2:
    # Save callee-saved registers
    addi $sp, $sp, -32
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)

    # Initialize loop variables
    move $s0, $zero  # jj
    move $s1, $zero  # kk
    move $s2, $zero  # i

outer_loop:
    # Check if i >= n
    bge $s2, $a3, end_madd2

    move $s3, $zero  # j

middle_loop:
    # Check if j >= min(jj + BLOCK_SIZE, n)
    bge $s3, $a3, next_i

    li.s $f4, 0.0  # sum

    move $s4, $zero  # k

inner_loop:
    # Check if k >= min(kk + BLOCK_SIZE, n)
    bge $s4, $a3, next_j

    # Compute A[i][k] * B[k][j] and accumulate in sum
    lw $t0, 0($a0)        # Load A[i][k]
    lw $t1, 0($a1)        # Load B[k][j]
    mul.s $f5, $f6, $f7   # Multiply A[i][k] and B[k][j]
    add.s $f4, $f4, $f5   # Accumulate in sum

    # Move to the next element in A and B
    addi $a0, $a0, 4
    addi $a1, $a1, 4

    # Move to the next iteration of the inner loop
    addi $s4, $s4, 1
    j inner_loop

next_j:
    # Store the result in C[i][j]
    s.s $f4, 0($a2)

    # Move to the next element in C
    addi $a2, $a2, 4

    # Move to the next iteration of the middle loop
    addi $s3, $s3, 1
    j middle_loop

next_i:
    # Move to the next iteration of the outer loop
    addi $s2, $s2, 1
    j outer_loop

end_madd2:
    # Restore callee-saved registers
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    lw $s7, 28($sp)
    addi $sp, $sp, 32

    jr $ra  # Return
