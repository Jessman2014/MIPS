# MIPS Insertion Sort
# Jesse Dahir-Kanehl

	.data
space:  .asciiz " "		#space to insert between numbers
.align 2			#align memory for following array of words
arr1:  .space 80		#space for array of 20 words (20 * 4 = 80 btyes)

# end of data segment


#============================================================================================

# begin text segment

	.text
MAIN:   add $v0, $zero, 5						#set up to read int
	syscall								#read the int
	add $s0, $zero, $v0						#put the number of elements of the array into $s0
	la $s1, arr1							#put address of array start into $s1
	la $s2, space							#load address of space for use
	lw $s2, 0($s2)							#load value of space into register
	addi $s3, $zero, 0						#int i = 0
FOR1:	slt $t0, $s3, $s0						#create a for loop with i < elements in the array
	beq $t0, $zero, END1						#if i >= element number then go to END1 of loop
	addi $v0, $zero, 5						#set up to read int
	syscall								#read the int
	sll $t0, $s3, 2							#multiply index by 4
	add $t0, $t0, $s1						#add offset to base address
	sw $v0, 0($t0)							#store read int into array
	addi $s3, $s3, 1						# i++
	j FOR1								#loop!
END1:	add $a0, $zero, $s1						#put address of array start into first argument
	add $a1, $zero, $s0						#put number of elements in array into second argument
	jal INSORT							#call insertion sort method
	addi $s3, $zero, 0						#int i = 0
FOR2:	slt $t0, $s3, $s0						#create a for loop with i < elements in the array
	beq $t0, $zero, END2						#if i >= element number then go to END2 of loop
	sll $t0, $s3, 2							#multiply index by 4
	add $t0, $t0, $s1						#add offset to base address
	lw $t0, 0($t0)							#read int from array
	add $a0, $zero, $t0						#put int into $a0 for print
	addi $v0, $zero, 1						#set up to print int
	syscall								#print the int
	add $a0, $zero, $s2						#put the space into $a0 for print
	addi $v0, $zero, 11						#set up for char print
	syscall								#print the space
	addi $s3, $s3, 1						# i++
	j FOR2								#loop!
END2:	addi $v0, $zero, 10						#system call for exit
	syscall								#clean termination of program
	
#============================================================================================
#Begin Insertion Sort subroutine

INSORT: addi $sp, $sp, -12						#make space on stack for local variables
	sw $s0, 0($sp)							#store $s0
	sw $s1, 4($sp)							#store $s1
	sw $s2, 8($sp)							#store $s2
	addi $s0, $zero, 1						#int c = 1
	addi $t0, $a1, -1						# n - 1, n is second argument
FOR3:	slt $t1, $t0, $s0						# n-1 < c
	bne $t1, $zero, END3						# n-1 < c go to end
	add $s1, $zero, $s0						# d = c
WHILE:  sll $t1, $s1, 2							#shift index d by multiplying by 4
	add $t1, $t1, $a0						#add offset to base address in first argument
	lw $t1, 0($t1)							#put arr[d] into $t1
	addi $t2, $s1, -1						#calculate value of index
	sll $t2, $t2, 2							#shift index d-1 by multiplying by 4
	add $t2, $t2, $a0						#add offset to base address in first argument
	lw $t2, 0($t2)							#put arr[d-1] into $t2
	slt $t3, $zero, $s1						# 0 < d
	beq $t3, $zero, END4						# 0 >= d go to END4
	slt $t3, $t1, $t2						# arr[d] < arr[d-1]
	beq $t3, $zero, END4						# arr[d] >= arr[d-1] go to END4
	add $s2, $zero, $t1						# t = arr[d]
	sll $t3, $s1, 2							#shift index d by multiplying by 4
	add $t3, $t3, $a0						#add offset to base address in first argument
	sw $t2, 0($t3)							# arr[d] = arr[d-1]
	addi $t3, $s1, -1						#calculate value of index
	sll $t3, $t3, 2							#shift index d-1 by multiplying by 4
	add $t3, $t3, $a0						#add offset to base address in first argument
	sw $s2, 0($t3)							#arr[d-1] = t
	addi $s1, $s1, -1						# d--
	j WHILE								#while loop!
END4:  addi $s0, $s0, 1							# c++
	j FOR3								#for3 loop!
END3:	lw $s0, 0($sp)							#restore $s0
	lw $s1, 4($sp)							#restore $s1
	lw $s2, 8($sp)							#restore $s2
	addi $sp, $sp, -12						#pop stack
	jr $ra								#return to caller
	
#============================================================================================	