# compute difference by calling subtract(A, B, A, n)
# so A-B is stored in A 
# then computes frob norm with (A, n) as inputs 

.data
    A:      .float 2.0, 4.0, 6.0, 8.0 
 

    B:      .float 1.0, 2.0, 3.0, 4.0   
       

    C:      .float 0.0, 0.0, 0.0, 0.0                 # Space for matrix C (3x3 matrix, each element is 4 bytes)
    array_size:    .word 4  
    const0: .float 0.0


.text
main:
    # Call the subtract function
    la $a0, A          # Load address of matrix A
    la $a1, B          # Load address of matrix B
    la $a2, A          # Load address of matrix A to store subtraction result 
    li $a3, 2          # Set N (size of the matrix)

    jal subtract

  # call frobeneousNorm function 
    la $a0, A          # Load address of matrix 
    li $a1, 2          # Set N (size of the matrix)
    jal frobeneousNorm

    # print $f0 result 
    li $v0 2
    mov.s $f12 $f0 
    syscall 

    # Exit the program
    li $v0, 10
    syscall


######################################################
# TODO: void subtract( float* A, float* B, float* C, int N )  C = A - B 

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

#################################################
# TODO: float frobeneousNorm( float* A, int N )

frobeneousNorm: 	# a0 = A, a1 = n
	    li $t0, 0 # index counter 
        addi $sp $sp -4 
        sw $ra 0($sp)  
    
    # t0: index 
    # t1: address of matrix 
    # t4: N squared
    # f4: load each element 
    # Calculate the number of elements in the matrix (N x N) $t2 has N^2
        mul $t4, $a1, $a1   
        la $t1 ($a0) # address of matrix A
        lwc1 $f0 const0  # intialize return value f0 
	
 frob_loop:
        bge $t0, $t4, end_frob_loop     
        lwc1 $f4, ($t1)            # Load element A[i][j] into $f4
        mul.s $f4 $f4 $f4          # get the square of one element 
        add.s $f0, $f4, $f0        # store sum to $f0

        addi $t0, $t0, 1
        addi $t1, $t1, 4          
        j frob_loop

end_frob_loop:
    	
        sqrt.s $f0, $f0 # get the squareroot of $f0
    	lw $ra 0($sp)
    	addi $sp $sp 4 
        jr $ra    
print_float_array:
    
    li $t0, 0 # loop index 
    la $t1 ($a0) # address of matrix 
    loop:
        bge $t0, $a1, end_loop
        lwc1 $f12 ($t1)
        li $v0, 2       
        syscall

        li $v0, 11       # System call code for printing a character
        li $a0, 32       # ASCII code for space
        syscall
        addi $t0, $t0, 1
        addi $t1, $t1, 4
        j loop

    end_loop:
        jr $ra    # Return from the function

 