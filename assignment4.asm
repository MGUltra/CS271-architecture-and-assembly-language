TITLE Assignment 4 - Composite numbers    (GarnerAssignment4.asm)

; Author: Matt Garner
; Email: garnemat@oregonstate.edu
; CS 271 / Assignment 4                 Date: 5/8/16
; Description: This program asks the user to choose a number between 1 and 400, and then will
; output that many composite numbers.

INCLUDE Irvine32.inc

; constant definitions

upperLimit = 400
lowerLimit = 1

.data

; Number Variables

numberIn		DWORD ?		; number chosen by user, amount of composites to display
currentCount	DWORD 0		; current output count, resets after 10, used to preserve format
currentNum		DWORD 4		; starting number to test


; Prime numbers to test
prime1			DWORD 2
prime2			DWORD 3
prime3			DWORD 5
prime4			DWORD 7
prime5			DWORD 11
prime6			DWORD 13
prime7			DWORD 17
prime8			DWORD 19


; User Name variable

char_limit = 50
nameIn BYTE char_limit+1 DUP (?)		; User's name

; String Variables

str_intro1		BYTE "Assignment 4 - Composite Numbers",0
str_intro2		BYTE "Programmed By Matt Garner",0
str_ask_name	BYTE "What is your name? ",0
str_hello		BYTE "Hello, ",0
str_inst1		BYTE "How many composite numbers would you like me to list?",0
str_inst2		BYTE "Enter a positive number between 0 and 400: ",0
str_error		BYTE "That number is not between 0 and 400.",0
str_goodbye1	BYTE "I hope you enjoyed this program.",0
str_goodbye2	BYTE "Goodbye, ",0

str_spaces		BYTE "   ",0


.code
main PROC

	call	introduction

	call	getUserData

	call	showComposites

	call	farewell

	exit	; exit to operating system

main ENDP




; INTRODUCTION PROCEDURE

introduction PROC

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

	ret

introduction ENDP




; GETUSERDATA PROCEDURE

getUserData PROC

getnumber:

	mov		edx, OFFSET str_inst1			; give instructions
	call	WriteString

	call	Crlf

	mov		edx, OFFSET str_inst2			; give instructions
	call	WriteString

	call	ReadDec

	cmp		eax, upperLimit					; test if input greater than upper limit
	ja		error							; jump to 'error' if true

	cmp		eax, lowerLimit					; test if input is lower than lower limit
	jb		error							; jump to 'error' if true


	jmp goodnumber							; jump to goodnumber if tests passed

error:

	call	Crlf
	mov		edx, OFFSET str_error			; announce error
	call	WriteString
	call	Crlf
	jmp		getnumber						; return to getnumber

goodnumber:									; jump here if input is valid

	mov		numberIn, eax

	ret										; return

getUserData ENDP




; SHOW COMPOSITES PROCEDURE

showComposites PROC


	mov		ecx, numberIn			; Move number in to ecx to act at loop counter


testComposites:						; Beginning of test loop
	
	jmp		primeDivision			; jump to test
	

returnFromWrite:					; return from write
	
	inc		currentNum				; increment currentNum

	loop	testComposites			; loop

	jmp		finished				; jump to finished after ecx = 0


primeDivision:						; test prime numbers between 2 and sqrt(495)

	; TEST 1						; test if divisible by 2

	mov		eax,currentNum			; test if equal to 2
	cmp		eax,prime1
	je		noWrite					; if so jump to noWrite since it is prime

	xor		edx,edx					; set edx to zero
	div		prime1					; divide by prime1
	cmp		edx,0					; test for remainder
	je		writeCurrent			; jump to writeCurrent if no remainder, otherwise continue with more tests

	; TEST 2						; test if divisible by 3

	mov		eax,currentNum			; test if current num is equal to prime2, if so jump to noWrite
	cmp		eax,prime2
	je		noWrite

	xor		edx,edx
	div		prime2					; divide current number by prime2, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	; TEST 3						; test if divisible by 5

	mov		eax,currentNum			; test if current num is equal to prime3, if so jump to noWrite
	cmp		eax,prime3
	je		noWrite

	xor		edx,edx
	div		prime3					; divide current number by prime3, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	; TEST 4						; test if divisible by 7

	mov		eax,currentNum			; test if current num is equal to prime4, if so jump to noWrite
	cmp		eax,prime4
	je		noWrite

	xor		edx,edx
	div		prime4					; divide current number by prime4, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	; TEST 5						; test if divisible by 11

	mov		eax,currentNum			; test if current num is equal to prime5, if so jump to noWrite
	cmp		eax,prime5
	je		noWrite

	xor		edx,edx					
	div		prime5					; divide current number by prime5, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	; TEST 6						; test if divisible by 13

	mov		eax,currentNum			; test if current num is equal to prime6, if so jump to noWrite
	cmp		eax,prime6
	je		noWrite

	xor		edx,edx					
	div		prime6					; divide current number by prime6, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	; TEST 7						; test if divisible by 17

	mov		eax,currentNum			; test if current num is equal to prime7, if so jump to noWrite
	cmp		eax,prime7
	je		noWrite

	xor		edx,edx					
	div		prime7					; divide current number by prime7, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	; TEST 8						; test if divisible by 19

	mov		eax,currentNum			; test if current num is equal to prime8, if so jump to noWrite
	cmp		eax,prime8
	je		noWrite

	xor		edx,edx
	div		prime8					; divide current number by prime8, jump to writeCurrent if no remainder
	cmp		edx,0
	je		writeCurrent

	jmp		noWrite					; if none of the tests returned a 0 remainder, jump to noWrite


writeCurrent:

	mov		eax, currentNum				; move currentNum to eax register
	call	writeDec					; write currentNum
	mov		edx,OFFSET str_spaces		; Output spaces
	call	WriteString

	inc		currentCount				; increment currentCount

	cmp		currentCount,10				; if currentCount has reached 10, jump to resetCount
	je		resetCount

	jmp		returnFromWrite				; jump to return from write


resetCount:
	
	call	Crlf						; calls for an endline to preserve 10 numbers per line format
	mov		currentCount, 0				; resets currentCount to zero

	jmp		returnFromWrite				; jump to returnFromWrite

noWrite:								; when a prime number is found, jump here.
	inc		ecx							; increment ecx so loop count will equal the numbers written
	jmp		returnFromWrite				; jump to returnFromWrite

finished:

	ret									; once finished, return to main.

showComposites ENDP




; FAREWELL PROCEDURE

farewell PROC

	call	Crlf 
	mov		edx,OFFSET str_goodbye1			; say goodbye to user by name
	call	WriteString
	call	Crlf
	mov		edx,OFFSET str_goodbye2
	call	WriteString
	mov		edx,OFFSET nameIn				
	call	WriteString
	call	Crlf
	ret

farewell ENDP

END main
