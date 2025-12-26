.data
	clear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
.text
.globl clear_screen

clear_screen:
	li $v0, 4			# code to print string
	la $a0, clear			# load clear
	syscall				# print to "clear" the console 
	jr $ra				# jump back to calling function






