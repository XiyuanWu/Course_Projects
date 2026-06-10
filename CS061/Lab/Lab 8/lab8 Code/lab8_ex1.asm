
.ORIG x3000

; R0, load and output
; R1, ascii label
; R2, counter
; R3, store number (32766)
; R4, load postive label
; R5, load negetive label
; R6, back up
; R7, return value

LD R6, top_stack_addr

; Test harness

LD R0, LOAD_FILL_VALUE_3200
JSRR R0

; ADD R3, R3, #1     ; optional: add number by 1

LD R0, OUTPUT_AS_DECIMAL_3400
JSRR R0

HALT

; Test harness local data
top_stack_addr .FILL xFE00
LOAD_FILL_VALUE_3200 .FILL x3200
OUTPUT_AS_DECIMAL_3400 .FILL x3400

.END

;=================================================
; Subroutine: LOAD_FILL_VALUE_3200
;=================================================

.ORIG x3200

; Backup registers
ADD R6, R6, #-1
STR R7, R6, #0
ADD R6, R6, #-1
STR R1, R6, #0

; Code
LD R3, VALUE
; LD R3, NEG_VALUE

; Restore registers
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET

VALUE .FILL #32766
NEG_VALUE .FILL #-32766


.END

;=================================================
; Subroutine: OUTPUT_AS_DECIMAL_3400
;=================================================

.ORIG x3400

; Backup registers
ADD R6, R6, #-1
STR R7, R6, #0

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
STR R5, R6, #0

; Code

LD R1, DEC_48

; check if number negetive
ADD R3, R3, #0
BRzp CONTINUED
    LEA R0, NEG_SIGN
    PUTS
    NOT R3, R3
    ADD R3, R3, #1

CONTINUED

; 1st loop - 10000 ---------------------------------

; load label to regeister
LD R5, DEC_N10000
AND R2, R2, #0

FIRST_LOOP
    ADD R2, R2, #1    ; increment size
    ADD R3, R3, R5    ; perform adding (32767+ -10000)
    BRzp FIRST_LOOP   
END_FIRST_LOOP

ADD R2, R2, #-1
ADD R0, R2, R1    ; use counter add ascii 48, output digit
OUT

; after loop, add 10000 back to store value and ready use for next loop
LD R4, DEC_P10000
ADD R3, R3, R4


; 2nd loop - 1000 -----------------------------------

; load label to regeister
LD R5, DEC_N1000
AND R2, R2, #0

SECOND_LOOP
    ADD R2, R2, #1    ; increment size
    ADD R3, R3, R5    ; perform adding
    BRzp SECOND_LOOP   
END_SECOND_LOOP

ADD R2, R2, #-1
ADD R0, R2, R1    ; output ounter (digit)
OUT

; after loop, add 1000 back to store value and ready use for next loop
LD R4, DEC_P1000
ADD R3, R3, R4


; 3rd loop - 100 -------------------------------------------

; load label to regeister
LD R5, DEC_N100
AND R2, R2, #0

THIRD_LOOP
    ADD R2, R2, #1    ; increment size
    ADD R3, R3, R5    ; perform adding (32767+ -10000)
    BRzp THIRD_LOOP   
END_THIRD_LOOP

ADD R2, R2, #-1
ADD R0, R2, R1    ; output ounter (digit)
OUT

; after loop, add 100 back to store value and ready use for next loop
LD R4, DEC_P100
ADD R3, R3, R4


; 4th loop - 10 ----------------------------------------------

; load label to regeister
LD R5, DEC_N10
AND R2, R2, #0

FOURTH_LOOP
    ADD R2, R2, #1    ; increment size
    ADD R3, R3, R5    ; perform adding (32767+ -10000)
    BRzp FOURTH_LOOP   
END_FOURTH_LOOP

ADD R2, R2, #-1
ADD R0, R2, R1    ; output ounter (digit)
OUT

; after loop, add 10 back to store value and ready use for next loop
LD R4, DEC_P10
ADD R3, R3, R4


; 5th loop - 1 ----------------------------------------------

; load label to regeister
LD R5, DEC_N1
AND R2, R2, #0


FIFTH_LOOP
    ADD R2, R2, #1    ; increment size
    ADD R3, R3, R5    ; perform adding (32767+ -10000)
    BRzp FIFTH_LOOP   
END_FIFTH_LOOP

ADD R2, R2, #-1
ADD R0, R2, R1    ; output ounter (digit)
OUT

; after loop, add 1 back to store value and ready use for next loop
LD R4, DEC_P1
ADD R3, R3, R4

; Restore registers
LDR R5, R6, #0
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

LDR R7, R6, #0
ADD R6, R6, #1

RET


DEC_P10000   .FILL #10000
DEC_N10000   .FILL #-10000

DEC_P1000    .FILL #1000
DEC_N1000    .FILL #-1000

DEC_P100     .FILL #100
DEC_N100     .FILL #-100

DEC_P10      .FILL #10
DEC_N10      .FILL #-10

DEC_P1       .FILL #1
DEC_N1       .FILL #-1

DEC_48       .FILL #48
NEG_SIGN     .STRINGZ "-"

.END