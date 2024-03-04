#####################################################################
# Programmer: Jacob St Lawrence
# Last Modified: 03.22.2023
#####################################################################
# Functional Description:
# This program prompts the user to enter a string of up to 100
# characters. It then removes all white space, numbers, and special
# characters from the string and displays the resulting string.
#####################################################################
# Pseudocode:
# 	print input prompt
#	read string into input
#	set s0 as pointer to input string
#	set s1 as pointer to output string
#	if first character of input string is '\n'; end
# loop:
#	t5 = s0
#	if t5 == '\n'; branch to endLoop
#	if t5 < 'A'; branch to notLetter
#	if t5 > 'z'; branch to notLetter
#	if t5 >= 'A' && t5 <= 'Z'; branch to letter
#	if t5 <= 'z' && t5 >= 'a'; branch to letter
#	else branch to notLetter
# notLetter:
#	s0 ++
#	branch to loop
# letter:
#	s1 = t5
#	s0 ++; s1 ++
#	branch to loop
# endLoop:
#	print result message
#	print output string
# 	reset s1 pointer to output string
#	set s2 as pointer to count array
#	t6 = 'A'
#	s3 = 0
#	print '\n'
# freq:
#	t7 = s1
#	if t7 == '\n'; branch to nextLetter
#	if t7 == t6; branch to isLetter
#	t8 = t6 + 32
#	if t7 == t8; branch to isLetter
#	s1 ++
#	branch to freq
# isLetter:
#	s1 = 0
#	s3 ++
#	s1 ++
#	branch to freq
# nextLetter:
#	s2 = s3
#	s2 += 4
#	s3 = 0
#	reset s3 to base address of output string
#	t6 ++
#	if t6 > 'Z'; branch to endfreq
#	else branch to freq
# endfreq:
#	reset s2 to base address of count array
#	s4 = 0
#	print tableh string
# printfreq:
#	t9 = s2
#	s4 ++
#	print t9
#	print ' '
#	if s4 == 13; print '\n'
#	if s4 == 26; branch to exitprint
#	s2 += 4
#	branch to printfreq
# exitprint:
#	branch to main
# end:
#	print bye string
#	terminate program
#####################################################################
# Register Usage:
# $s0: Pointer Input String
# $s1: Pointer Output String
# $s2: Pointer Count Array
# $s3: Character Counter
# $s4: Iteration Counter
# $t0: Newline Character
# $t1: 'A'
# $t2: 'Z'
# $t3: 'a'
# $t4: 'z'
# $t5: Holder for Current Byte from Input String
# $t6: Holder for Upper Case Letter to Check
# $t7: Holder for Current Byte from Output String
# $t8: Holder for Lower Case Letter to Check
# $t9: Holder for Current Byte from Count Array
#####################################################################

	.data
input:	.space	101
output:	.space	101
count:	.space	104
prompt:	.asciiz	"\nPlease enter a string, or press ENTER to end program: "
result:	.asciiz	"The string with only letters is: "
space:	.asciiz	" "
nline:	.asciiz "\n"
tableh:	.asciiz "Letter Frequency Table\n"
bye:	.asciiz	"Goodbye!"

	.text
main:
	li	$v0, 4			# system call code to print string
	la	$a0, prompt		# load prompt string into argument
	syscall				# print prompt string

	li	$v0, 8			# system call code for read string
	la	$a0, input		# load address for space for string into argument
	li	$a1, 101		# load max string length into argument
	syscall				# read string

	la	$s0, input		# make s0 a pointer to the base address of the input string
	la	$s1, output		# make s1 a pointer to the base address of the output string

	li	$t0, '\n'		# initialize t0 to the terminating character
	li	$t1, 'A'		# initialize t1 to the first uppercase letter 'A'
	li	$t2, 'Z'		# initialize t2 to the last uppercase character 'Z'
	li	$t3, 'a'		# initialize t3 to the first lower case letter 'a'
	li	$t4, 'z'		# initialize t4 to the last lower case letter 'z'

	lb	$t5, ($s0)		# load the byte from the input array into t5
	beq	$t5, $t0, end		# if byte is terminating character, branch to end

# loop to check each character from string
loop:
	lb	$t5, ($s0)		# load the byte from the input array into t5
	beq	$t5, $t0, endLoop	# if the byte is equal to the terminating character, branch to endLoop
	blt	$t5, $t1, notLetter	# if the byte is less than 'A' it is not a letter
	bgt	$t5, $t4, notLetter	# if the byte is greater than 'z' it is not a letter
	ble	$t5, $t2, letter	# if the byte has passed the above lines, and is <= 'Z' it is a letter
	bge	$t5, $t3, letter	# if the byte has passed the above lines, and is >= 'a' it is a letter
	b	notLetter		# else it is not a letter

# if not a letter, move to next character of input string without copying to output string
notLetter:
	addi	$s0, $s0, 1		# increment to next byte of input string
	b	loop			# branch to loop for next iteration

# if a letter, copy to output string and move to next character of each string
letter:
	sb	$t5, ($s1)		# store byte containing identified letter in current index of output string
	addi	$s0, $s0, 1		# increment to next byte of input string
	addi	$s1, $s1, 1		# increment to next byte of output string
	b	loop			# branch to loop for next iteration

# display results before moving on to frequency table
endLoop:
	li	$v0, 4			# system call code to print string
	la	$a0, result		# load address of result string into argument
	syscall				# print result string

	li	$v0, 4			# system call code to print string
	la	$a0, output		# load address of output string into argument
	syscall				# print output string

	la	$s1, output		# reset s1 to point to base address of output string
	la	$s2, count		# make s2 a pointer to the base address of the count array
	li 	$t6, 'A'		# load 'A' into t6 for checking
	li	$s3, 0			# load 0 into s3 for character counter

	li	$v0, 4			# system call code to print string
	la	$a0, nline		# load nline string into argument for printing
	syscall				# print nline string

# loop to check each letter against each character in output string
freq:
	lb	$t7, ($s1)		# load current byte from output string
	beq	$t7, $t0, nextLetter	# if it is terminating character, branch to nextLetter
	beq	$t7, $t6, isLetter	# if it is current letter, branch to isLetter

	addi	$t8, $t6, 32		# convert letter to lowercase
	beq	$t7, $t8, isLetter	# if current byte matches, branch to isLetter
	addi	$s1, $s1, 1		# else, increment to next character in output string

	b	freq			# branch back to freq for next iteration

# if identified match, zero out index, increment counter and increment index of output string
isLetter:
	sb	$zero, ($s1)		# clear character at current index of output string
	addi	$s3, $s3, 1		# increment counter
	addi	$s1, $s1, 1		# increment to next character in output string
	b	freq			# branch back to freq for next iteration

# store count in array and move to next letter
nextLetter:
	sb	$s3, ($s2)		# store counter value in current index of count array
	addi	$s2, $s2, 4		# increment to next index in count array

	move	$s3, $zero		# reset counter to 0
	la	$s1, output		# reset pointer s1 to base address of output string

	addi	$t6, $t6, 1		# increment t6 to next letter
	bgt	$t6, 'Z', endfreq	# if t6 is greater than 'Z', branch to endfreq

	b	freq			# else, branch back to freq for next iteration

# print table header and prepare for printing frequency table
endfreq:
	la	$s2, count		# make s2 a pointer for the base address of count array
	move	$s4, $zero		# initialize s4 with zero for iteration count

	li	$v0, 4			# system call code to print string
	la	$a0, tableh		# load tableh string into argument for printing
	syscall				# print tableh string

# loop to print each integer from the count array
printfreq:
	lb	$t9, ($s2)		# load integer from count array into t9
	addi	$s4, $s4, 1		# increment iteration counter

	li	$v0, 1			# system call code to print integer
	move	$a0, $t9		# move current integer into argument for printing
	syscall				# print integer

	li	$v0, 4			# system call code to print string
	la	$a0, space		# load space string into argument for printing
	syscall				# print space string

	beq	$s4, 13, newLine	# if at 13th iteration, branch to newLine for formatting

	beq	$s4, 26, exitprint	# if at 26th iteration, branch to exitprint
	addi	$s2, $s2, 4		# increment to next integer in count array

	b	printfreq		# branch to printfreq for next iteration

# move to next line after 13 integers have been displayed
newLine:
	li	$v0, 4			# system call code to print string
	la	$a0, nline		# load nline string into argument for printing
	syscall				# print nline string

	addi	$s2, $s2, 4		# increment to next integer index of count array

	b	printfreq		# branch back to printfreq for next iteration

# jump to main for next input string
exitprint:
	b	main			# branch back to main to go again

# display bye message and terminate program
end:
	li	$v0, 4			# system call code to print string
	la	$a0, bye		# load bye string into argument for printing
	syscall				# print bye string

	li	$v0, 10			# system call code to terminate program
	syscall				# terminate program

					# END OF PROGRAM
