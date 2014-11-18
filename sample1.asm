# MIPS Hello World
# Jesse Dahir-Kanehl

	.data 
hi:	.asciiz "Hello World!\n"	#Create a null-terminated string "Hello World!"
	.align 4			#align data segment after each string
num:	.word 5				#reserve space for a number and initialize it to 5
space:  .asciiz " "			#space to insert between numbers
	.align 4			#align data segment after each string
	
#end of data segment

#============================================================================================

#begin text segment

	.text			#instructions start here
MAIN: la $s0, hi		#load the address of string hi
      add $a0, $zero, $s0	#put address of hi in $a0 to print
      addi $v0, $zero, 4	#put 4 in $v0 for printing to a string
      syscall			#print
      la $s1, num		#load address of num for use
      lw $s1, 0($s1)		#load value of num into register
      la $s2, space		#load address of space for use
      lw $s2, 0($s2)		#load value of space into register
      addi $t0, $zero, 0	# set $t0 to 0
LOOP: slt $t1, $t0, $s1		#$t0 < num
      beq $t1, $zero, END	#go to end when done
      add $a0, $zero, $t0	#put $t1 in $a0 to print
      add $v0 $zero, 1		#set up for int print
      syscall			#print int
      add $a0, $zero, $s2	#put space in $a0
      add $v0, $zero, 11	#set up for print char
      syscall			#print char
      addi $t0, $t0, 1		# $t0++
      j LOOP			#loop!
END:  addi $v0, $zero, 10	#system call for exit
      syscall			#clean termination of program
	
	
