        # Print a space
        li $v0, 11       # System call code for printing a character
        li $a0, 32       # ASCII code for space
        syscall

        li $v0 1
        move $a0 $t0 
        syscall 

        lwc1 $f12 ($t3)
        li $v0 2
        syscall
