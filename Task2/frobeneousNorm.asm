#  compute the sum of squares of all the entries 
# and take the squareroot of the sum (using sqrt.x instruction) 
# function signature float frobeneousNorm( float* A, int n )
# f0 is used as the return reg for float 
# use one for loop for all n^2 matrix entries 


.data
    A:      .float 2.0, 4.0, 6.0, 8.0   
 

    B:      .float 1.0, 2.0, 3.0, 4.0   
       

    C:      .float 5.0, 6.0, 7.0, 8.0              
    array_size:    .word 4  

    const0: .float 0.0
.text
main:
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

frobeneousNorm: 	# a0 = A, a1 = n
	    li $t0, 0 #index counter 
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
        add.s $f0, $f4, $f0        # store sum to $f0

        addi $t0, $t0, 1
        addi $t1, $t1, 4          
        j frob_loop

end_frob_loop:
    	
        sqrt.s $f0, $f0 # get the squareroot of $f0
    	lw $ra 0($sp)
    	addi $sp $sp 4 
        jr $ra    

