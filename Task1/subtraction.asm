.data
matrix_size:    .word 4       # size of each element in the matrix (4 bytes for integers)
n:              .word 3       # size of the n x n matrix
A:              .space 36     # space for n x n matrix A (4 bytes per element)
B:              .space 36     # space for n x n matrix B (4 bytes per element)
C:              .space 36     # space for n x n matrix C (4 bytes per element)

.text
main:

    # TODO: void subtract( float* A, float* B, float* C, int N )  C = A - B 
subtract: 	
		addi $sp $sp -24 
		swc1 $f20 0($sp) #save A to $f20   
		swc1 $f22 4($sp)#save B to f22
		swc1 $f24 8($sp) #save C to f24
		sw $s0 12($sp)   
		sw $s1 16($sp)
		sw $s2 20($sp)
		sw $s3 24($sp)
		
		la $s0 $a0 # address of matrix A
		la $s1 $a1 # address of matrix B
		la $s2 $a2 # address of matrix C 
		li $s3 $a3  #int N 
		la $s4 $ra #save return address 
		
		#s5, s6, s7 has the current item in matrix A B C 
		lwc1 $f20 0($s0)
		lwc1 $f22 0($s1)
		lwc1 $f24 0($s2)
		
				
		
EndSubtract: 	
		
		lwc1 $f20 0($sp)
		lwc1 $f22 4($sp)
		lwc1 $f24 8($sp) 
		 
		jr $ra

    # Load matrix size and n
    lw $t0, matrix_size
    lw $t1, n

    # Calculate the number of elements in the matrix (n x n)
    mul $t2, $t1, $t1

    # Calculate the memory offset for matrices A, B, and C
    li $t3, A
    li $t4, B
    li $t5, C

    # Call the subtract_matrices function
    jal subtract_matrices

    # Exit the program
    li $v0, 10
    syscall

# Subtracts matrices A and B, and stores the result in matrix C
# Arguments: $t1 = n, $t2 = number of elements, $t3 = address of matrix A, $t4 = address of matrix B, $t5 = address of matrix C
subtract_matrices:
    # Loop index
    li $t0, 0

    # Loop to subtract each element of matrices A and B
    loop:
        # Check if we have processed all elements
        bge $t0, $t2, end_loop

        # Calculate the memory offset for the current element
        mul $t6, $t0, $t0          # Calculate the offset for the row
        add $t6, $t6, $t3          # Add the base address of matrix A
        lw $t7, 0($t6)             # Load element A[i][j] into $t7

        mul $t6, $t0, $t1          # Calculate the offset for the row
        add $t6, $t6, $t4          # Add the base address of matrix B
        lw $t8, 0($t6)             # Load element B[i][j] into $t8

        sub $t9, $t7, $t8           # Subtract B[i][j] from A[i][j]

        mul $t6, $t0, $t0          # Calculate the offset for the row
        add $t6, $t6, $t5          # Add the base address of matrix C
        sw $t9, 0($t6)             # Store the result in C[i][j]

        # Increment the loop index
        addi $t0, $t0, 1

        # Repeat the loop
        j loop

    end_loop:
        jr $ra    # Return from the function
