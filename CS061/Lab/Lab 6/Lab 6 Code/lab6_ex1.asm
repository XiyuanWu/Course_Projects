.ORIG x3000

; Initialize the stack. Don't worry about what that means for now.
LD R6, top_stack_addr ; DO NOT MODIFY, AND DON'T USE R6, OTHER THAN FOR BACKUP/RESTORE
LEA R1, ARRAY

; call function
LD R0, SUB_GET_STRING_3200
JSRR R0

; print array
LEA R0, ARRAY
PUTS

HALT

; your local data goes here

top_stack_addr .Fill xFE00 ; DO NOT MODIFY THIS LINE OF CODE
SUB_GET_STRING_3200 .FILL x3200
ARRAY   .BLKW #100
.END

;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING_3200
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;	terminated by the [ENTER] key (the "sentinel"), and has stored 
;	the received characters in an array of characters starting at (R1).
;	the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of non-sentinel chars read from the user.
;	R1 contains the starting address of the array unchanged.
;-------------------------------------------------------------------------

.ORIG x3200

; back up 1 2 3 4 7
ADD R6, R6, #-1
STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
ADD R6, R6, #-1
STR R4, R6, #0
ADD R6, R6, #-1
STR R7, R6, #0

AND R5, R5, #0  ; intilize R5 to 0

; function code

LEA R0, PROPMT
PUTS

; 1. Get input and out
; 2. Ckeck if R0 is newline
; 3. Store user input(always in R0) in array(R1)
; 4. Increment size, R1 and R5
GET_STRING_LOOP
    GETC
    OUT
    ADD R2, R0, #-10   ; check if R0 is 0(newline)
    BRz END_GET_STRING_LOOP
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R5, R5, #1
    BR GET_STRING_LOOP
END_GET_STRING_LOOP

; restore 7 4 3 2 1
LDR R7, R6, #0 
ADD R6, R6, #1
LDR R4, R6, #0 
ADD R6, R6, #1
LDR R3, R6, #0 
ADD R6, R6, #1
LDR R2, R6, #0 
ADD R6, R6, #1
LDR R1, R6, #0 
ADD R6, R6, #1

; return

RET  ; R7

; data 
PROPMT .STRINGZ "Enter a string: "
NEWLINE .FILL x0A


.END



