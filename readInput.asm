.data           
array: .space 6    #Array of 6 elements to open up space
char: .space 2 	   #variable to reserve up 2 bytes
userMovePrompt: .asciiz "input (Ex: 2 A)? "
errorMessage: .asciiz "Invalid move. Try again: \n" #print this message when user inputs an invalid move
space: .ascii " " #single blank space 
newLine: .asciiz "\n"
.text           
.globl read_input

read_input:
	li $v0, 4				# print string
	la $a0, userMovePrompt			# load address of  userMovePrompt message 
	syscall					# print userMovePrompt message

	la $s4, array					# set base address of array to $s4
	li $t2, 0					# load 0 in register $t2
	loop:					
		li $v0, 8				# code to read string
		la $a0, char				# load address of char for reading
		li $a1, 2				# length = 2 (1byte will be char and 1byte is null)
		syscall					# syscall to store the char byte from input buffer into char

		lb $t0, char				# load the char from the char buffer into t0, removing null
		sb $t0, 0($s4)				# store the char into the nth elem of array
		addi $t2, $t2, 1			# length of array += 1

		lb $t1, newLine				# load newLine 
		beq $t0, $t1, parseInputString  	# checks to see if end of string (user presses enter),  jump to parseInputString 

		addi $s4, $s4, 1			# increments base address of array
		j loop					# jump to loop

parseInputString:           
	li $t1, 6					# set or load immediate $t1 = 6 
	bge $t2, $t1, error				# if length of input >= 6 , jump to error (not possible for a valid input to have length > 6)

	addi $s4, $s4, -1				# reposition array pointer to last char before newLine char

	la $s3, array					# set base address of array to s3 to use as a counter
	addi $s3, $s3, -1				# reposition base array to read leftmost char in string

	lb $t1, 0($s4)					# load char from array into t1
	blt $t1, 65, error				# check if char is not an uppercase letter (ascii<'A')
	bgt $t1, 90, error				# check if char is not an uppercase letter (ascii>'Z') Ascii value must be between 'A' and 'Z' for valid input


	j setCurrentColumn			# jump to setCurrentColumn

	rowLabelNumber:
		add $t6, $zero, $zero		# initialize row index to 0
		li $t0, 10					# set register $t0 = 10 for decimal conversion
		li $t3, 1					# $t3 for power of 10 	

		lb $t1, 0($s4)				# load char from array into t1
		blt $t1, 48, error			# checks to see char is not a digit (ascii<'0')
		bgt $t1, 57, error			# check char to see if it's not a digit (ascii>'9') Ascii value must be between '0' and '9' for valid input

		move $k0, $t1
		addi $t1, $t1, -48			# converts $t1's ascii value to dec value
		add $t6, $t6, $t1			# row index = $t1's dec value
		addi $s4, $s4, -1			# decrement array address	
	multiDigits:         
		mul $t3, $t3, $t0			# multiply power by 10

		beq $s4, $s3, setCurrentRow		# set row if beginning of string is reached

		lb $t1, ($s4)				# load the char from the array into $t1
		addi $t1, $t1, -48			# converts $t1's ascii value to dec value
		mul $t1, $t1, $t3			# $t1*10^(counter)
		add $t6, $t6, $t1			# row index = row index + $t1

		addi $s4, $s4, -1			# decrement array address
		j multiDigits 

	setCurrentColumn:
		move $k1, $t1
		addi $t1, $t1, -65			# convert char's ascii value to integer 
		move $t7, $t1				# $t7 = index column

		addi $s4, $s4, -2			# reposition array pointer to the next char (skip space)
		j rowLabelNumber			# jump to rowLabelNumber

	setCurrentRow:
		addi $t6, $t6, -1			# actual row index

done:
	bgt $t6, $s1, error				# error if row index > row size
	bgt $t7, $s2, error				# error if column index > column size
		
	mul $t5, $t6, $s2				# $t5 (array pointer) <-- row index* column size 
	add $t5, $t5, $t7               		# $t5 <-- row index * column size + column index
	add $t5, $s0, $t5				# $t5 <-- base address + (row index * column size + column index)

	move $v0, $t6				# return row index
	move $v1, $t7				# return column index

	li $t7, '.'					# set '.'
	lb $t8, ($t5)					# load $t5 operand
	bne $t8, $t7, error				# check if $t7 is not equal to $t8 (overlap), jump to error
	li $t7, 'X'						# load 'X'
	sb $t7, 0($t5)					# store 'X' into array
	jr $ra						# jump back to calling function

error:
li $v0, 4							# code to print string
la $a0, errorMessage				# load errorMessage
syscall							# print errorMessage

j read_input						# print read_input


