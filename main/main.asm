# TODO: PUT YOUR NAME AND STUDENT NUMBER HERE!!!
# TODO: ADD OTHER COMMENTS YOU HAVE HERE AT THE TOP OF THIS FILE
# TODO: SEE LABELS FOR PROCEDURES YOU MUST IMPLEMENT AT THE BOTTOM OF THIS FILE

.data
TestNumber:	.word 1	# TODO: Which test to run!
				# 0 compare matrices stored in files Afname and Bfname
				# 1 test Proc using files A through D named below
				# 2 compare MADD1 and MADD2 with random matrices of size Size
				
Proc:		MADD1		# Procedure used by test 1, set to MADD1 or MADD2		
				
Size:		.word 8		# matrix size (MUST match size of matrix loaded for test 0 and 1)

Afname: 		.asciiz "A8.bin"  # 64 = 2^6   64x64x4 = 2^(6+6+2) = 2^14 = 8K?
Bfname: 		.asciiz "B8.bin"
Cfname:		.asciiz "C8.bin"
Dfname:	 	.asciiz "D8.bin"
const0: .float 0.0
bsize: .word 4
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

		la $ra ReturnHere
		la $t0 Proc	# function pointer
		lw $t0 ($t0)	
		jr $t0		# like a jal to MADD1 or MADD2 depending on Proc definition

ReturnHere:	
		move $a0 $s2	# C
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
		move $t4,$a3 # store 0 
        mul $t4, $t4, $t4  # total num of elements N^2
	
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
        move $t4, $a1 # load N 
        mul $t4, $t4, $t4  # total num of elements N^2
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
	
    
    
outer_loop: 
    bge $s0, $s6, end_outer_loop # Check if i >= n
    
	middle_loop:
        bge $s1, $s6, end_middle_loop # Check if j >= n
        
		inner_loop:
		li $t0 0 
    		li $t1 0 
    		li $t2 0 
    		li $t3 0 
			
            bge $s2, $s6, end_inner_loop # Check if k >= n
            # Calculate indices for A[i][k] and C[i][j]
            mul $t0, $s0, $s6   # i * n
            add $t1, $t0, $s2   # i * n + k 
            add $t3, $t0, $s1   # i * n + j 

            sll $t1, $t1, 2 # 4(i * n + k)
            sll $t3, $t3, 2 # 4(i * n + j)
            add $t1, $s3, $t1  # A + 4(i * n + k)
            add $t3, $s5, $t3 # C + 4(i * n + j)

            # get address for B[k][j]
            mul $t2, $s2, $s6   # k * n
            add $t2, $t2, $s1  # k * n + j 
            sll $t2, $t2, 2 # 4(k * n + j)
            add $t2, $s4, $t2 # B + 4(k * n + j)


            # now we have A[i][k] in t1, B[k][j] in t2, C[i][j] in t3 
            lwc1 $f4, 0($t1) # A[i][k] in f4 
            lwc1 $f6, 0($t2) # B[k][j] in f6 
            lwc1 $f8, 0($t3) # C[i][j] in f8 

            mul.s $f4 $f4 $f6 # A[i][k] * B[k][j] stored in $f4
            add.s $f8 $f8 $f4 # C[i][j] = C[i][j] + A[i][k] * B[k][j]
            swc1 $f8 0($t3) # store new value for C

            addi $s2, $s2, 1 # k = k+1 
			j inner_loop # go back to top of inner loop 
        
		end_inner_loop:

        # Increment j, reset k to 0 
        addi $s1, $s1, 1 
        li $s2 0 # inner loop done reset k to 0 
        j middle_loop

    end_middle_loop:
    addi $s0, $s0, 1 # Increment i
    li $s1 0  # reset j to 0 
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
# cache size is 4 words per block
# so we access everything that's already in the cache 
MADD2:
    addi $sp $sp -36
    sw $ra 0($sp)     
	sw $s0 4($sp) 
    sw $s1 8($sp)
    sw $s2 12($sp) 
    sw $s3 16($sp) 
    sw $s4 20($sp) 
    sw $s5 24($sp) 
    sw $s6 28($sp) 
	swc1 $f20 32($sp)

    li $s0 4 # bsize  
    li $s1 0 #   
    li $s2 0 # 

    move $s3 $a0 # A 
    move $s4 $a1 # B 
    move $s5 $a2 # C 
    move $s6 $a3 # n 

	move $t0 $s5 # current C 
	move $t1 $s4 # i * n 

        # Loop initialization
        li $t2, 0  # jj
        LoopJJ:
            bge $t2, $s6, EndLoopJJ  # if jj >= n, exit outer loop
            li $t3, 0  # kk
            LoopKK:
                bge $t3, $s6, EndLoopKK  # if kk >= n, exit middle loop
                li $t4, 0 # i
                LoopI:
                    bge $t4, $s6, EndLoopI  # if i >= n, exit inner loop
					mul $t1, $t4, $s6   # i * n
					
					add $t0, $t1, $t2   # i * n + j
					sll $t0, $t0, 2     # 4(i * n + j)
					add $t0, $t0, $s5   # C + 4(i * n + j) in t0 
					
					add $s2 $t2 $s0   # s2 = jj + bsize 
					move $t5 $t2  # j = jj 

                    LoopJ:
                        bge $t5, $s6, EndLoopJ  # if j >= n, exit loop
						bge $t5, $s2, EndLoopJ # if j >= jj+bsize  exit loop
                        lwc1 $f20 const0 # store sum in f20 
						
						
						mul $t8, $t6, $s6  # k * n
                        add $t8, $t8, $t5   # k * n + j
						sll $t8, $t8, 2 # 4(k * n + j)
						add $t8, $s4, $t8 # B + 4(k * n + j) 

						move $t6, $t3       # k = kk
						add $s1 $t6 $s0  # s1 = kk + bsize 
						add $t7, $t1, $t6   # i * n + k
						add $t7, $s3, $t7	 # A + 4(i * n + k)
						
			
                        LoopK:
                            bge $t6, $s6, EndLoopK  # if k >= n, exit loop
							bge $t6, $s1, EndLoopK  # if k >= kk + bsize, exit loop 
                       
                            lwc1 $f4, 0($t7) # A[i][k]
                            lwc1 $f6, 0($t8)  # B[k][j]
							
							mul.s $f8, $f4, $f6 # A[i][k] * B[k][j]
                            add.s $f20, $f20, $f8  # sum += A[i][k] * B[k][j]
							addi $t6, $t6, 1 # Increment k
							addi $t7, $t7, 4
							add $t8 $t8 $s6 # B[k+1][j]
                            j LoopK
                        
						EndLoopK:

                        
                        lwc1 $f6 0($t0)   # C[i][j] in $f6 
                        add.s $f6, $f6, $f20 # add sum from f20 to f6 
                        swc1 $f6, 0($t0)  # Store the result back to C[i][j]
						addi $t0, $t0, 4 # C[i][j+1]
                        addi $t5, $t5, 1 # Increment j
                        j LoopJ

                    EndLoopJ:

                    addi $t4, $t4, 1  # Increment i
                    j LoopI

                EndLoopI:
                add $t3, $t3, $s0 # kk + bsize 
                j LoopKK

            EndLoopKK:
            add $t2, $t2, $s0 # jj + bsize 
            j LoopJJ

        EndLoopJJ:

    
        lw $ra 0($sp)     
	lw $s0 4($sp) 
    lw $s1 8($sp)
    lw $s2 12($sp) 
    lw $s3 16($sp) 
    lw $s4 20($sp) 
    lw $s5 24($sp) 
    lw $s6 28($sp) 
	lwc1 $f20 32($sp)
    addi $sp $sp 36


    jr $ra   
