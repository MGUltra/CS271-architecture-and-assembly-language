TITLE Assignment 1 math operations on input integers    (assignment1Garner.asm)

; Author: Matt Garner
; Email : garnemat@oregonstate.edu
; CS271-400 - Program 1                 Date: 4/10/16
; Description: This program takes two integers, calculates the sum, difference,
; product, quotient, and remainder and outputs the results to the screen.

INCLUDE Irvine32.inc


.data


; STRING VARIABLES

MyName BYTE "Matt Garner ",0dh,0ah,0

ProgName BYTE "Program Assignment 1 - Math operations on input ",0dh,0ah,0

Instruct1 BYTE "Enter two integers and this program will display the sum, "
          BYTE "difference, product, quotient, and remainder.",0dh,0ah,0

prompt1 BYTE "Enter the first integer: ",0

prompt2 BYTE "Enter the second integer: ",0

good_bye BYTE "Thank You. Goodbye!",0

str_sum BYTE " + ",0

str_dif BYTE " - ",0

str_pro BYTE " x ",0

str_quo BYTE 32,246,32, 0

str_rem BYTE " remainder ",0

str_equ BYTE " = ",0

str_space BYTE " ",0



; INTEGER VARIABLES

integer_1 DWORD 0     ; variable for first input integer
integer_2 DWORD 0     ; variable for second input ingeter

cal_sum DWORD 0     ; variable for the sum calculation
cal_dif DWORD 0     ; variable for the difference calculation
cal_pro DWORD 0     ; variable for the product calculation
cal_quo DWORD 0     ; variable for the quotient calculation
cal_rem DWORD 0     ; variable for the remainder calculation




.code
main PROC

; INTRODUCTION


mov edx,OFFSET MyName     
call WriteString             ; Display My Name

mov edx,OFFSET ProgName
call WriteString             ; Display Program Name

call CrLF

mov edx,OFFSET Instruct1
call WriteString             ; Display Instructions




; GET DATA FROM USER

; Get Integer 1

mov edx,OFFSET prompt1       
call WriteString             ; Prompt for integer 1

call ReadDec                 ; Get integer 1
mov integer_1,eax            ; Move integer 1 from eax to integer_1 variable


; Get Integer 2

mov edx,OFFSET prompt2       
call WriteString             ; Prompt for integer 2

call ReadDec                 ; Get integer 2
mov integer_2,eax            ; Move integer 2 from eax to integer_2 variable

call Crlf




; PERFORM CALCULATIONS


; ADDITION

mov eax,integer_1            ; Move integer_1 to eax
add eax,integer_2            ; Add integer_2 to eax
mov cal_sum, eax             ; Move the sum in eax to cal_sum variable



; SUBTRACTION

mov eax, integer_2           ; Move integer_2 to eax
neg eax                      ; change the value in eax to negative
add eax, integer_1           ; Add integer_1 to eax value
mov cal_dif, eax             ; Move difference in eax to cal_dif variable



; MULTIPLICATION

mov eax, integer_1           ; Move integer_1 to eax
mov ebx, integer_2           ; Move integer_2 to ebx
mul ebx                      ; Multiply ebx by eax
mov cal_pro, eax             ; move product in eax to cal_pro variable



; DIVISION and REMAINDER

mov eax, integer_1           ; Move integer 1 to eax
cdq                          
mov ebx, integer_2           ; Move integer 2 to ebx
div ebx                      ; Divide eax value by ebx value
mov cal_quo, eax             ; Move quotient from eax to cal_quo variable
mov cal_rem, edx             ; Move remainder from edx to cal_rem variable




; DISPLAY THE RESULTS


; DISPLAY SUM

mov eax, integer_1       
call WriteDec            ; Display integer 1

mov edx,OFFSET str_sum
call WriteString         ; Display addition sign

mov eax, integer_2
call WriteDec            ; Display integer 2

mov edx,OFFSET str_equ
call WriteString         ; Display equals sign

mov eax, cal_sum
call WriteDec            ; Display sum

call Crlf




; DISPLAY DIFFERENCE

mov eax, integer_1
call WriteDec            ; Display integer 1

mov edx,OFFSET str_dif
call WriteString         ; Display minus sign

mov eax, integer_2
call WriteDec            ; Display integer 2

mov edx,OFFSET str_equ
call WriteString         ; Display equals sign

mov eax, cal_dif
call WriteDec            ; Display difference

call Crlf




; DISPLAY PRODUCT

mov eax, integer_1
call WriteDec            ; Display integer 1

mov edx,OFFSET str_pro
call WriteString         ; Display multiplication sign

mov eax, integer_2
call WriteDec            ; Display integer 2

mov edx,OFFSET str_equ
call WriteString         ; Display equals sign

mov eax, cal_pro
call WriteDec            ; Display product

call Crlf



; DISPLAY QUOTIENT AND REMAINDER

mov eax, integer_1
call WriteDec            ; Display integer 1

mov edx,OFFSET str_quo
call WriteString         ; Display division sign

mov eax, integer_2
call WriteDec            ; Display integer 2

mov edx,OFFSET str_equ
call WriteString         ; Display equals sign

mov eax, cal_quo
call WriteDec            ; Display quotient

mov edx,OFFSET str_rem
call WriteString         ; Display remainder string

mov eax, cal_rem
call WriteDec            ; Display remainder


call Crlf
call Crlf



; SAY GOODBYE

mov edx,OFFSET good_bye
call WriteString 

call Crlf



	exit	; exit to operating system
main ENDP

END main
