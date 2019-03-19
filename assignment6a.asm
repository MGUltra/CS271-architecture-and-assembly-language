TITLE Program 6a    (GarnerAssignment6a.asm)

; Author: Matt Garner
; E-Mail: garnemat@oregonstate.edu
; CS 271 / Assignment 6a                 Date: 6/5/16
; Description: This program is supposed to get 10 integers from the user as strings, turn them to integers
; to populate an array, then output them as strings again. They are to be validated as being able to 
; fit within a 32 bit register. The sum of the array and the average of the numbers are to be displayed as well.

INCLUDE Irvine32.inc




; MACROS

;----------------------------------------------------------------------------------
; Macro name: displayString
; Parameters: takes a string variable
; output: calls writeString to ouput the string passed in
; Description: This macro outputs a string by calling Writestring from the Irvine32
; library. While the edx register is utilized, it is also preserved
;----------------------------------------------------------------------------------

displayString MACRO str_output

	push	edx								; push edx to preserve register value
	
	mov		edx, OFFSET str_output			; move parameter string address to edx
	
	call	WriteString						; call writstring from Irvine32 library

	pop		edx								; pop original edx value off of stack back into edx

ENDM


;----------------------------------------------------------------------------------
; Macro name: displayString2
; Parameters: takes a string 
; output: calls writeDec to ouput the dec passed in
; Description: This is another write macro I created when I couldn't get the readVal
; procedure to properly get an integer from an input string. It calls writedec to
; output an unsigned integer passed to the macro
;----------------------------------------------------------------------------------

displayString2 MACRO str_output

	push	eax								; push edx to preserve register value
	
	mov		eax, str_output					; move parameter string address to edx
	
	call	WriteDec						; call writstring from Irvine32 library

	pop		eax								; pop original edx value off of stack back into edx

ENDM



;----------------------------------------------------------------------------------
; Macro name: getString
; Parameters: takes an input address
; output: none 
; Description: This macro calls ReadDec to get an unsigned integer from the user and
; then places the value in the dereferenced input address
;----------------------------------------------------------------------------------

getString MACRO input_address

	; NOTE: this macro doesn't preserve original value of eax so the carry flag can be used
	;		for validation after the call to readDec

	mov eax, 0						; zero eax

	call ReadDec					; call ReadDec from Irvine32 library

	mov [input_address], eax		; move eax contents to dereferenced input_address 
	
	
ENDM





COMMENT !

Couldn't get this to work properly after several different versions. Not sure where
the problem is.

;----------------------------------------------------------------------------------
; Macro name: getString
; Parameters: string buffer address and the length
; output: the string should be
; Description: Should read input by calling readstring and save input as a 
; string of digits saved in the input buffer passed to macro
;----------------------------------------------------------------------------------

getString MACRO str_input_address, str_input_length

	
	push	edx
	push	ecx								; preserve edx and ecx registers on the stack

	mov		ecx, str_input_length			; length of string taken
	mov		edx, str_input_address			; address of string
	call	ReadString						; call ReadString from Irvine32 library
	
	pop		ecx
	pop		edx								; return edx and ecx registers from the stack	
	

ENDM

!





; CONSTANTS

	INPUT_CAP = 10					; number of integers input by User
	ASCII_HI  = 57					; ASCII for 9
	ASCII_LOW = 48					; ASCII for 0
	MAX		  = 100					; max characters to read


.data



; Number Variables

array			DWORD	INPUT_CAP DUP(?)		; Array of numbers, uninitialized
str_buffer		BYTE	MAX+1 DUP(0)			; string buffer
bufferLength	DWORD	LENGTHOF str_buffer		; length of buffer
tempNumber		DWORD	?						; temp variable


; String Variables

str_intro1		BYTE "Assignment 6 - Macros and string input",0
str_intro2		BYTE "Programmed By Matt Garner",0

str_inst1		BYTE "Enter 10 positive integers",0
str_inst2		BYTE "Each number must fit within a 32-bit register",0

str_inst3		BYTE "Please enter an unsigned integer: ",0

str_error		BYTE "That number is invalid. ",0

str_goodbye1	BYTE "I hope you enjoyed this program.",0

str_array		BYTE "you entered the numbers: ",0
str_sum			BYTE "The Sum is: ",0
str_average		BYTE "The average value is: ",0
str_comma		BYTE ", ",0
str_spaces		BYTE "  ",0




.code
main PROC


	displayString	str_intro1					; call displayString macro for intros and instructions
	call	Crlf

	displayString	str_intro2
	call	Crlf
	call	Crlf

	displayString	str_inst1
	call	Crlf

	displayString	str_inst2
	call	Crlf
	call	Crlf


	; ReadVal - get integers from user

	push	OFFSET	tempNumber					; push tempNumber address onto stack
	push	OFFSET	array						; push array address onto stack
	call	ReadVal								; call ReadVal


	; WriteVal - Display array of integers for user

	push	OFFSET	array						; push array address onto stack
	call	WriteVal							; call WriteVal



	; arraySum - Display the sum and average of input integers

	push	OFFSET	array						; push array address onto stack
	call	arraySum							; call arraySum



	call	Crlf

	displayString str_goodbye1					; call displayString macro to say goodbye

	call	Crlf
	call	Crlf



	; Original call to readVal that I couldn't get working

	;push	OFFSET	runningTotal				; push address of runningTotal onto stack
	;push	OFFSET	str_buffer					; push address of string buffer onto stack
	;push	OFFSET	array						; push address of array onto stack
	;push	OFFSET	bufferLength				; push address of bufferLength onto stack
	;call readVal								; call readVal procedure to get integers



	exit	; exit to operating system
main ENDP


;----------------------------------------------------------------------------------
; Procedure name: ReadVal
; Parameters: the address to array and address to tempnumber
; output: the array is populated with 10 valid integers
; Description: This procedure calls the getstring macro to get an inputvalue, validates
; it and then put the value into an array until there are 10 valid input values.
;----------------------------------------------------------------------------------

ReadVal PROC

	push	ebp
	mov		ebp, esp
	
	mov		ecx, INPUT_CAP					; setup loop counter
	mov		esi, [ebp + 8]					; save array address in esi
	

populateArray:								; loop return

	displayString str_inst3					; call displayString macro for instructions

	
	getString [ebp + 12]					; call getstring macro with tempnumber address
	jc inputError							; jump to inputError if macro sets carry flag
	mov		eax, [ebp + 12]					; mov tempnumber value to eax

	jnc validInput							; jump to validImput if no carry flag is set

inputError:									; imput error
	
	displayString str_error					; call displaystring macro for error prompt
	
	mov		edi, 0							; reset edi register to 0
	mov		eax, 0							; reset eax register to 0

	jmp populateArray						; jump to beginging of loop without decrementing ecx
	
	
validInput:

	mov		[esi], eax						; mov eax contents (valid input) into array address
	add		esi,4							; increment array address
	mov		edi, 0							; reset edi register to 0
	mov		eax, 0							; reset eax register to 0


loop populateArray							; loop until 10 valid integers have been chosen
	
	
	pop		ebp								; pop ebp
	ret		8								; return 8 bytes for array and tempnumber address
	
ReadVal ENDP


;----------------------------------------------------------------------------------
; Procedure name: WriteVal
; Parameters: take the address to the array as a parameter
; output: calls macro displaystring(2) to display the array 
; Description: This procedure displays the array of valid input integers to the user
;----------------------------------------------------------------------------------

WriteVal PROC

	push	ebp
	mov		ebp, esp
	
	mov		ecx, INPUT_CAP					; setup loop counter
	mov		esi, [ebp + 8]					; save array address in esi
	
	displayString str_array					; call displayString to display array contents

displayArray:								; display array loop

	displayString2 [esi]					; call displayString2 with dereferenced esi

	add		esi, 4							; increment esi by 4

	displayString str_spaces				; call displaystring macro to include spaces

	loop displayArray						; loop until all 10 integers in array have been displayed

	call	Crlf

	pop		ebp								; pop ebp

	ret		4								; ret 4 for array address

WriteVal ENDP


;----------------------------------------------------------------------------------
; Procedure name: arraySum
; Parameters: take the address to the array as a parameter
; output: Displays the sum and average of the input integers
; Description: This procesure adds the contents of the array and then outputs both the sum
; and the average
;----------------------------------------------------------------------------------

arraySum PROC

	push	ebp
	mov		ebp, esp
	
	mov		ecx, INPUT_CAP					; setup loop counter
	mov		esi, [ebp + 8]					; save array address in esi

	mov		ebx, 0							; move zero to ebx

sumArray:									; sum array loop

	add		ebx,[esi]						; add derefenced value at esi to ebx

	add		esi, 4							; increment esi by 4 to move to next array value

	loop sumArray							; loop until all values added together

	call Crlf

	displayString str_sum					; call displaystring to display sum prompt

	displayString2 ebx						; call displaystring2 to display ebx contents

	call	crlf

	mov		edx, 0							; zero edx and eax, move ebx contents to eax, then zero ebx
	mov		eax, 0
	mov		eax, ebx
	mov		ebx, 0

	call	crlf

	mov		ebx, 10							; move 10 into ebx to act as the divisor

	div		ebx								; use div to divide value currently in eax by ebx, which is 10

	displayString str_average				; call displayString to display average prompt

	displayString2 eax						; call displayString2 to display eax contents, which is the average

	call	crlf

	pop ebp									; pop ebp

	ret	4									; ret 4 for array address to balance stack

arraySum ENDP







COMMENT !

I was never able to get this procedure to work. It seemed to get stuck in an infinite loop, which
I suspect was caused by trying to validate the values. Or perhaps my getString macro has an error.
I've included the code to see if you could spot the problem. This has gone through several changes
so it may look a bit jumbled in places.

;----------------------------------------------------------------------------------
; Procedure name: ReadVal
; Parameters: addresses of the array, the string buffer, the lenghtof the string buffer
; and the RunningTotal variable
; output: This procedure will output prompts for bad values
; Description: This procedure will call getstring to get an input string of digits, convert
; them to an integer, validate them, then place them in an array
;----------------------------------------------------------------------------------

ReadVal PROC

	push	ebp
	mov		ebp, esp

	mov		ecx, INPUT_CAP			; set up loop counter

; Get Data from the user		

GetData:							; getData loop
	
	mov		eax, 0					; move 0 to eax
	mov		[ebp+20], eax			; move eax to address of runningTotal

	displayString str_inst3			; call displayString macro to output instructions

	mov		edx, [ebp+16]			; move address of buffer into edx
	mov		edi, [ebp+12]			; move address of array into edi


	getString edx, [ebp+8]			; call getString with edx, the buffer, and dereferenced address of buffer length 

	push	ecx						; push ecx on stack to preserve loop counter
	xor		ecx, ecx				; clear ecx
	xor		eax, eax				; clear eax
	mov		esi, edx				; move buffer holding input to esi in preparation for lodsb
	
ByteIterator:						; move through string buffer with lodsb
	
	lodsb

	; CHECK FOR END OF STRING

	cmp		ax, 0					; test for null terminator
	je		CompleteTask			; jump to completeTask if found



	; VALIDATE ASCII RANGE

	cmp		ax, ASCII_HI			; test against ASCII value for 9
	ja		InvalidNumber			; jump to invalidnumber if above

	cmp		ax, ASCII_LOW			; test against ASCII value for 0
	jb		InvalidNumber			; jump to invalidnumber if below



	; CALCULATE VALUE OF DIGIT

	sub		ax, ASCII_LOW			; subtract 48 from ax to get integer
	mov		ebx, 10					; mov 10 to ebx 
	mul		ebx						; multiply by ebx (10) to preserve numbers place
	jc		InvalidNumber			; jump to invalidNumber if carry flag  is set

	add		[ebp+20], eax			; otherwise, add eax contents to dereferenced runningtotal 
	mov		eax, 0					; zero eax
	
	jmp ByteIterator				; jump back to ByteIterator to move to next digit in string



; IF VALUE IS INVALID

InvalidNumber:						; if invalid

	DisplayString str_error			; call displaystring macro to prompt the error
	call Crlf
	jmp		GetData					; return to getdata without decrementing loop counter


; Finished

CompleteTask:						; complete task after string is calculated
					
	mov		eax, [ebp+20]			; move runningtotal value to eax
	mov		[edi], eax				; move eax to array address
	add		edi, 4					; increment edi by 4

loop GetData						; loop until there are 10 valid inputs

	pop		ebp						; pop ebp
	ret 16							; ret 16 for 4 passed addresses

ReadVal ENDP


!



END main 
