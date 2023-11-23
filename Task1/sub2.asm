.data
    A:      .float 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0   # Example matrix A (replace with your values)
 

    B:      .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0   # Example matrix B (replace with your values)
       

    C:      .space 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0                # Space for matrix C (3x3 matrix, each element is 4 bytes)
    array_size:    .word 9  
.text
main:
    # Call the subtract function
    la $a0, A          # Load address of matrix A
    la $a1, B          # Load address of matrix B
    la $a2, C          # Load address of matrix C
    li $a3, 3          # Set N (size of the matrix)

    jal subtract

    # Exit the program
    li $v0, 10
    syscall

# Function to subtract matrices A and B and store the result in matrix C
# Arguments: $a0 = address of matrix A, $a1 = address of matrix B,
#            $a2 = address of matrix C, $a3 = size of the matrices (N)

# Function to print an array of floats
# Arguments: $a0 = address of the array, $a1 = size of the array
print_float_array:
    # Loop index
    li $t0, 0
    la $t1 ($a0) 

    # Loop to print each element of the array
    loop:
        # Check if we have processed all elements
        bge $t0, $a1, end_loop

        # Load the current float element into $f12
        lwc1 $f12 ($t1)
        # Print the float
        li $v0, 2        # System call code for printing a float
        syscall

        # Print a space
        li $v0, 11       # System call code for printing a character
        li $a0, 32       # ASCII code for space
        syscall

        # Increment the loop index and move to the next float in the array
        addi $t0, $t0, 1
        addi $t1, $t1, 4

        # Repeat the loop
        j loop

    end_loop:
        jr $ra    # Return from the function

subtract: 	
		li $t0, 0 #index counter 
        addi $sp $sp -8 
        sw $s0 0($sp)
        sw $s1 4($sp)
        sw $s2 8($sp)
		    
    # Calculate the number of elements in the matrix (N x N) $t2 has N^2
        mul $t2, $a3, $a3

        la $s0 ($a0) # address of matrix A
		la $s1 ($a1) # address of matrix B
		la $s2 ($a2) # address of matrix C 

    # Loop to subtract each element of matrices A and B
 subloop:
        # Check if we have processed all elements
        bge $t0, $t2, end_sub_loop     # if we've parsed all elements of matrix 

        # Calculate the memory offset for the current element
        
        lwc1 $f4, ($s0)            # Load element A[i][j] into $f4
        lwc1 $f6, ($s1)            # Load element B[i][j] into $f6
        sub.s $f8, $f4, $f6        # Subtract B[i][j] from A[i][j]
        swc1 $f8, ($s2)            # Store the result in C[i][j]
        lwc1 $f12 ($s2)
        li $v0 2
        syscall

        # Repeat the loop
        addi $t0, $t0, 1
        addi $s0, $s0, 4          # Add 4 to the current address of matrix A
        addi $s1, $s1, 4          # Add 4 to the current address of matrix B
        addi $s2, $s2, 4          # Add 4 to the current address of matrix C

        j subloop

    end_sub_loop:
        jr $ra    # Return from the function
