check:
    # save argument matrices float* C, float* D, int N ) 
    addi $sp $sp -16 
    swc1 $f20 0($sp) # save A to $f20   
	swc1 $f22 4($sp) # save B to f22
    sw $s0 8($sp)
    sw $ra 12($sp)  # save return address 

   
    move $s0 $a2 # save arg N 
    move #s1 $a0 
    move $s2 $a1 
   


        lw $s1 0($sp)  
        lw $s2 4($sp)
        lw $s0 8($sp)
        lw $ra 12($sp)
    	addi $sp $sp 16
        jr $ra 

check:
    # save argument matrices float* C, float* D, int N ) 
     addi $sp $sp -32
    
    sw $ra 0($sp)     
	sw $s0 4($sp) 
    sw $s1 8($sp)
    sw $s2 12($sp) 
    sw $s3 16($sp) 
    sw $s4 20($sp) 
    sw $s5 24($sp) 
    sw $s6 28($sp) 

    move $s0 $a2 # save arg 
    move $s1 $a0 # save A
    move $s2 $a1 # save B 
    move $s3 $a2 # save D 

    lw $ra 0($sp)     
	lw $s0 4($sp) 
    lw $s1 8($sp)
    lw $s2 12($sp) 
    lw $s3 16($sp) 
    lw $s4 20($sp) 
    lw $s5 24($sp) 
    lw $s6 28($sp) 
    addi $sp $sp 32


