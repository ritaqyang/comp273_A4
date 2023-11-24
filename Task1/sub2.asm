.data
    A:      .float 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 8.0, 9.0, 10.0 
 

    B:      .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0   
       

    C:      .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0              
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

# t0: index count 
# t1,2,3: address for A,B,C
# t4: n^2 
# f4: element A
# f6: element B
# f8: A-B 
subtract: 	
	    li $t0, 0 # index counter 
        addi $sp $sp -4 
        sw $ra 0($sp)  # save return address 
        mul $t4, $a3, $a3  # total num of elements N^2
        la $t1 ($a0) # address of matrix A
	    la $t2 ($a1) # address of matrix B
	    la $t3 ($a2) # address of matrix C 

 subloop:
        bge $t0, $t4, end_sub_loop     # if we've parsed all elements of matrix
        lwc1 $f4, ($t1)            # Load element A[i][j] into $f4
        lwc1 $f6, ($t2)            # Load element B[i][j] into $f6
        sub.s $f8, $f4, $f6        # Subtract B[i][j] from A[i][j]
        swc1 $f8, ($t3)            # Store the result in C[i][j]
        
        
        lwc1 $f12 ($t3)
        li $v0 2
        syscall

        addi $t0, $t0, 1           # increment counter 
        addi $t1, $t1, 4          # Add 4 to the current address of matrix A
        addi $t2, $t2, 4          # Add 4 to the current address of matrix B
        addi $t3, $t3, 4          # Add 4 to the current address of matrix C

        j subloop

end_sub_loop:
    	
    	lw $ra 0($sp)
    	addi $sp $sp 4 
        jr $ra    # Return from the function
