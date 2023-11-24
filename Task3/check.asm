# compute difference by calling subtract(A, B, A, n)
# so A-B is stored in A 
# then computes frob norm with (A, n) as inputs 

.data
    A:      .float 2.0, 4.0, 6.0, 8.0 
 

    B:      .float 1.0, 2.0, 3.0, 4.0   
       

    C:      .float 0.0, 0.0, 0.0, 0.0                 # Space for matrix C (3x3 matrix, each element is 4 bytes)
    array_size:    .word 4  
.text
main:
    # Call the subtract function
    la $a0, A          # Load address of matrix A
    la $a1, B          # Load address of matrix B
    la $a2, C          # Load address of matrix C
    li $a3, 3          # Set N (size of the matrix)

    jal subtract
    # Exit the program
    li $v0, 10
    syscall



 