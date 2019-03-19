TITLE Assignment 2 - Fibonacci Sequence   (assignment2Garner.asm)

; Author: Matt Garner
; Email: garnemat@oregonstate.edu
; CS271 / Assignment 2                 Date: 4/17/16
; Description: This program displays the fibonacci sequence. The user will input how many numbers
;              in the sequence they want displayed. 

INCLUDE Irvine32.inc

upperLimit = 46			; Upper Limit of Fibonacci Sequence terms


.data   

fib_Term_Prev DWORD 0		; previous fibonacci term
fib_Term_Curr DWORD 1		; current fibonacci term
fib_Term_Next DWORD ?		; next fibonacci term
fib_Term_Total DWORD ?		; total numbers to be displayed

output_counter DWORD 0		; Output counter


char_limit = 50
nameIn BYTE char_limit+1 DUP (?)		; User's name


; String variables

str_intro BYTE "Assignment 2 - Fibonacci Sequence",0

str_intro2 BYTE "Programmed By Matt Garner",0

str_ask_name BYTE "What is your name? ",0

str_hello BYTE "Hello, ",0

str_goodbye BYTE "Goodbye, ",0

str_goodbye2 BYTE "I hope you enjoyed this program.",0

str_instruct BYTE "Enter the number of Fibonacci terms to display. Enter an integer in the range 1 - 46",0

str_getTotal BYTE "How many terms would you like displayed? ",0

str_ooRange BYTE "That value is not in the range 1 - 46.",0

str_space BYTE "     ",0




.code
main PROC    

; INTRODUCTION

mov edx,OFFSET str_intro			; output introduction
call WriteString

call Crlf

mov edx,OFFSET str_intro2			; output introduction continued
call WriteString

call Crlf
call Crlf

mov edx,OFFSET str_ask_name			; ask user name
call WriteString

mov edx,OFFSET nameIn				; get user name string
mov ecx,char_limit
call ReadString

call Crlf

mov edx, OFFSET str_hello			; greet user by name
call WriteString
mov edx,OFFSET nameIn
call WriteString

call Crlf



; USER INSTRUCTIONS

mov edx,OFFSET str_instruct			; output instructions
call WriteString

call Crlf



; GET USER DATA

call Crlf

getNumber:							; getNumber segment used aquire fibonacci term quantity

mov edx,OFFSET str_getTotal			; prompt user to imput number
call WriteString
call ReadDec						; read number
cmp eax, upperLimit					; compare number to upperLimit constant
jle Goodnumber						; jump to good number if less than or equal to upperLimit

mov edx,OFFSET str_ooRange			; if no jump occurs, prompt user that number is bad
call WriteString
call Crlf
jmp getNumber						; jump back to getNumber to re enter value


Goodnumber:							; Goodnumber is jumped to when the input is good

mov fib_Term_Total, eax				; move eax value to fib term total
mov ecx, fib_Term_Total				; move fib term total to ecx to act as a loop counter

jmp Display							; jump to display




; DISPLAY FIBS

ResetCount:					; This segment preserves the five terms per line format

call Crlf					; new line for 5 new fibonacci terms
mov output_counter, 0		; reset output counter
jmp ReturnFromReset			; return at end of loop so ecx decrements properly

Display:					; display current term and calculate next

mov eax, fib_Term_curr		; move current term to eax
call WriteDec				; display current term

mov edx, fib_Term_Prev		; move previous term to edx
mov fib_Term_Prev, eax		; move current term to previous term variable
add edx, eax				; add current term to edx
mov fib_Term_Curr, edx		; move addition of previous and current to new current term.

inc output_Counter			; increment output counter


cmp ecx, 0					; check if loop counter is equal to zero
je goodbye					; jump to goodbye if eax is equal to zero

mov edx,OFFSET str_space	; output spaces
call WriteString

mov eax, output_counter		; move output_counter value to eax register
cmp eax, 5					; compare eax to five
je ResetCount				; if equal to 5, jump to Reset counter and start new line

ReturnfromReset:			; return from ResetCount to properly finish loop and dec ecx

loop Display				; loop to display until ecx is equal to zero




; FAREWELL

goodbye:

call Crlf
call Crlf

mov edx,OFFSET str_goodbye2
call WriteString
call Crlf
mov edx,OFFSET str_goodbye
call WriteString
mov edx,OFFSET nameIn
call WriteString

call Crlf
call Crlf



	exit	; exit to operating system
main ENDP



END main
