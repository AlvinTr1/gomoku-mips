.data
blankSpace: .asciiz "  "
largeSpace: .asciiz "     "
lastMovePrompt: .asciiz "Last Move: "
XOlabel: .asciiz "   X     O"
.text
.globl print_screen

print_screen:
		move $t0, $a0				#index of computer row 
		move $t1, $a1				#index of  computer column 
		move $t2, $a2				#index of  player row 
		move $t9, $a3				#index of  player column 
		
		addi $sp, $sp, -4				# make room for stack 
		sw $ra, 0($sp)				# store $ra	
		jal print_table					#jump and link to print_table
		
		li $v0, 4						#code for print string
		la $a0, lastMovePrompt		#load address of lastMovePrompt
		syscall						#print string
		
		li $v0, 11						#print new line
		li $a0, '\n'
		syscall
		
		li $v0, 4						#code for print string
		la $a0, XOlabel				#load address of XOlabel
		syscall						#print string
		
		li $v0, 11						#print new line
		li $a0, '\n'
		syscall
		
		li $v0, 4						#print blankSpace
		la $a0, blankSpace
		syscall
		
		li $v0, 1						# print index of player row 
		move $a0, $t2
		syscall
		
		li $v0, 11						# print index of player column 
		move $a0, $t9
		syscall
		
		li $v0, 4						#print largeSpace
		la $a0, largeSpace
		syscall
		
		li $v0, 1						# print index of computer row 
		move $a0, $t0
		syscall
		
		li $v0, 11						# print index of computer column
		move $a0, $t1
		syscall
		
		li $v0, 11						#print new line
		li $a0, '\n'
		syscall
		
		lw $ra, 0($sp)					# load register address
		addi $sp, $sp, 4           			# restore stack 
		jr $ra
