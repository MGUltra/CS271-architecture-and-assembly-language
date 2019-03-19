TITLE Assignment 5 - Random number generator   (GarnerAssignment5.asm)

; Author:	Matt Garner
; E-mail:	garnemat@oregonstate.edu
; CS 271 / Assignment 5                Date: 5/22/16 (5/24/16 with 2 Grace Days)
; Description: This program takes a request for an amount of random numbers from the user
; between 10 and 200. Populates an array with their requested random numbers. Displays the
; Unsorted list, sorts the list, then displays the sorted list. After which the median value 
; is calculated and displayed.

INCLUDE Irvine32.inc

; Constant Definitions

MIN	=	10
MAX	=	200
LO	=	100
HI	=	999


.data

;	Number Variables

request			DWORD ?					; Number chosen by the user
array			DWORD MAX DUP(?)		; Array of numbers, uninitialized

; String Variables

str_intro1		BYTE "Assignment 5 - Random Number Generator",0
str_intro2		BYTE "Programmed By Matt Garner",0
str_inst1		BYTE "How many random numbers would you like me to list?",0
str_inst2		BYTE "Enter a positive number between 10 and 200: ",0
str_error		BYTE "That number is not between 10 and 200.",0
str_goodbye1	BYTE "I hope you enjoyed this program.",0
str_median		BYTE "The median value is: ",0
str_titleU		BYTE "Unsorted List: ",0
str_titleS		BYTE "Sorted List: ",0
str_spaces		BYTE "   ",0




.code
main PROC

	call randomize								; Seed the random number generator


; 1 - INTRODUCTION
	
	call introduction							; call introduction procedure




; 2 - GET DATA FROM USER
	
	push OFFSET request							; parameter: request (by reference)
	call getData								; call getData procedure


	

; 3 - FILL THE ARRAY

	push OFFSET array							; parameter: array (by reference)
	push request								; parameter: request (by value)
	call fillArray								; call fillArray procedure




; 4 - DISPLAY UNSORTED ARRAY
	
	push OFFSET str_titleU						; parameter: str_titleU (by reference)
	push OFFSET array							; parameter: array (by reference)
	push request								; parameter: request (by value)
	call displayList							; call displayList procedure




; 5 - SORT ARRAY

	push OFFSET array							; parameter: array (by reference)
	push request								; parameter: request (by value)
	call sortList								; call sortList procedure




; 6 - DISPLAY SORTED ARRAY

	push OFFSET str_titleS						; parameter: str_titleS (by reference)
	push OFFSET array							; parameter: array (by reference)
	push request								; parameter: request (by value)
	call displayList							; call displayList procedure




; 7 - DISPLAY MEDIAN VALUE

	push OFFSET array							; parameter: array (by reference)
	push request								; parameter: request (by value)
	call displayMedian							; call displayMedian procedure



	exit	; exit to operating system
main ENDP




;----------------------------------------------------------------------------------
; Procedure name: introduction
; Parameters: none (uses global string variables)
; output: introduction strings are output
; Description: This procedure simply introduces the program and the programmer
;----------------------------------------------------------------------------------

introduction PROC

	pushad
	mov		ebp,esp

	mov		edx,OFFSET str_intro1			; output introduction
	call	WriteString

	call	Crlf

	mov		edx,OFFSET str_intro2			; output introduction continued
	call	WriteString

	call	Crlf
	call	Crlf

	popad
	ret
introduction ENDP




;----------------------------------------------------------------------------------
; Procedure name: getData
; Parameters: request by reference (strings are global variables)
; output: user choice saved to address of request
; Description: this procedure gets the amount of random numbers the user wants to create
; validates the input and then stores the value in the memory address of the request
; variable
;----------------------------------------------------------------------------------

getData PROC

	push	ebp
	mov		ebp,esp

getNumber:

	mov		edx, OFFSET str_inst1			; give instructions
	call	WriteString

	call	Crlf

	mov		edx, OFFSET str_inst2			; give instructions
	call	WriteString

	call	ReadDec

	cmp		eax, MAX						; test if input greater than MAX
	ja		invalidInput					; jump to 'invalidInput' if true

	cmp		eax, MIN						; test if input is lower than MIN
	jb		invalidInput					; jump to 'invalidInput' if true

	jmp		validNumber

	

invalidInput:
	
	call	Crlf

	mov		edx, OFFSET str_error			; display error error 
	call	WriteString

	call	Crlf

	jmp		getNumber						; jump to getNumber to reprompt user for input

validNumber:

	mov		ebx,[ebp+8]						; move address of request into ebx
	mov     [ebx],eax						; move the contents of eax into the dereferenced address of request

	pop		ebp								; pop ebp
	ret 4									; ret 4 to balance stack

getData ENDP




;----------------------------------------------------------------------------------
; Procedure name: fillArray
; Parameters: array by reference, request by value
; output: none
; Description: random numbers are placed into the array. the amount of numbers placed
; is determined by the choice made by the user. 
;----------------------------------------------------------------------------------

fillArray PROC

	pushad										; push registers onto stack to preserve their values
	mov		ebp, esp

	mov		ecx, [ebp + 36]						; Move requested value to loop counter

	mov		esi, [ebp + 40]						; Move array address to esi register

	mov		eax, HI								; Move HI value to eax
	sub		eax, Lo								; Subtrack Lo value from eax
	inc		eax									; increment eax by 1

addNumber:
	call	RandomRange							; Call RandomRange from irvine library
	add		eax, LO								; add LO to eax to get the proper range

	mov		[esi], eax							; move random number to array
	add		esi, 4								; increment esi to next array element

	loop addNumber								; Loop until total number chosen by user has been added

	popad										; pop registers off the stack

	ret 8										; ret 8 to balance array since 2 arguments were passed.

fillArray ENDP




;----------------------------------------------------------------------------------
; Procedure name: sortList
; Parameters: array by reference, request by value
; output: none
; Description: the array is sorted into descending order.  exchangeElements procedure
; is called when a swap needs to be made.
;----------------------------------------------------------------------------------

sortList PROC

	pushad										; push registers onto stack to preserve their values
	mov		ebp, esp

	mov		ecx, [ebp + 36]						; Move requested value to loop counter

	dec		ecx									; decrement ecx by one since last element doesnt 
												; need to be comapared to anything after it

	mov		esi, [ebp + 40]						; Move array address to esi register

	mov		ebx, 0								; ebx will act as a flag indicating if a swap has been made

	jmp		sortArray							; jump to sortArray

exchange:

	push	esi									; push esi, the address of the current array element
	call	exchangeElements					; call exchange elements procedure

	mov		ebx, 1								; Move 1 to ebx to indicate a swap took place

	jmp		returnFromExchange					; jump to returnFromExchange

resetArray:

	mov		ecx, [ebp + 36]						; Reset requested value to loop counter

	dec		ecx									; decrement ecx

	mov		esi, [ebp + 40]						; Reset array address to esi register

	mov		ebx, 0								; Reset swap flag

sortArray:

	mov		eax, [esi]							; move array value to eax
	mov		edx, [esi + 4]						; move next value to edx

	cmp		eax, edx							; compare the values
	jb		exchange							; if eax is below edx, jump to exchange

returnFromExchange:

	add		esi, 4								; increment esi by 4 to move to next array element

	loop sortArray								; loop to sort array

	cmp		ebx, 1								; check the swap flag
	je		resetArray							; reset array is a swap took place

	popad										; pop registers off the stack
	ret 8										; ret 8 to balance array since 2 arguments were passed.

sortList ENDP




;----------------------------------------------------------------------------------
; Procedure name: exchangeElements
; Parameters: array location by reference
; output: the array values are switched
; Description: This procedure swaps the value in the array location passed by reference
; with the next element in the array.
;----------------------------------------------------------------------------------

exchangeElements PROC

	pushad										; push registers onto stack to preserve their values
	mov		ebp, esp

	mov		esi, [ebp + 36]						; Move array element address into esi register

	mov		eax, [esi]							; move array element value into eax register
	mov		ebx, [esi + 4]						; move next element value into eax register

	mov		[esi], ebx							; move ebx value into array element
	mov		[esi + 4], eax						; move eax value into next array element
												; element values are swapped 

	popad										; pop registers off the stack

	ret 4										; ret 4 to balance array since 2 arguments were passed.

exchangeElements ENDP




;----------------------------------------------------------------------------------
; Procedure name: displayMedian
; Parameters: array by reference, request by value
; output: the median number is displayed.
; Description: This procedure searches for the median number. If there are an odd
; number of numbers in the array, the median is the middle number in the sorted array
; if there are an even number, the median is the average of the middle two numbers.
;----------------------------------------------------------------------------------

displayMedian PROC

	pushad										; push registers onto stack to preserve their values
	mov		ebp, esp

	mov		eax, [ebp + 36]						; Move requested value to register

	mov		esi, [ebp + 40]						; Move array address to esi register
	
	xor		edx, edx							; zero edx since it will store remainder
	mov		ecx, 2								; move divisor to 2
	div		ecx									; divide ecx

	cmp		edx, 0								; test if there is a remainder
	je isEven									; if so, there are an even number of elements. jump to isEven

	jmp isOdd									; Otherwise jump to is Odd

isEven:

	mov		ecx, 4								; mov 4 to ecx to multiply the array index by DWORD size
	mul		ecx									; multiply ecx by eax to get array element address

	mov		ecx, [esi + eax]					; mov the larger element value, which is at esi + the product
	sub		eax, 4								; sub 4 from eax to move back one array element on next operation

	add		ecx, [esi + eax]					; add the smaller element value, which is at esi + the product

	mov		eax, ecx							; move total to eax
	mov		ecx, 2								; move 2 to ecx

	xor		edx, edx							; zero edx
	div		ecx									; divide total by 2, average is now in eax

	mov		edx, OFFSET str_median				; move string to edx
	
	call Crlf

	call WriteString							; ouput median string

	call WriteDec								; output median value stored in eax

	jmp exitProc								; jump to exitProc to exit procedure

isOdd:

	mov		ecx, 4								; mov 4 to ecx to multiply the array index by DWORD size
	mul		ecx									; multiply ecx by eax to get array element address

	mov		ecx, [esi + eax]					; mov the center element value, which is at esi + the product
	mov		eax, ecx							; move ecx to eax

	mov		edx, OFFSET str_median				; move string to edx
	
	call Crlf

	call WriteString							; ouput median string

	call WriteDec								; output median value



exitProc:

	call Crlf
	call Crlf

	popad										; pop registers off the stack
	ret 8										; ret 8 to balance array since 2 arguments were passed.

displayMedian ENDP




;----------------------------------------------------------------------------------
; Procedure name: displayList
; Parameters: title by reference, array by reference, request by value
; output: the title and contents of the array are the outputs, formatted 10 numbers per row
; Description: This procedure outputs the contents of the random number array, formatted 
; by outputting 10 numbers per row. 
;----------------------------------------------------------------------------------

displayList PROC

pushad										; push registers onto stack to preserve their values
	mov		ebp, esp

	mov		ecx, [ebp + 36]					; Move requested value to loop counter

	mov		esi, [ebp + 40]					; Move array address to esi register

	mov		edx, [ebp + 44]					; move Title to edx

	mov		ebx, 0							; numbers per row counter. inc by 1 per loop to maintain format

	call Crlf

	call 	WriteString						; output title

	call Crlf


outputArray:

	mov		eax, [esi]						; move current number at dereferenced address to eax

	call	WriteDec						; output number

	mov		edx, OFFSET str_spaces			; move spaces string to edx

	call	WriteString						; output spaces

	add		esi, 4							; increment esi by 4 to move to next array element

	inc		ebx								; increment ebx to keep track of elements per row

	cmp		ebx, 10							; check if 10 numbers have been written
	je		callNewLine						; if so, jump to callNewLine

	jmp		noNewLine						; if not, jump to noNewLine

callNewLine:
	
	call	Crlf							; call for a new line

	mov		ebx, 0							; reset number per line counter to 0

noNewLine:

	loop	outputArray						; loop to outputArray

	call	Crlf							

	popad									; pop registers
	ret 12									; ret 12 to balance stack

displayList ENDP



END main
