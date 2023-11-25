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

