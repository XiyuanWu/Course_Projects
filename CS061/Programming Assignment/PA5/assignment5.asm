
.ORIG x3000

; R0, user input
; R1, start address
; R2, end char
; R3, end address
; R4, 
; R5, size
; R6, backup
; R7, return address

; initialize the stack and regeister
LD R6, STACK_ADDR
LEA R1, user_array

; print welcome message
LEA R0, user_prompt
PUTS

; get a string from the user (call function)
LD R0, get_user_string_addr
JSRR R0

; print array
; LEA R0, user_array
; PUTS

; call palindrome method
LEA R1, user_array
ADD r3, r1, R5
ADD r3, r3, #-1
LD R0, palindrome_addr
JSRR R0

; add r4 with 0
; if p, it's pali   if zn not pali
ADD R4, R4, #0
BRp IS_PALINDROME
BRnz NOT_PALINDROME

IS_PALINDROME
    LEA R0, is_palid
    PUTS
    BR END_MAIN
    
NOT_PALINDROME
    ADD R4, R4, #0    ; return 0
    LEA, R0, is_not_palid
    PUTS
    BR END_MAIN

END_MAIN
LD R0, NEWLINE
OUT

HALT


; Stack address ** DO NOT CHANGE **
STACK_ADDR           .FILL    xFE00

; Addresses of subroutines, other than main
get_user_string_addr .FILL    x3200
palindrome_addr      .FILL	  x3400


; Reserve memory for strings in the progrtam
user_prompt          .STRINGZ "Enter a string: "

; Reserve memory for user input string
user_array          .BLKW	  100

is_palid             .STRINGZ "The string is a palindrome"
is_not_palid         .STRINGZ "The string is not a palindrome"
NEWLINE              .FILL #10

.END

;---------------------------------------------------------------------------------
; get_user_string: requests user to input a string
;
; parameter (R1): gets the starting address of character array
; postcondition: user is to input a string and the [ENTER] key terminates the program
;
; return value (R5): it will be the number/length of the string
;---------------------------------------------------------------------------------

.ORIG x3200
get_user_string
; Backup all used registers, R7 first, using proper stack discipline
ADD R6, R6, #-1
STR R0, R6, #0
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

; function code

AND R5, R5, #0  ; intilize R5 to 0


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

; Resture all used registers, R7 last, using proper stack discipline
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
LDR R0, R6, #0
ADD R6, R6, #1

RET

.END

;---------------------------------------------------------------------------------
; palindrome

; parameter (R1): the beginning of the string
; parameter (R5): the number of characters in array
;
; return value: R4
;---------------------------------------------------------------------------------

; R0, start char
; R1, start address
; R2, end char
; R3, end address


.ORIG x3400
palindrome ; Hint, do not change this label and use for recursive alls
; Backup all used registers, R7 first, using proper stack discipline
ADD R6, R6, #-1
STR R0, R6, #0
; ADD R6, R6, #-1
; STR R1, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0
; ADD R6, R6, #-1
; STR R3, R6, #0
; ADD R6, R6, #-1
; STR R4, R6, #0
; ADD R6, R6, #-1
; STR R5, R6, #0
ADD R6, R6, #-1
STR R7, R6, #0

; function code

; derement size by 2

ADD R5, R5, #0
; 2 base case: R5 is 0 or 1
; check if 0, return true
BRnz IS_PALI
; ; check if 1, return true
; ; assign -1 to R0, and compare R0 and R5, if R5 + R0 = 0, return true
; ADD R5, R5, #0
; LD R0, DEC_1
; ADD R5, R5, R0
; BRz IS_PALI


; actual compare process
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
    
    
; recuisive call
JSR palindrome
BR END_FUNCTION

; handle base case
IS_PALI
    ; LEA R0, is_palid
    ; PUTS
    AND R4, R4, #0
    ADD R4, R4, #1
    BR END_FUNCTION

NOT_PALI
    AND R4, R4, #0    ; return 0
    ; LEA, R0, is_not_palid
    ; PUTS
    BR END_FUNCTION

END_FUNCTION

; Resture all used registers, R7 last, using proper stack discipline
LDR R7, R6, #0
ADD R6, R6, #1
; LDR R5, R6, #0
; ADD R6, R6, #1
; LDR R4, R6, #0
; ADD R6, R6, #1
; LDR R3, R6, #0
; ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
; LDR R1, R6, #0
; ADD R6, R6, #1
LDR R0, R6, #0
ADD R6, R6, #1

RET


; is_palid             .STRINGZ "The string is a palindrome"
; is_not_palid         .STRINGZ "The string is not a palindrome"
DEC_1                .FILL #-1

.END


