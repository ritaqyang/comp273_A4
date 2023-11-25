# TODO: PUT YOUR NAME AND STUDENT NUMBER HERE!!!
# TODO: ADD OTHER COMMENTS YOU HAVE HERE AT THE TOP OF THIS FILE
# TODO: SEE LABELS FOR PROCEDURES YOU MUST IMPLEMENT AT THE BOTTOM OF THIS FILE

.data
TestNumber:	.word 1		# TODO: Which test to run!
				# 0 compare matrices stored in files Afname and Bfname
				# 1 test Proc using files A through D named below
				# 2 compare MADD1 and MADD2 with random matrices of size Size
				
Proc:		MADD1		# Procedure used by test 1, set to MADD1 or MADD2		
				
Size:		.word 64		# matrix size (MUST match size of matrix loaded for test 0 and 1)

Afname: 		.asciiz "A1.bin"  # 64 = 2^6   64x64x4 = 2^(6+6+2) = 2^14 = 8K?
Bfname: 		.asciiz "B1.bin"
Cfname:		.asciiz "C1.bin"
Dfname:	 	.asciiz "D1.bin"
const0: .float 0.0
message1: .asciiz  "in subtraction function"
message2: .asciiz  "in frob function"
#################################################################
# Main function for testing assignment objectives.
# Modify this function as needed to complete your assignment.
# Note that the TA will ultimately use a different testing program.
.text
main:		la $t0 TestNumber
		lw $t0 ($t0)
		beq $t0 0 compareMatrix
		beq $t0 1 testFromFile
		beq $t0 2 compareMADD
		li $v0 10 # exit if the test number is out of range
        		syscall	

compareMatrix:	la $s7 Size	
		lw $s7 ($s7)		# Let $s7 be the matrix size n

		move $a0 $s7
		jal mallocMatrix		# allocate heap memory and load matrix A
		move $s0 $v0		# $s0 is a pointer to matrix A
		la $a0 Afname
		move $a1 $s7
		move $a2 $s7
		move $a3 $s0
		jal loadMatrix
	
		move $a0 $s7
		jal mallocMatrix		# allocate heap memory and load matrix B
		move $s1 $v0		# $s1 is a pointer to matrix B
		la $a0 Bfname
		move $a1 $s7
		move $a2 $s7
		move $a3 $s1
		jal loadMatrix
	
		move $a0 $s0
		move $a1 $s1
		move $a2 $s7
		jal check
		
		li $v0 10      				# load exit call code 10 into $v0
        		syscall         	# call operating system to exit	

testFromFile:	la $s7 Size	
		lw $s7 ($s7)		# Let $s7 be the matrix size n

		move $a0 $s7
		jal mallocMatrix		# allocate heap memory and load matrix A
		move $s0 $v0		# $s0 is a pointer to matrix A
		la $a0 Afname
		move $a1 $s7
		move $a2 $s7
		move $a3 $s0
		jal loadMatrix
	
		move $a0 $s7
		jal mallocMatrix		# allocate heap memory and load matrix B
		move $s1 $v0		# $s1 is a pointer to matrix B
		la $a0 Bfname
		move $a1 $s7
		move $a2 $s7
		move $a3 $s1
		jal loadMatrix
	
		move $a0 $s7
		jal mallocMatrix		# allocate heap memory and load matrix C
		move $s2 $v0		# $s2 is a pointer to matrix C
		la $a0 Cfname
		move $a1 $s7
		move $a2 $s7
		move $a3 $s2
		jal loadMatrix
	
		move $a0 $s7
		jal mallocMatrix		# allocate heap memory and load matrix A
		move $s3 $v0		# $s3 is a pointer to matrix D
		la $a0 Dfname
		move $a1 $s7
		move $a2 $s7
		move $a3 $s3
		jal loadMatrix		# D is the answer, i.e., D = AB+C 
	
		# TODO: add your testing code here
		move $a0, $s0	# A
		move $a1, $s1	# B
		move $a2, $s2	# C
		move $a3, $s7	# n
		# call MADD1 

		jal MADD1 

		# compare C and D using check function 
		move $a0, $s2	# C
		move $a1, $s3	# D
		move $a2, $s7	# N

		jal check

		la $ra ReturnHere
		la $t0 Proc	# function pointer
		lw $t0 ($t0)	
		jr $t0		# like a jal to MADD1 or MADD2 depending on Proc definition

ReturnHere:	move $a0 $s2	# C
		move $a1 $s3	# D
		move $a2 $s7	# n
		jal check	# check the answer

		li $v0, 10      	# load exit call code 10 into $v0
	        	syscall         	# call operating system to exit	

compareMADD:	la $s7 Size
		lw $s7 ($s7)	# n is loaded from Size
		mul $s4 $s7 $s7	# n^2
		sll $s5 $s4 2	# n^2 * 4

		move $a0 $s5
		li   $v0 9	# malloc A
		syscall	
		move $s0 $v0
		move $a0 $s5	# malloc B
		li   $v0 9
		syscall
		move $s1 $v0
		move $a0 $s5	# malloc C1
		li   $v0 9
		syscall
		move $s2 $v0
		move $a0 $s5	# malloc C2
		li   $v0 9
		syscall
		move $s3 $v0	
	
		move $a0 $s0	# A
		move $a1 $s4	# n^2
		jal  fillRandom	# fill A with random floats
		move $a0 $s1	# B
		move $a1 $s4	# n^2
		jal  fillRandom	# fill A with random floats
		move $a0 $s2	# C1
		move $a1 $s4	# n^2
		jal  fillZero	# fill A with random floats
		move $a0 $s3	# C2
		move $a1 $s4	# n^2
		jal  fillZero	# fill A with random floats

		move $a0 $s0	# A
		move $a1 $s1	# B
		move $a2 $s2	# C1	# note that we assume C1 to contain zeros !
		move $a3 $s7	# n
		jal MADD1

		move $a0 $s0	# A
		move $a1 $s1	# B
		move $a2 $s3	# C2	# note that we assume C2 to contain zeros !
		move $a3 $s7	# n
		jal MADD2

		move $a0 $s2	# C1
		move $a1 $s3	# C2
		move $a2 $s7	# n
		jal check	# check that they match
	
		li $v0 10      	# load exit call code 10 into $v0
        		syscall         	# call operating system to exit	

###############################################################
# mallocMatrix( int N )
# Allocates memory for an N by N matrix of floats
# The pointer to the memory is returned in $v0	
mallocMatrix: 	
        mul  $a0, $a0, $a0	# Let $s5 be n squared
		sll  $a0, $a0, 2	# Let $s4 be 4 n^2 bytes
		li   $v0, 9		
		syscall			# malloc A
		jr $ra
	
###############################################################
# loadMatrix( char* filename, int width, int height, float* buffer )
.data
errorMessage: .asciiz "FILE NOT FOUND" 
.text
loadMatrix:	mul $t0 $a1 $a2 	# words to read (width x height) in a2
		sll $t0 $t0  2	  	# multiply by 4 to get bytes to read
		li $a1  0     		# flags (0: read, 1: write)
		li $a2  0     		# mode (unused)
		li $v0  13    		# open file, $a0 is null-terminated string of file name
		syscall
		slti $t1 $v0 0
		beq $t1 $0 fileFound
		la $a0 errorMessage
		li $v0 4
		syscall		  	# print error message
		li $v0 10         	# and then exit
		syscall		
fileFound:	move $a0 $v0     	# file descriptor (negative if error) as argument for read
  		move $a1 $a3     	# address of buffer in which to write
		move $a2 $t0	  	# number of bytes to read
		li  $v0 14       	# system call for read from file
		syscall           	# read from file
		# $v0 contains number of characters read (0 if end-of-file, negative if error).
                	# We'll assume that we do not need to be checking for errors!
		# Note, the bitmap display doesn't update properly on load, 
		# so let's go touch each memory address to refresh it!
		move $t0 $a3	# start address
		add $t1 $a3 $a2  	# end address
loadloop:	
        lw $t2 ($t0)
		sw $t2 ($t0)
		addi $t0 $t0 4
		bne $t0 $t1 loadloop		
		li $v0 16	# close file ($a0 should still be the file descriptor)
		syscall
		jr $ra	

##########################################################
# Fills the matrix $a0, which has $a1 entries, with random numbers
fillRandom:	li $v0 43
		syscall		# random float, and assume $a0 unmodified!!
		swc1 $f0 0($a0)
		addi $a0 $a0 4
		addi $a1 $a1 -1
		bne  $a1 $zero fillRandom
		jr $ra

##########################################################
# Fills the matrix $a0 , which has $a1 entries, with zero
fillZero:	sw $zero 0($a0)	# $zero is zero single precision float
		addi $a0 $a0 4
		addi $a1 $a1 -1
		bne  $a1 $zero fillZero
		jr $ra



# for adding to the master file 
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
        mul $t4, $a3, $a3  # total num of elements N^2
	
        move $t1 $a0 
        move $t2 $a1 
        move $t3 $a2

        li $v0 4
        la $a0 message1
        syscall 

 subloop:
        bge $t0, $t4, end_sub_loop     # if we've parsed all elements of matrix
        lwc1 $f4, 0($t1)            # Load element A[i][j] into $f4
        lwc1 $f6, 0($t2)            # Load element B[i][j] into $f6
        sub.s $f8, $f4, $f6        # f8 = A - B 
        swc1 $f8, 0($t3)            # Store the result in C[i][j]
        
        addi $t0, $t0, 1           # increment counter 
        addi $t1, $t1, 4          # Add 4 to the current address of matrix A
        addi $t2, $t2, 4          # Add 4 to the current address of matrix B
        addi $t3, $t3, 4          # Add 4 to the current address of matrix C

        j subloop

end_sub_loop:
    	
        jr $ra    # Return from the function

#################################################
# TODO: float frobeneousNorm( float* A, int N )

frobeneousNorm: 	# a0 = A, a1 = n
	    li $t0, 0 # index counter 
	    li $t4, 0 
	    li $t1, 0 
	    
    # t0: index 
    # t1: address of matrix 
    # t4: N squared
    # f4: load each element 
    # Calculate the number of elements in the matrix (N x N) $t2 has N^2
        mul $t4, $a1, $a1   
        move $t1 $a0 
        lwc1 $f0 const0  # intialize return value f0 
	
 frob_loop:
        bge $t0, $t4, end_frob_loop     
        lwc1 $f4, 0($t1)            # Load element A[i][j] into $f4
        mul.s $f4 $f4 $f4          # get the square of one element 
        add.s $f0, $f4, $f0        # store sum to $f0

        addi $t0, $t0, 1
        addi $t1, $t1, 4          
        j frob_loop

end_frob_loop:
    	
        sqrt.s $f0, $f0 # get the squareroot of $f0
        jr $ra    

 #################################################
# TODO: void check ( float* C, float* D, int N )
# Print the forbeneous norm of the difference of C and D

check:
    # save argument matrices float* C, float* D, int N ) 
    addi $sp $sp -16 
    sw $s1 0($sp)     
    sw $s2 4($sp) 
    sw $s0 8($sp)
    sw $ra 12($sp)  # save return address 
    move $s0 $a2 # save arg N 
    move $s1 $a0 # save C
    move $s2 $a1 # save D 
	
    # Call the subtract function
    move $a0 $s1 
    move $a1 $s2 
    move $a2 $s1         
    move $a3 $s0         # Set N (size of the matrix)
    jal subtract

    # call frobeneousNorm function 
    move $a0, $s1          # Load address of matrix 
    move $a1, $s0          # Set N (size of the matrix)
    jal frobeneousNorm

    # print $f0 result 
    li $v0 2
    mov.s $f12 $f0 
    syscall 

        lw $s1 0($sp)  # restore save registers after use 
        lw $s2 4($sp)
        lw $s0 8($sp)
        lw $ra 12($sp) # get return address from the stack
    	addi $sp $sp 16
        jr $ra 

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
    
    li $t0 0 
    li $t1 0 
    li $t2 0 
    li $t3 0 
    
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

      


        end_inner_loop:

        # Increment j, reset k to 0 
        addi $s1, $s1, 1
        li $s2 0 

        j middle_loop

    end_middle_loop:

    # Increment i, reset j to 0 
    addi $s0, $s0, 1
    li $s1 0 
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
#########################################################
# TODO: void MADD2( float*A, float* B, float* C, N )
MADD2: 		jr   $ra
