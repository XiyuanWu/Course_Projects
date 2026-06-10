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

; check if array palindrome
LD R0, SUB_IS_PALINDROME_3400
JSRR R0


HALT

; your local data goes here

top_stack_addr .Fill xFE00 ; DO NOT MODIFY THIS LINE OF CODE
SUB_GET_STRING_3200 .FILL x3200
SUB_IS_PALINDROME_3400 .FILL x3400
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


;-------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME_3400
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1)
;		 is a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;-------------------------------------------------------------------------

.ORIG x3400

; back up 1 2 3 5 7
ADD R6, R6, #-1
STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R6, R6, #-1
STR R7, R6, #0

; function code

; 1. get ending addr R3(end) = R1(start) + R5(size of array) - 1
ADD R3, R1, R5
ADD R3, R3, #-1

LOOP
    ; R1 and R3 now have start/end address of array, next, we load value to R0 and R2
    LDR R0, R1, #0    ; load value to R0 from address R1 (get start char)
    LDR R2, R3, #0    ; load value to R2 from address R3 (get end char)
    ; now R0 and R2 has start abd ending char
    ; 3. compare them
    NOT R0, R0        ; invert bits
    ADD R0, R0, #1    ; 2's complement
    ADD R0, R0, R2    ; compare them(R0 and R2)
    ;   if not equal, exit
        BRnp NOT_PALI
    ;   if equal: continue step 4
    ; 4. increment size, R1++, R3--
    ADD R1, R1, #1
    ADD R3, R3, #-1
    ADD R5, R5, #-2   ; array size reduce by 2
    BRp LOOP
    LEA R0, MESSAGE1
    PUTS
    BR END_NOT_PALI
    ; 5. loop step 2-4
END_LOOP

; if not pali, exit
NOT_PALI
    ADD R4, R4, #0    ; return 0
    LEA, R0, MESSAGE2
    PUTS
    BR END_NOT_PALI
END_NOT_PALI



; restore 7 5 3 2 1
LDR R7, R6, #0 
ADD R6, R6, #1
LDR R5, R6, #0 
ADD R6, R6, #1
LDR R3, R6, #0 
ADD R6, R6, #1
LDR R2, R6, #0 
ADD R6, R6, #1
LDR R1, R6, #0 
ADD R6, R6, #1

; return
RET

; data
MESSAGE1  .STRINGZ "It's palindrome"
MESSAGE2  .STRINGZ "It's not palindrome"


.END