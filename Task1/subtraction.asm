.data
matrix_size:    .word 4       # size of each element in the matrix (4 bytes for integers)
n:              .word 3       # size of the n x n matrix
A:              .space 36     # space for n x n matrix A (4 bytes per element)
B:              .space 36     # space for n x n matrix B (4 bytes per element)
C:              .space 36     # space for n x n matrix C (4 bytes per element)

.text
main:

    # TODO: void subtract( float* A, float* B, float* C, int N )  C = A - B 
subtract: 	
		addi $sp $sp -24 
		swc1 $f20 0($sp) #save A to $f20   
		swc1 $f22 4($sp)#save B to f22
		swc1 $f24 8($sp) #save C to f24
		sw $s0 12($sp)   
		sw $s1 16($sp)
		sw $s2 20($sp)
		sw $s3 24($sp)
		
		la $s0 $a0 # address of matrix A
		la $s1 $a1 # address of matrix B
		la $s2 $a2 # address of matrix C 
		li $s3 $a3  #int N 
		la $s4 $ra #save return address 
		
		#s5, s6, s7 has the current item in matrix A B C 
		lwc1 $f20 0($s0)
		lwc1 $f22 0($s1)
		lwc1 $f24 0($s2)
		
				
		
EndSubtract: 	
		
		lwc1 $f20 0($sp)
		lwc1 $f22 4($sp)
		lwc1 $f24 8($sp) 
		 
		jr $ra

   