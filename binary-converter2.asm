# MIPS Binary Converter
# Jesse Dahir-Kanehl

	.data
space:  .asciiz " "			#space to insert between numbers
arr:    .word 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483647
size:   .word 32			# number of bits and size of array

# end of data segment


#============================================================================================

# begin text segment

	.text
MAIN:   add $v0, $zero, 5		#set up for read int
	syscall				#read int
	add $s0, $zero, $v0		# load new int into $s0	
	la $s2, size			#load address of array size
	lw $s2, 0($s2)			#load value of array size into $s2
	la $t0, arr			#load address of array start
	sll $t3, $s2, 2			# size * 4
	add $t1, $t3, $t0		# set $t1 to end of array plus a word's length
	addi $t1, $t1, -4		# get address of the next smaller power of 2
	lw $t2, 0($t1)			# get value of current word
	slt $t3, $t2, $s0		# if int $s0 is less than or equal to word (just for first case)
	bne $t3, $zero, ELSE		# if int $s0 is greater than word than go to else (can't happen due to precondition)
	j IF				# for the first case we skip the FOR statements and go to the IF
FOR:	addi $t1, $t1, -4		# get address of the next smaller power of 2
	slt $t2, $t1, $t0		# if current word position is less than start of array
	bne $t2, $zero, END		# if current word less than start of array go to END of program
	lw $t2, 0($t1)			# get value of current word
	slt $t3, $s0, $t2		# if int $s0 is less than word
	beq $t3, $zero, ELSE		# if int $s0 is greater than or equal to current word than go to else
IF:	addi $a0, $zero, 0		# load 0 since $s0 is less than current word
	addi $v0, $zero, 1		#set up for int print
	syscall				#print int
	j FOR				# restart loop
ELSE:   addi $a0, $zero, 1		# load 1 since $s0 is greater than or equal to current word
	addi $v0, $zero, 1		#set up for int print
	syscall				#print int
	sub $s0, $s0, $t2		#subtract from int $s0 the value of the current word
	j FOR				#restart loop
END:    li $v0, 10			#system call for exit
	syscall				#clean termination of program
