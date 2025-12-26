.data
singleSpace: .asciiz "  "
tripleSpace: .asciiz "   "
newLine: .asciiz "\n"
lastMovePrompt: .asciiz "Last move: "
pVSc: .asciiz "X/you      vs.    O/computer"

.text
.globl print_table 

										# s1 = row size, s2 = column size
print_table:
	li $t3, 0								# initialize register #t3 to print first row of  letters that label the columns
	li $v0, 4								# code to print string
	la $a0, tripleSpace							# load triple space
	syscall									# print
	printColumnLetter:
		beq $t3, $s2, printBoard					# check if register $t3 is equal to column size, jump to print_matrix

		li $v0, 11							# code to print char
		addi $a0, $t3, 65						# get char's ascii value
		syscall								# print

		li $v0, 4							# code to print string
		la $a0, singleSpace						# load space
		syscall								# print

		addi $t3, $t3, 1						# t3 += t3

		j printColumnLetter						# jump back to printColumnLetter

	printBoard:
		li $v0, 4							# code to print string
		la $a0, newLine							# load newLine
		syscall								# print

		li $t3, 0							# initialize row counter

	printBoardRow:
		bge $t3, $s1, print_letterFinalSet			# if row counter >= row size --> all rows have been printed --> print letter row at the bottom
		li $t4, 0						# initialize the counter for columns

		addi $t7, $t3, 1					# initialize register $t7 to check if row counter is 1 digit
		div $t8, $t7, 10					# get the quotient
		beq $t8, $zero, print_column_1_digit			# if row counter is 1 digit, print 1 digit
									# otherwise just print
		li $v0, 1						# code to print integer	
		move $a0, $t7						# $a0 = row number starting at 1
		syscall							# print

		li $v0, 4						# code to print string
		la $a0, singleSpace					# load space
		syscall							# print

		printBoardColumn:
		bge $t4, $s2, printBoardEndOfColumn		# if column counter >= column size ? go to next row

		mul $t5, $t3, $s2							# $t5 (array pointer) <-- row counter * column size 
		add $t5, $t5, $t4							# $t5 <-- row counter* column size + column counter
		add $t5, $s0, $t5							# $t5 <-- base address + (row counter * row size + column counter)


		li $v0, 11								# code to print char
		lb $a0, 0($t5)								# load array pointer to $a0
		syscall									# print

		li $v0, 4								# code to print string
		la $a0, singleSpace							# load space
		syscall									# print

		addiu $t4, $t4, 1							# increment column counter

		j printBoardColumn							# jump back to printBoardColumn
		
		printBoardEndOfColumn:
		li $v0, 4								# code to print string
		la $a0, newLine								# load newLine
		syscall									# print

		addiu $t3, $t3, 1							# increment row counter

		j printBoardRow								# jump back to printBoardRow
		
	printBoardEndOfRow:
		li $v0, 11
		li $a0, '\n'	
		syscall		
		
		li $v0, 4
		la $a0, pVSc
		syscall
		
		li $v0, 11
		li $a0, '\n'	
		syscall					
		jr $ra									# jump back to calling function

	print_column_1_digit:
		li $v0, 4								# code to print string
		la $a0, singleSpace							# load space
		syscall									# print
		
		li $v0, 1								# code to print integer
		move $a0, $t7								# load row numer
		syscall									# print	

		li $v0, 4								# code to print string
		la $a0, singleSpace							# load space
		syscall									# print

		j printBoardColumn							# jump to printBoardColumn

print_letterFinal:
		beq $t3, $s2, printBoardEndOfRow					# if t3 equals to column size, jump to print_matrix

		li $v0, 11								# code to print char
		addi $a0, $t3, 65							# get char's ascii value
		syscall									# print

		li $v0, 4								# code to print string
		la $a0, singleSpace							# load space
		syscall									# print

		addi $t3, $t3, 1							# t3 += t3

		j print_letterFinal							# jump back to print_letter
	
print_letterFinalSet:
		li $t3, 0
		li $v0, 4								# code to print string
		la $a0, tripleSpace							# load triple space
		syscall		
		j print_letterFinal


