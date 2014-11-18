# MIPS while loop
# Jesse Dahir-Kanehl

	.data
space:  .asciiz " "		#space to insert between numbers

# end of data segment


#============================================================================================

# begin text segment

	.text
MAIN:   la $s0, space			#load address of space for use
	lw $s0, 0($s0)			#load value of space into register
	addi $s1, $zero, 0		#initializes i to 0
	addi $s2, $zero, 0		#initializes sum to 0
WHILE:  slti $t0, $s1, 10		# i<10
	beq $t0, $zero, END		#if i<10 is false than go to end
	add $s2, $s2, $s1		# sum = sum + i
	add $a0, $zero, $s2		#put value of sum in $a0 for print
	add $v0, $zero, 1		#set up for int print
	syscall				#print int
	add $a0, $zero, $s0		#put space in $a0
	add $v0, $zero, 11		#set up for print char
	syscall
	addi $s1, $s1, 1		# i++
	j WHILE				# loop!
END:    addi $v0, $zero, 10		#system call for exit
	syscall				#clean termination of program