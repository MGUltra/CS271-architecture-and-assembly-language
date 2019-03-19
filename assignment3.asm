TITLE Assignment 3    (GarnerAssignment3.asm)

; Author: Matt Garner
; Email: garnemat@oregonstate.edu
; CS 271 / Assignment 3               Date: 5/1/16
; Description:	This program prompts a user to enter a negative number between -101 and 0. 
; the program keeps a running total of the amount of numbers entered, and the sum of all of the numbers.
; once a non-negative number is entered, the amount of numbers, running total, and rounded average is displayed.



INCLUDE Irvine32.inc

; Constants

lowerLimit = -100
upperLimit = -1

.data

; Number variables

current_count	DWORD 0		; amount of negative numbers entered
total_sum		DWORD 0		; running total of the sum of all negative numbers entered


; User Name variable
char_limit = 50
nameIn BYTE char_limit+1 DUP (?)		; User's name


; String variables

str_intro1		BYTE "Assignment 3 - Accumulator",0
str_intro2		BYTE "Programmed By Matt Garner",0
str_ask_name	BYTE "What is your name? ",0
str_hello		BYTE "Hello, ",0
str_inst		BYTE "Enter a negative number between -101 and 0: ",0
str_error		BYTE "That number is not between -101 and 0.",0
str_valid		BYTE "That number has been added.",0
str_count		BYTE "The total number of digits entered is: ",0
str_sum			BYTE "The total sum is: ",0
str_avg			BYTE "The average is: ",0
str_noNum		BYTE "You didn't enter any negative numbers.",0
str_goodbye1	BYTE "I hope you enjoyed this program.",0
str_goodbye2	BYTE "Goodbye, ",0



.code
main PROC


; INTRODUCTION

mov		edx,OFFSET str_intro1			; output introduction
call	WriteString

call	Crlf

mov		edx,OFFSET str_intro2			; output introduction continued
call	WriteString

call	Crlf
call	Crlf

mov		edx,OFFSET str_ask_name			; ask user name
call	WriteString

mov		edx,OFFSET nameIn				; get user name string
mov		ecx,char_limit
call	ReadString

call	Crlf

mov		edx, OFFSET str_hello			; greet user by name
call	WriteString
mov		edx,OFFSET nameIn
call	WriteString

call	Crlf



; USER INSTRUCTIONS / GET USER DATA

getNumber:								; Jump to here to enter another number

mov		edx, OFFSET str_inst			; give instructions
call	WriteString

call	ReadInt


; TEST THE ENTERED NUMBER

cmp		eax, upperLimit					; test if input greater than upper limit
jg Calculate							; jump to 'Calculate' if true

cmp		eax, lowerLimit					; test if input is lower than lower limit
jl tooLow								; jump to 'tooLow' if true

jmp validNumber							; jump to 'validNumber if both tests are passed



; WHEN THE NUMBER ENTERED IS TOO LOW

tooLow:									; Jump here when the number is below -100

mov		edx,OFFSET str_error			; output error message
call	WriteString

call	Crlf
jmp getNumber							; jump back to getNumber



; WHEN THE NUMBER ENTERED IS VALID

validNumber:							; Jump here when the number is valid

inc		current_count					; increment current count
add		total_sum, eax					; add number to running total
mov		edx,OFFSET str_valid			; prompt user that number was added
call	WriteString

call	Crlf
jmp getNumber							; jump back tp get number




; WHEN A NON NEGATIVE NUMBER IS ENTERED

Calculate:								; Jump when a non-negative number is entered

cmp current_count, 0					; test to see if any negative numbers were entered
je noNumber								; if not, jump to noNumber

call	Crlf


; DISPLAY TOTAL NEGATIVE NUMBERS ENTERED

mov		edx,OFFSET str_count			; Display amount of negative numbers input
call	WriteString
mov		eax, current_count				; move current_count to eax register
call	writeint						; output current_count number

call	Crlf



; CALCULATE AND DISPLAY SUM

mov		edx,OFFSET str_sum				; output sum of all numbers input
call	WriteString
mov		eax, total_sum					; move total_sum to eax
call	writeint						; output total_sum
call	Crlf



; CALCULATE AND DISPLAY AVERAGE

mov		edx,OFFSET str_avg				; output average string
call	WriteString
mov		eax, total_sum					; move total_sum to eax register
cdq										;
mov		ebx, current_count				; move current count to ebx register
idiv	ebx								; use idiv on ebx register. idiv since it is signed
call	writeint						; output with writeint
call Crlf

jmp farewell							; jump to farewell

; IF NO NEGATIVE NUMBERS ARE ENTERED

noNumber:

mov		edx,OFFSET str_noNum			; output no number string
call	WriteString

call	Crlf



; FAREWELL

farewell:

mov		edx,OFFSET str_goodbye1			; say goodbye to user by name
call	WriteString
call	Crlf
mov		edx,OFFSET str_goodbye2
call	WriteString
mov		edx,OFFSET nameIn				
call	WriteString
call	Crlf


	exit	; exit to operating system
main ENDP


END main
