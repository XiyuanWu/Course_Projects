.ORIG x3000

LD R6, top_stack_addr

; Test harness
;-------------------------------------------------

; output prompt
LEA R0, PROMPT
PUTS

; get user input
GETC
OUT 

; store user input to memory
ST R0, Array 

; count number of 1's (call function)
LD R1, PARITY_CHECK_3600 
JSRR R1

; output newline
LD R0, NEWLINE 
OUT

; output result
LEA R0, RESULT_PROMPT1 
PUTS
LD R0, Array
OUT
LEA R0, RESULT_PROMPT2
PUTS

; get final result (1 digit only)
LD R2, DEC_48
ADD R0, R2, R3
OUT

HALT

; Test harness local data
;-------------------------------------------------
top_stack_addr .FILL xFE00
PROMPT .STRINGZ "Enter a single character: "
NEWLINE .FILL #10
RESULT_PROMPT1 .STRINGZ "The number of 1's in '"
RESULT_PROMPT2 .STRINGZ "' is: "
PARITY_CHECK_3600 .FILL x3600
Array .BLKW #1
DEC_48 .FILL #48

.END

;=================================================
; Subroutine: PARITY_CHECK_3600
; R1, store user input
; R2, bit mask
; R3, counter
; R4, store bit mask result
;=================================================

.ORIG x3600

; Backup registers
ADD R6, R6, #-1 
STR R7, R6, #0 
ADD R6, R6, #-1
STR R4, R6, #0
ADD R6, R6, #-1
STR R2, R6, #0

; Code

; intialize
ADD R3, R3, #0
ADD R2, R2, #0
ADD R1, R1, #0

; load
ADD R1, R0, #0    ; transfer user input from R0 to R1
LD R2, BIT_MASK  ; R2 now has bit mask
LD R3, DEC_16    ; load counter to R3, 16 bits


COUNT_LOOP
    ; perfrom AND operation userinput(R1) with bit mask(R2), and store in R4
    AND R4, R2, R1
    ; if first bits is zero, skip; otherwise, we count
    BRz CONTINUE
    ADD R3, R3, #1   ; increment counter
    
    ; perfrom left shift
    CONTINUE
        ADD R1, R1, R1
        BRnp COUNT_LOOP
        
END_COUNT_LOOP

; Restore registers
LDR R2, R6, #0
ADD R6, R6, #1
LDR R4, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1 

RET

DEC_16    .FILL #16
BIT_MASK  .FILL x8000
.END