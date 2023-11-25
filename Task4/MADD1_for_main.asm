##############################################################
# TODO: void MADD1( float*A, float* B, float* C, N )

# MADD1 function
# Arguments: $a0 = address of A, $a1 = address of B, $a2 = address of C, $t0 = n
MADD1:
    
    addi $sp $sp -32
    sw $ra 0($sp)     
	sw $s0 4($sp) 
    sw $s1 8($sp)
    sw $s2 12($sp) 
    sw $s3 16($sp) 
    sw $s4 20($sp) 
    sw $s5 24($sp) 
    sw $s6 28($sp) 

    li $s0 0 # i 
    li $s1 0 # j 
    li $s2 0 # k 

    move $s3 $a0 # A 
    move $s4 $a1 # B 
    move $s5 $a2 # C 
    move $s6 $a3 # n 

outer_loop: 
    bge $s0, $s6, end_outer_loop # Check if i >= n
    middle_loop:
        bge $s1, $s6, end_middle_loop # Check if j >= n
        inner_loop:
            bge $s2, $s6, end_inner_loop # Check if k >= n
            # Calculate indices for A[i][k] and C[i][j]
            mul $t0, $s0, $s6   # i * n
            add $t1, $t0, $s2   # += k
            add $t3, $t0, $s1   # i * n + j 

            # multiply t0 by 4 to get the address 
            sll $t1, $t1, 2 # mult 4 bytes for A's index 
            sll $t3, $t3, 2 # for C 
            add $t1, $s3, $t1  # add to address for A
            add $t3, $s5, $t3 # add to address for C

            # get adress for B
            mul $t2, $s2, $s6   # k * n
            add $t2, $t2, $s1  # add j 
            sll $t2, $t2, 2 # mult 4 bytes for B's index 
            add $t2, $s4, $t2 # add to address for B

            # now we have A in t1, B in t2, C in t3 
            lwc1 $f4, 0($t1) # A in f4 
            lwc1 $f6, 0($t2) # B in f6 
            lwc1 $f8, 0($t3) # C in f8 

            mul.s $f4 $f4 $f6 # A * B 
            add.s $f8 $f8 $f4 # C = C+AB 
            swc1 $f8 0($t3) # C

            # Increment k
            addi $s2, $s2, 1
            j inner_loop

        end_inner_loop:

        # Increment j
        addi $s1, $s1, 1
        j middle_loop

    end_middle_loop:

    # Increment i
    addi $s0, $s0, 1
    j outer_loop

end_outer_loop:

    lw $ra 0($sp)     
	lw $s0 4($sp) 
    lw $s1 8($sp)
    lw $s2 12($sp) 
    lw $s3 16($sp) 
    lw $s4 20($sp) 
    lw $s5 24($sp) 
    lw $s6 28($sp) 
    addi $sp $sp 32


    jr $ra   
