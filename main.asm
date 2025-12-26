########################################
#	???????????????				#
#	???????????????				#
#	????????????????????		#
#	????????????????????		#
#	????????????????????		#
#	????????????????????		#
#											#
# CS2340.001						12/1/22 #
########################################


.data
rowI: .word 0
colI: .word 0
maxMove: .word 0
drawMessage: .asciiz "Draw"
again: .asciiz "\nPlay again?(Y/N) "
pri: .word 0
pci: .word 0
cri: .word 0
cci: .word 0
.text

.globl main
main: #main driver function of the program that calls global subroutines found in other porject files

	jal read_table				#jump and link to global subroutine read_table
	jal print_table				#jump and link to gloval subroutine print_table
	move $t0, $s1			# calculate the maximum move for draw condition
	move $t1, $s0
	mul  $t0, $t0, $t1
	srl $t0, $t0, 1
	sw $t0, maxMove
	li $k0, 0
	play:
		jal player_play
		move $a0, $v0		# get the player row index
		move $a1, $v1		# get the player column index
		sw $t0, pri
		sw $t1, pci
		jal computer_play
		sw $v0, cri			# get the computer row index
		sw $v1, cci			# get the computer column index
		addi $k0, $k0, 1		# increase the move counter
		lw $t0, maxMove
		beq $k0, $t0, draw	# check for draw 
		jal clear_screen
		lw $a0, cri
		lw $a1, cci
		lw $a2, pri
		lw $a3, pci
		jal print_screen		#update screen
		j play
	
	draw:
		li $v0, 4				#code for print string
		la $a0, drawMessage	#load address of drawMessage
		syscall				#print out draw message
		
		li $v0, 4				#code for print string
		la $a0, again			#load address of again message
		syscall				#ask the player if they want to play again
	
		li $v0, 12				# get the user input
		syscall
	
		beq $v0, 89, play_again
		
		li $v0, 10				# terminate the program if user does not want to play again
		syscall
play_again:
	jal clear_screen			# clear the screen
	li $t3, 0					# reset winning counter
	j main					# start a new game from main
