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