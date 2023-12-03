.data
    A: .space 1024     # Assuming 4x4 matrices (4x4x4 = 64 bytes for A)
    B: .space 1024     # Assuming 4x4 matrices (4x4x4 = 64 bytes for B)
    C: .space 1024     # Assuming 4x4 matrices (4x4x4 = 64 bytes for C)
    n: .word 4         # Assuming n is 4
    bsize: .word 4     # Block size

.text
    main:
        la $a0, A       # Load address of matrix A
        la $a1, B       # Load address of matrix B
        la $a2, C       # Load address of matrix C
        lw $a3, n       # Load n
        lw $t0, bsize   # Load block size

        jal MADD2       # Jump to MADD2 function

        # Exit program
        li $v0, 10
        syscall

MADD2:
        # Function prologue
        addi $sp, $sp, -12
        sw $ra, 0($sp)
        sw $f20, 4($sp)
        sw $s1, 8($sp)

        # Loop initialization
        li $t2, 0          # jj
        LoopJJ:
            bge $t2, $a3, EndLoopJJ  # if jj >= n, exit outer loop

            li $t3, 0          # kk
            LoopKK:
                bge $t3, $a3, EndLoopKK  # if kk >= n, exit middle loop

                li $t4, 0          # i
                LoopI:
                    bge $t4, $a3, EndLoopI  # if i >= n, exit inner loop

                    li $t5, $t2       # j = jj
                    LoopJ:
                        bge $t5, $a3, EndLoopJ  # if j >= n, exit loop

                        lwc1 $f20 const0

                        li $t6, $t3       # k = kk
                        LoopK:
                            bge $t6, $a3, EndLoopK  # if k >= n, exit loop

                            # Calculate index for A[i][k]
                            mul $t7, $t4, $a3   # i * n
                            add $t7, $t7, $t6   # i * n + k

                            # Calculate index for B[k][j]
                            mul $t8, $t6, $a3   # k * n
                            add $t8, $t8, $t5   # k * n + j

                            # Load A[i][k] and B[k][j] into FPU registers
                            lwc1 $f4, 0($t7) # A[i][k]
                            lwc1 $f6, 0($t8)  # B[k][j]

                            # Multiply A[i][k] and B[k][j]
                            mul.s $f8, $f4, $f6

                            # Add the result to sum
                            add.s $f20, $f20, $f8

                            # Increment k
                            addi $t6, $t6, 1
                            j LoopK

                        EndLoopK:

                        # Calculate index for C[i][j]
                        mul $t9, $t4, $a3   # i * n
                        add $t9, $t9, $t5   # i * n + j

                        # Load C[i][j] into FPU register
                        lwc1 $f6 0($t9)   # C[i][j]

                        # Add sum to C[i][j]
                        add.s $f6, $f6, $f20

                        # Store the result back to C[i][j]
                        swc1 $f6, 0($t9)  # C[i][j]

                        # Increment j
                        addi $t5, $t5, 1
                        j LoopJ

                    EndLoopJ:

                    # Increment i
                    addi $t4, $t4, 1
                    j LoopI

                EndLoopI:

                # Increment kk
                addi $t3, $t3, $t0
                j LoopKK

            EndLoopKK:

            # Increment jj
            addi $t2, $t2, $t0
            j LoopJJ

        EndLoopJJ:

        # Function epilogue
        lw $ra, 0($sp)
        lw $f20, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12

        jr $ra  # Return
