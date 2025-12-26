.data
	#index for row and column
	rIndexPC: .word 0
	cIndexPC: .word 0
.text

.globl computer_play 

computer_play:
	move $t9, $a0					# the cell recommended for computer to move
	move $t4, $a1					# the number of steps for location
	mul $t4, $t4, -1				# $t4 = -$t4 

	move $t5, $s1					# $t5 upper bound <-- row size
	mul $t5, $t5, $s2				# $t5 <-- row size * column size
	add $t5, $t5, $s0				# address of upper bound

	move $t6, $t9					# pointer for location 
	bge $t6, $t5, location

	li $t7, '.'					# load '.'
	lb $t8, ($t6)					# load $t9 operand
	bne $t8, $t7, location				# if value of the pointer is not ".", jump to location 
	li $t7, 'O'					# load 'O'                                       	
	sb $t7, 0($t6)					# store 'O' into the array

	sub $t6, $t6, $s0				# get offset 
	div $t6, $s2					# $t7 divide column size
	mfhi $t2					# get column index from high reg	
	sw $t2, cIndexPC				# store column index

	sub $t6, $t6, $t2				# $t7 <-- $t7 - $t2
	div $t6, $s2					# $t7 divide column size
	mflo $t2					# get row index from lower reg
	sw $t2, rIndexPC				# store row index

	j check_pc_win				# jump check_pc_win


location:
	blt $t6, $zero, random_play			# if pointer moves out of lower bound
	li $t7, '.'					# load '.'
	add $t6, $t6, $t4				# location bac
	lb $t8, ($t6)					# load operand
	bne $t8, $t7, location				# if value of the pointer is not ".", jump to location 

	li $t7, 'O'					# load 'O'
   	sb $t7, 0($t6)					# store 'O' into the array
	
	sub $t6, $t6, $s0				# get offset 
	div $t6, $s2					# $t7 divide column size
	mfhi $t2					# get column index from high reg	
	sw $t2, cIndexPC				# store column index

	sub $t6, $t6, $t2				# $t7 <-- $t7 - $t2
	div $t6, $s2					# $t7 divide column size
	mflo $t2					# get row index from lower reg
	sw $t2, rIndexPC				# store row index

	j check_pc_win				# jump check_pc_win

random_play:
	li $v0, 42					# code to generate random int
	move $a1, $s1					# $a1 is where to set the upper bound
	syscall						# generated number will be at $a0
	move $t1, $a0					# $t1 <-- row index
	sw $t1, rIndexPC

	li $v0, 42					# code to generate random int
	move $a1, $s2					# $a1 is where to set the upper bound
	syscall						# generated number will be at $a0
	move $t2, $a0					# $t2 <-- column index
	sw $t2, cIndexPC

	mul $t3, $t1, $s2				# $t5 (array pointer) <-- row index* column size 
	add $t3, $t3, $t2               		# $t5 <-- row index * column size + column index
	add $t3, $s0, $t3				# $t5 <-- base address + (row index * column size + column index)

	li $t7, '.'					# load '.'
	lb $t8, ($t3)					# load $t3 operand
	bne $t8, $t7, linear_location			# if value of the pointer not ".", jump to linear_location 

	li $t7, 'O'					# load 'O'                                       	
	sb $t7, 0($t3)					# store 'O' into array
	j check_pc_win				# jump check_pc_win

linear_location:
	bge $t3, $t5, zero_pointer			# if pointer going out of bound turn to 0
	addi $t3, $t3, 1				# pointer += 1

	lb $t8, ($t3)					# load $t3 operand
	bne $t8, $t7, linear_location			# if value of the pointer not ".", jump to linear_location 
	
	li $t7, 'O'					# load 'O'                                       	
	sb $t7, 0($t3)					# store 'O' into array
	j check_pc_win				# jump check_pc_win

zero_pointer:
	li $t3, -1
	j linear_location
	
check_pc_win:
		addi $sp, $sp, -4			# make room for stack fram
		sw $ra, 0($sp)				# store $ra	

		lw $a0, rIndexPC			# load rIndexPC
		lw $a1, cIndexPC			# load cIndexPC
		li $a2, 'O'				# load 'O' 
		li $a3, 0				# check row
		jal check_winning			# jump check_winning

		lw $a0, rIndexPC			# load rIndexPC
		lw $a1, cIndexPC            		# load cIndexPC
		li $a2, 'O'                 		# load 'O' 
		li $a3, 1                   		# check col
		jal check_winning           		# jump check_winning

		lw $a0, rIndexPC			# load rIndexPC
		lw $a1, cIndexPC            		# load cIndexPC
		li $a2, 'O'                 		# load 'O' 
		li $a3, 2                 		# check left diagonal
		jal check_winning           		# jump check_winning
		
		lw $a0, rIndexPC			# load rIndexPC
		lw $a1, cIndexPC           		# load cIndexPC
		li $a2, 'O'                		# load 'O' 
		li $a3, 3                  		# check right diagonal
		jal check_winning			# jump check_winning

		lw $ra, 0($sp)				# load register address
		addi $sp, $sp, 4			# restore stack pointer
		lw  $v0, rIndexPC
		addi $v0, $v0, 1			#add 1
		lw $v1, cIndexPC
		addi $v1, $v1, 65
		jr $ra					# jump to calling function
