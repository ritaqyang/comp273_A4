#  Rita Yang 260893989

# Using my once-a-semester extension 


# Menu options
# r - read text buffer from file 
# g - generate checksum
# v - validate checksum
# w - write text buffer to file
# c - get most common letter in text buffer
# q - quit

.data
MENU:              .asciiz "Commands (read, generate, validate, write, quit):"
REQUEST_FILENAME:  .asciiz "Enter file name:"
REQUEST_ALGORITHM: .asciiz "Choose checksum algorithm (1- Sum Complement, 2- Odd Parity Byte:"
ERROR:		 .asciiz "There was an error.\n"
VALIDATED:	.asciiz "Checksum validated"
NOT_VALIDATED: .asciiz "Checksum not validated"

FILE_NAME: 	.space 256	# maximum file name length, should not be exceeded
ALGORITHM_NUMBER: .word 1 	# maximum length of algorithm number, should not be exceeded
.align 2		# ensure word alignment in memory for text buffer (not important)
TEXT_BUFFER:  	.space 10000

.align 2		# ensure word alignment in memory for other data (probably important)

# TODO: define any other spaces you need

##############################################################
.text
		move $s1 $0 	# Keep track of the buffer length (starts at zero)
MainLoop:	li $v0 4		# print string
		la $a0 MENU
		syscall
		li $v0 12	# read char into $v0
		syscall
		move $s0 $v0	# store command in $s0			
		jal PrintNewLine

		beq $s0 'r' read
		beq $s0 'g' generate
		beq $s0 'w' write
		beq $s0 'v' validate
		beq $s0 'q' exit
		b MainLoop

read:		jal GetFileName
		li $v0 13	# open file
		la $a0 FILE_NAME 
		li $a1 0		# flags (read)
		li $a2 0		# mode (set to zero)
		syscall
		move $s0 $v0
		bge $s0 0 read2	# negative means error
		li $v0 4		# print string
		la $a0 ERROR
		syscall
		b MainLoop
read2:		li $v0 14	# read file
		move $a0 $s0
		la $a1 TEXT_BUFFER
		li $a2 9999
		syscall
		move $s1 $v0	# save the input buffer length
		bge $s0 0 read3	# negative means error
		li $v0 4		# print string
		la $a0 ERROR
		syscall
		move $s1 $0	# set buffer length to zero
		la $t0 TEXT_BUFFER
		sb $0 ($t0) 	# null terminate the buffer 
		addi $t0, $t0, 1
		sb $0 ($t0) 	# add extra null termination to accomodate extra checksum character
		b MainLoop
read3:		la $t0 TEXT_BUFFER
		add $t0 $t0 $s1
		sb $0 ($t0) 	# null terminate the buffer that was read
		li $v0 16	# close file
		move $a0 $s0
		syscall
		la $a0 TEXT_BUFFER
		#jal ToUpperCase
print:		la $a0 TEXT_BUFFER
		jal PrintBuffer
		b MainLoop	

write:		jal GetFileName
		li $v0 13	# open file
		la $a0 FILE_NAME 
		li $a1 1		# flags (write)
		li $a2 0		# mode (set to zero)
		syscall
		move $s0 $v0
		bge $s0 0 write2	# negative means error
		li $v0 4		# print string
		la $a0 ERROR
		syscall
		b MainLoop
write2:		li $v0 15	# write file
		move $a0 $s0
		la $a1 TEXT_BUFFER
		move $a2 $s1	# set number of bytes to write
		add $a2, $a2, 1 # add 1 for checksum at end of file
		syscall
		bge $v0 0 write3	# negative means error
		li $v0 4		# print string
		la $a0 ERROR
		syscall
		b MainLoop
		write3:
		li $v0 16	# close file
		move $a0 $s0
		syscall
		b MainLoop

generate:	jal GetAlgorithm
		la $a0 TEXT_BUFFER
		move $a1 $v0 # which algorithm to use
		jal GenerateChecksum
		move $a0, $v0 # prints checksum character
		li $v0, 11
    		syscall
		la $a0 TEXT_BUFFER
		b MainLoop
		
validate: 	jal GetAlgorithm
		la $a0 TEXT_BUFFER
		move $a1 $v0	# which algorithm to use
		jal ValidateChecksum
		la $a0 TEXT_BUFFER
		b MainLoop

		
exit:		li $v0 10 	# exit
		syscall

###########################################################
PrintBuffer:	li $v0 4          # print contents of a0
		syscall
		li $v0 11	# print newline character
		li $a0 '\n'
		syscall
		jr $ra

###########################################################
PrintNewLine:	li $v0 11	# print char
		li $a0 '\n'
		syscall
		jr $ra

###########################################################
PrintSpace:	li $v0 11	# print char
		li $a0 ' '
		syscall
		jr $ra

#######################################################
GetFileName:	addi $sp $sp -4
		sw $ra ($sp)
		li $v0 4		# print string
		la $a0 REQUEST_FILENAME
		syscall
		li $v0 8		# read string
		la $a0 FILE_NAME  # up to 256 characters into this memory
		li $a1 256
		syscall
		la $a0 FILE_NAME 
		jal TrimNewline
		lw $ra ($sp)
		addi $sp $sp 4
		jr $ra

###########################################################
GetAlgorithm:	addi $sp $sp -4
		sw $ra ($sp)
		li $v0 4		# print string
		la $a0 REQUEST_ALGORITHM
		syscall
		li $v0 5		# read integer
		la $a0 ALGORITHM_NUMBER  # only 1 integer into this memory
		li $a1 1
		syscall
		la $a0 ALGORITHM_NUMBER
		jal TrimNewline
		la $a0 ALGORITHM_NUMBER
		lw $ra ($sp)
		addi $sp $sp 4
		jr $ra

###########################################################
# Given a null terminated text string pointer in $a0, if it contains a newline
# then the buffer will instead be terminated at the first newline
TrimNewline:	lb $t0 ($a0)
		beq $t0 '\n' TNLExit
		beq $t0 $0 TNLExit	# also exit if find null termination
		addi $a0 $a0 1
		b TrimNewline
TNLExit:		sb $0 ($a0)
		jr $ra

###################################################
# END OF PROVIDED CODE... 
# TODO: use this space below to implement required procedures
###################################################

##################################################
# null terminated buffer is in $a0
# algorithm number is in $a1 (1 = complement, 2 = odd parity)
			


GenerateChecksum:	 
			addi $sp $sp -4 
			sw $ra 0($sp) #store return address to generate on line 118 
			
			move $t1 $a0 #use t1 for buffer pointer
			beq $a1 1 Complement
			beq $a1 2 Parity
			
				
Complement:  		
			li $v0 0 #initialize result  
			

LoopComplement:		
			lb $t2 0($t1)#load one char to t2 
			beq $t2 $0 DoneComplement #if null then end loop 
			add $v0 $v0 $t2 #otherwise add ascii value
			addi $t1 $t1 1 #move pointer, get the next char in the text buffer 
			j LoopComplement


DoneComplement:		
			nor $t3 $v0 $0 #1's complement
			addi $v0 $t3 1 #add 1, 2's complement
			sb $v0 ($t1) #store to buffer 
			
			lw $ra 0($sp)
			addi $sp $sp 4 #free the stack 
			jr $ra #go back to "generate"on line 118 , v0 is checksum char 
			

Parity:  		
			li $v0 0 #initialize result  
			

LoopParity:		
			lb $t2 0($t1)#load one char to t2 
			beq $t2 $0 DoneParity #if null then end loop 
			xor $v0 $v0 $t2 #otherwise xor ascii value
			addi $t1 $t1 1 #move pointer, get the next char in the text buffer 
			j LoopParity


DoneParity:		
			move $t5 $v0 #move result to t5 
			not $v0 $t5 #invert all bits since we want the negation of xor 
			sb $v0 ($t1) #store to buffer 
			
			lw $ra 0($sp)   
			addi $sp $sp 4 #free the stack 
			jr $ra #go back to "generate" on line 118, V0 is checksum char 





##################################################
# null terminated buffer is in $a0
# algorithm number is in $a1 (1 = complement, 2 = parity)
ValidateChecksum: # TODO: Implement this function!
			addi $sp $sp -4 
			sw $ra 0($sp) #store return to validate branch 
			
			move $t1 $a0 #use t1 for buffer pointer 
			beq $a1 1 ComplementV  #if algorithm is 1 branch to Complement 
			beq $a1 2 ParityV  #if algorithm is 2 branch to Parity 
						
			
ComplementV:  		
			li $v0 0 #initialize result  
			

LoopComplementV:		
			lb $t2 0($t1)#load one char to t2 
			beq $t2 $0 DoneComplementV #if null then end loop 
			add $v0 $v0 $t2 #otherwise add ascii value
			addi $t1 $t1 1 #move pointer,get the next char in the text buffer 
			j LoopComplementV


DoneComplementV:	
			andi $t1 $v0 0xFF #mask to ignore overflow, getting the last 8 bits 
			beq $t1 0 Validated #if sum is 0 then branch to print validate 
			bne $t1 0 NotValidated #if sum is not 0 then branch to print not validated  	
			
			

			
ParityV:  		
			li $v0 0 #initialize result  
			

LoopParityV:		
			lb $t2 0($t1)#load one char to t2 
			beq $t2 $0 DoneParityV #if null then end loop 
			xor $v0 $v0 $t2 #otherwise xor ascii value
			addi $t1 $t1 1 #move pointer, get the next char in the text buffer 
			j LoopParityV


DoneParityV:		
			move $t5 $v0 #move result to t5, which should be 11111111
			not $v0 $t5 #invert all bits and store result back in v0 
			beqz $v0 Validated #if v0 is 0 then branch to print validate 
			bnez $v0 NotValidated #if v0 is not 0 then branch to print not validated  
			
		
Validated:		li $v0 4		# print string
			la $a0 VALIDATED
			syscall	
			lw $ra 0($sp) #get address of "validate" from memory 
			addi $sp $sp 4 #free the stack 
			jr $ra #go back to "validate" on line 128  
		
NotValidated:		li $v0 4		# print string
			la $a0 NOT_VALIDATED
			syscall	
			lw $ra 0($sp) #get address of "validate" from memory
			addi $sp $sp 4 #free the stack
			jr $ra #go back to "validate" on line 128 		
