# MIPS Decrease
# Jesse Dahir-Kanehl

	.data
space:  .asciiz " "		#space to insert between numbers

# end of data segment


#============================================================================================

# begin text segment

	.text
MAIN:   add $v0, $zero, 5		#set up for read int
	syscall				#read int
	add $s0, $zero, $v0		# load new int into $s0	
	la $s2, space			#load address of space for use
	lw $s2, 0($s2)			#load value of space into register
	addi $s1, $zero, 12		#initializes $s1 to 12
FOR:    beq $s1, $zero, END		#if $s1 equal to zero then end the loop
	add $a0, $zero, $s0		#put value of $s0 in $a0 for print
	add $v0, $zero, 1		#set up for int print
	syscall				#print int
	add $a0, $zero, $s2		#put space in $a0
	add $v0, $zero, 11		#set up for print char
	syscall
	addi $s0, $s0, -7		#decrease $s0 by 7
	addi $s1, $s1, -1		# decrease $s1 by 1
	j FOR				# loop!
END:    addi $v0, $zero, 10		#system call for exit
	syscall				#clean termination of program