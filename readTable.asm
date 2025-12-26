.data
readRowMatrixPrompt:   .asciiz "Enter a number for row: "
readColMatrixPrompt: .asciiz "Enter a number for column: "
line: .asciiz "\n"
###########################################################

.text
.globl read_table 
read_table:
	li $v0, 4							# prints string
	la $a0, readRowMatrixPrompt					# load read row prompt
	syscall								# print 

	li $v0,	5							# reads integer from input buffer
	syscall								
	move $s1, $v0							# $s1 = row size

	li $v0,	4							# prints string		
	la $a0, readColMatrixPrompt					# load read column prompt
	syscall								# print

	li $v0, 5							# code to read integer from input buffer 
	syscall								# read 
	move $s2, $v0							# $s2 = column size

	li $v0, 9							# Allocate memory
	mul $a0, $s1, $s2						# $a0 = number of bytes to read chars
	syscall								# allocate
	move $s0, $v0							# $s0 = array address

readMatrix:
    li $t3, 0								# initialize row counter

	readMatrixRow:
		bge $t3, $s1, readEndRow				# if row counter == row size then finish

		li $t4, 0						# initialize column counter 

	readMatrixCol:
		bge $t4, $s2, readEndCol

		mul $t5, $t3, $s2					# $t5 (array pointer) <-- row counter * row size 
		add $t5, $t5, $t4					# $t5 <-- row counter* row size + column counter (arithmetic and adds to)
		add $t5, $s0, $t5					# $t5 <-- base address + (row counter * row size + column counter)

		li $t7, '.'						# load '.'
		sb $t7, 0($t5)						# store '.' into array

		addiu $t4, $t4, 1					# increment inner-loop counter
		j readMatrixCol						# jump to the column to loop

	readEndCol:
		addiu $t3, $t3, 1					# increment row counter
		j readMatrixRow						# jump back to beginning of the row loop

	readEndRow:
		jr $ra							# jump back to calling function	
