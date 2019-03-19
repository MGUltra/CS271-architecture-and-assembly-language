TITLE Program Template     (GarnerAssignment6a.asm)

; Author: Matt Garner
; E-Mail: garnemat@oregonstate.edu
; CS 271 / Assignment 6a                 Date: 6/5/16
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here)


; MACROS

;----------------------------------------------------------------------------------
; Macro name: displayString
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------

displayString MACRO str_output

	push	edx								; push edx to preserve register value
	
	mov		edx, OFFSET str_output			; move parameter string address to edx
	
	call	WriteString						; call writstring from Irvine32 library

	pop		edx								; pop original edx value off of stack back into edx

ENDM

;----------------------------------------------------------------------------------
; Macro name: getString
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------

getString MACRO str_input_address, str_input_length

	
	push	edx
	push	ecx

	mov		ecx, str_input_length			; length of string taken
	mov		edx, str_input_address			; address of string
	call	ReadString						; call ReadString from Irvine32 library



	
	pop		ecx
	pop		edx
	

ENDM



; CONSTANTS

	INPUT_CAP = 10					; number of integers input by User
	ASCII_HI  = 57					; ASCII for 9
	ASCII_LOW = 48					; ASCII for 0
	MAX		  = 100					; max characters to read


.data

; (insert variable definitions here)

;	Number Variables


array			DWORD	INPUT_CAP DUP(?)		; Array of numbers, uninitialized
str_buffer		BYTE	MAX+1 DUP(0)			; string buffer
bufferLength	DWORD	LENGTHOF str_buffer		; length of buffer
RunningTotal	DWORD	?


; String Variables

str_intro1		BYTE "Assignment 6 - Macros and string input",0
str_intro2		BYTE "Programmed By Matt Garner",0

str_inst1		BYTE "Enter 10 positive integers",0
str_inst2		BYTE "Each number must fit within a 32-bit register",0

str_inst3		BYTE "Please enter an unsigned integer: ",0

str_error		BYTE "That number is invalid.",0

str_goodbye1	BYTE "I hope you enjoyed this program.",0

str_array		BYTE "you entered the numbers: ",0
str_sum			BYTE "The Sum is: ",0
str_median		BYTE "The average value is: ",0
str_comma		BYTE ", ",0
str_spaces		BYTE "  ",0




.code
main PROC

; (insert executable instructions here)

	displayString	str_intro1
	call	Crlf

	displayString	str_intro2
	call	Crlf
	call	Crlf

	displayString	str_inst1
	call	Crlf

	displayString	str_inst2
	call	Crlf
	call	Crlf

	push	OFFSET	runningTotal
	push	OFFSET	str_buffer					; push address of string buffer onto stack
	push	OFFSET	array
	push	OFFSET	bufferLength
	call readVal





	exit	; exit to operating system
main ENDP

; (insert additional procedures here)


;----------------------------------------------------------------------------------
; Procedure name: ReadVal
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------

ReadVal PROC

	push	ebp
	mov		ebp, esp

	mov		ecx, INPUT_CAP

; Get Data from the user		

GetData:
	
	mov		eax, 0
	mov		[ebp+20], eax

	displayString str_inst3

	mov		edx, [ebp+16]			; move address of buffer into edx
	mov		edi, [ebp+12]			; move address of array into edi


	getString [ebp+12], [ebp+8]

	push	ecx
	xor		ecx, ecx
	xor		eax, eax
	mov		esi, edx				; move buffer holding input to esi in preparation for lodsb
	
ByteIterator:
	
	lodsb

	; CHECK FOR END OF STRING
	cmp		ax, 0
	je		CompleteTask


	; VALIDATE ASCII RANGE

	cmp		ax, ASCII_HI
	ja		InvalidNumber

	cmp		ax, ASCII_LOW
	jb		InvalidNumber


	; CALCULATE VALUE OF DIGIT

	sub		ax, ASCII_LOW
	xchg	eax, ecx
	mov		ebx, 10
	mul		ebx
	jc		InvalidNumber

	add		[ebp+20], eax
	mov		eax, 0
	
	jmp ByteIterator



; IF VALUE IS INVALID

InvalidNumber:

	DisplayString str_error
	call Crlf
	jmp		GetData


; Finished

CompleteTask:
	add		eax, ecx
	mov		eax, [ebp+20]
	mov		[edi], eax
	add		edi, 4

loop GetData



	pop		ebp
	ret 8

ReadVal ENDP


;----------------------------------------------------------------------------------
; Procedure name: WriteVal
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------



;----------------------------------------------------------------------------------
; Procedure name: arraySum
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------



;----------------------------------------------------------------------------------
; Procedure name: arrayAverage
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------



;----------------------------------------------------------------------------------
; Procedure name: arrayDisplay
; Parameters: 
; output: 
; Description: 
;----------------------------------------------------------------------------------

END main
