# MIPS Merge Sort
# Jesse Dahir-Kanehl and Jonathan Loeffelholz

		.data
space:  	.asciiz " "						#space to insert between numbers
		.align 2						#align memory for following array of words
arrY:   	.space 80						#space for array Y of 20 words (20 * 4 = 80 btyes)
arrAux		.space 80						#space for array Aux of 20 words (20 * 4 = 80 btyes)

# end of data segment


#============================================================================================

# begin text segment

		.text
MAIN:  		add $v0, $zero, 5					#set up to read int
		syscall							#read the int
		add $s0, $zero, $v0					#put the number of elements of the array into $s0
		la $s1, arr1						#put address of array start into $s1
		la $s2, space						#load address of space for use
		lw $s2, 0($s2)						#load value of space into register
		addi $s3, $zero, 0					#int i = 0
FOR1:		slt $t0, $s3, $s0					#create a for loop with i < elements in the array
		beq $t0, $zero, END1					#if i >= element number then go to END1 of loop
		addi $v0, $zero, 5					#set up to read int
		syscall							#read the int
		sll $t0, $s3, 2						#multiply index by 4
		add $t0, $t0, $s1					#add offset to base address
		sw $v0, 0($t0)						#store read int into array
		addi $s3, $s3, 1					# i++
		j FOR1							#loop!
END1:		add $a0, $zero, $s1					#put address of array start into first argument
		add $a1, $zero, $s0					#put number of elements in array into second argument
		jal MERGESORT						#call merge sort method
		addi $s3, $zero, 0					#int i = 0
FOR2:		slt $t0, $s3, $s0					#create a for loop with i < elements in the array
		beq $t0, $zero, END2					#if i >= element number then go to END2 of loop
		sll $t0, $s3, 2						#multiply index by 4
		add $t0, $t0, $s1					#add offset to base address
		lw $t0, 0($t0)						#read int from array
		add $a0, $zero, $t0					#put int into $a0 for print
		addi $v0, $zero, 1					#set up to print int
		syscall							#print the int
		add $a0, $zero, $s2					#put the space into $a0 for print
		addi $v0, $zero, 11					#set up for char print
		syscall							#print the space
		addi $s3, $s3, 1					# i++
		j FOR2							#loop!
END2:		addi $v0, $zero, 10					#system call for exit
		syscall							#clean termination of program
	
#============================================================================================
#Begin MergeSort subroutine

MERGESORT:	addi $sp, $sp, -12					#make space on stack for local variables
		sw $a0, 0($sp)						#store $a0
		sw $a1, 4($sp)						#store $a1
		sw $ra, 8($sp)						#store $ra
		la $a1, arrAux						#put address of array start into $a1
		addi $a3, $a1, -1					#SizeY-1 into $a3
		addi $a2, $zero, 0					#put 0 into $a2
		jal MERGESORT1						#call mergesort1(Y, Aux, 0, SizeY-1)
		lw $a0, 0($sp)						#restore $a0
		lw $a1, 4($sp)						#restore $a1
		lw $ra, 8($sp)						#restore $ra
		addi $sp, $sp, 12					#pop the stack
		jr $ra							#return to caller

	
#============================================================================================	
#Begin MergeSort1 subroutine

MERGESORT1:	addi $sp, $sp, -20					#make space on stack for local variables
		sw $a0, 0($sp)						#store $a0
		sw $a1, 4($sp)						#store $a1
		sw $a2, 8($sp)						#store $a2
		sw $a3, 12($sp)						#store $a3
		sw $ra, 16($sp)						#store $ra
		slt $t0, $a2, $a3					# s < e
		beq $t0, $zero, END3					# s >= e go to end
		add $t0, $a2, $a3					# (s+e)
		srl $a3, $t0, 1						# (s+e)/2
		jal MERGESORT1						# mergesort1(Y, A, s, (s+e)/2)
		lw $a3, 12($sp)						#restore $a3
		add $t0, $a2, $a3					# (s+e)
		srl $t0, $t0, 1						# (s+e)/2
		addi $a2, $t0, 1					# (s+e)/2+1
		jal MERGESORT1						# mergesort1(Y, A, (s+e)/2+1, e)
		lw $a2, 12($sp)						#restore $a2
		add $t0, $a2, $a3					# (s+e)
		srl $t0, $t0, 1						# (s+e)/2
		addi $a3, $t0, 1					# (s+e)/2+1
		### stuff happens
		jal MERGE						# merge(Y, A, s, (s+e)/2+1, e)
END3:		lw $a0, 0($sp)						#restore $a0
		lw $a1, 4($sp)						#restore $a1
		lw $a1, 8($sp)						#restore $a2
		lw $a1, 12($sp)						#restore $a3
		lw $ra, 16($sp)						#restore $ra
		addi $sp, $sp, 20					#pop the stack
		jr $ra							#return to caller

	
#============================================================================================	
#Begin Merge subroutine

MERGE:		addi $sp, $sp, -24					#make space on stack for local variables
		sw $a0, 0($sp)						#store $a0
		sw $a1, 4($sp)						#store $a1
		sw $a2, 8($sp)						#store $a2
		sw $a3, 12($sp)						#store $a3
		### LEAF method
		sw $ra, 20($sp)						#store $ra
		add $s1, $zero, $a2					# int i = s1
		add $s2, $zero, $a3					# int j = s2
		add $s3, $zero, $a2					# int k = s1
W1:		slt $t0, $s1, $a3					# i < s2
		beq $t0, $zero, W2					# i >= s2 go to second while
		slt $t0, $s0, $s2					# e2 < j
		bne $t0, $zero, W2					# e2 < j go to second while
		sll $t0, $s1, 2						# multiply index i by 4
		add $t0, $t0, $a0					#add index to base address of array Y
		lw $t0, 0($t0)						# Y[i]
		sll $t1, $s2, 2						# multiply index j by 4
		add $t1, $t1, $a0					#add index to base address of array Y
		lw $t1, 0($t1)						# Y[j]
		slt $t2, $t0, $t1					# Y[i] < Y[j]
		beq $t2, $zero, ELSE					# Y[i] >= Y[j] go to ELSE
		sll $t1, $s3, 2						# multiply index k by 4
		add $t1, $t1, $a1					#add index to base address of array A
		sw $t0, 0($t1)						# A[k] = Y[i]
		addi $s1, $s1, 1					# i++
		j LUP1							# jump over else to loop update
ELSE:		sll $t0, $s3, 2						# multiply index k by 4
		add $t0, $t0, $a1					#add index to base address of array A
		sw $t1, 0($t0)						# A[k] = Y[j]
		addi $s2, $s2, 1					# j++
LUP1:		addi $s3, $s3, 1					# k++
		j W1							# loop to first while
W2:		slt $t0, $s1, $a3					# i < s2
		beq $t0, $zero, W3					# i >= s2 go to third while
		sll $t0, $s1, 2						# multiply index i by 4
		add $t0, $t0, $a0					#add index to base address of array Y
		lw $t0, 0($t0)						# Y[i]
		sll $t1, $s3, 2						# multiply index k by 4
		add $t1, $t1, $a1					#add index to base address of array A
		sw $t0, 0($t1)						# A[k] = Y[i]
		addi $s1, $s1, 1					# i++
		addi $s3, $s3, 1					# k++
		j W2							# loop to second while
W3:		slt $t0, $s0, $s2					# e2 < j
		bne $t0, $zero, E3					# e2 < j go to end of third while
		sll $t0, $s2, 2						# multiply index j by 4
		add $t0, $t0, $a0					#add index to base address of array Y
		lw $t0, 0($t0)						# Y[j]
		sll $t1, $s3, 2						# multiply index k by 4
		add $t1, $t1, $a1					#add index to base address of array A
		sw $t0, 0($t1)						# A[k] = Y[j]			
		addi $s2, $s2, 1					# j++
		addi $s3, $s3, 1					# k++
		j W3							# loop to third while
E3:		add $s1, $zero, $a2					# i = s1
W4:		slt $t0, $s0, $s1					# e2 < i
		bne $t0, $zero, E4					# e2 < i go to end of method
		sll $t0, $s1, 2						# multiply index i by 4
		add $t0, $t0, $a1					#add index to base address of array A
		lw $t0, 0($t0)						# A[i]
		sll $t1, $s1, 2						# multiply index i by 4
		add $t1, $t1, $a0					#add index to base address of array Y
		sw $t0, 0($t1)						# Y[i] = A[i]
		addi $s1, $s1, 1					# i++	
E4:		lw $a0, 0($sp)						#restore $a0
		lw $a1, 4($sp)						#restore $a1
		lw $a1, 8($sp)						#restore $a2
		lw $a1, 12($sp)						#restore $a3
		### stuff
		lw $ra, 20($sp)						#restore $ra
		addi $sp, $sp, 24					#pop the stack
		jr $ra							#return to caller
			
