# MIPS Ringtone
# Jesse Dahir-Kanehl
# based on jingle bells first two lines
		
		.data
amoPrompt:	.asciiz "Enter the number of times to play the song: "	#prompt for the number of elements
		.align 2						#align memory for following array of words
		
pitch:   	.word 64, 64, 64, 64, 64, 64, 64, 67, 60, 62, 64, 65, 65, 65, 65, 65, 64, 64, 64, 64, 62, 62, 64, 62, 67
									#array of pitches for song
pitchnum:	.word 25						#number of notes in song

duration:	.word 250, 250, 500, 250, 250, 500, 250, 250, 250, 250, 1000, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 500, 500
									#array of note durations for song
# end of data segment
#============================================================================================

# begin text segment

		.text
MAIN:  		la $a0, amoPrompt					#load prompt
		addi $v0, $zero, 4					#set up string print
		syscall							#print out prompt
		add $v0, $zero, 5					#set up to read int
		syscall							#read the int
		add $s0, $zero, $v0					#put the number of repetitions into $s0
		la $s1, pitchnum					#load address of array size
		lw $s1, 0($s1)						#load value of array size into $s2
		la $s2, pitch						#load address of pitch array start
		la $s3, duration					#load address of duration array start
		addi $a0, $zero, 5000					#pauses for 5 seconds
		addi $v0, $zero, 32					# set up to pause
		syscall							# pause
FOR1:		slt $t0, $zero, $s0					#repetitions > 0
		beq $t0, $zero, END					# repetitions <= 0 go to end
		teq $zero, $zero					#immediately trap because $zero == $zero
		addi $s0, $s0, -1					# $s0--
		j FOR1							#loop
END:		addi $v0, $zero, 10					#system call for exit
		syscall							#clean termination of program
	
#============================================================================================
#Exception handling

		.ktext 0x80000180					#Trap handler
		add $k0, $zero, $v0					#save $v0
		add $k1, $zero, $a0					#save $a0
		addi $a2, $zero, 0					# use the first intsrument
		addi $a3, $zero, 90					#use volume level of 50
		addi $v0, $zero, 33					#load service number 33 for MIDI synchronous
		addi $s4, $zero, 0					# i = 0
FOR2:		slt $t0, $s4, $s1					# i < pitchnum
		beq $t0, $zero, E					# i >= pitchnum go to E
		sll $t0, $s4, 2						#multiply index by 4
		add $t0, $t0, $s2					#add to pitch base address
		lw $a0, 0($t0)						#get the current pitch into $a0
		sll $t0, $s4, 2						#multiply index by 4
		add $t0, $t0, $s3					#add to duration base address
		lw $a1, 0($t0)						#get the current duration into $a1
		syscall							#play the note
		addi $s4, $s4, 1					#i++
		j FOR2							#loop
E:		add $v0, $zero, $k0					#restore $v0
		add $a0, $zero, $k1					#restore $a0
		mfc0 $k0, $14						#CP0 reg. $14 is addr. of trapping inst.
		addi $k0,$k0,4 						# Add 4 to point to next instruction
		mtc0 $k0,$14 						# Store new address back into $14
		eret 							# Error return; set PC to value in $14
		
		.kdata
msg:
 		.asciiz "Trap generated"
 		.align 2
