.data
    float_array:   .float 2.5, 3.7, 1.2, 4.8, 5.3  # Example array of floats
    array_size:    .word 5                           # Size of the array

.text
main:
    # Load the address of the float_array into $a0
    la $a0, float_array

    # Load the size of the array into $a1
    lw $a1, array_size

    # Call the print_float_array function
    jal print_float_array

    # Exit the program
    li $v0, 10
    syscall

# Function to print an array of floats
# Arguments: $a0 = address of the array, $a1 = size of the array
print_float_array:
    # Loop index
    li $t0, 0
    la $t1 ($a0) 

    # Loop to print each element of the array
    loop:
        # Check if we have processed all elements
        bge $t0, $a1, end_loop

        # Load the current float element into $f12
        lwc1 $f12 ($t1)
        # Print the float
        li $v0, 2        # System call code for printing a float
        syscall

        # Print a space
        li $v0, 11       # System call code for printing a character
        li $a0, 32       # ASCII code for space
        syscall

        # Increment the loop index and move to the next float in the array
        addi $t0, $t0, 1
        addi $t1, $t1, 4

        # Repeat the loop
        j loop

    end_loop:
        jr $ra    # Return from the function
