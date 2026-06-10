.ORIG x3000

AND R0, R0, #0                                  ; Clear R0 register
LD R1, SUB_FILL_ARRAY_3200                      ; Load address of fill array subroutine into R1
LD R2, DEC_9                                    ; Load loop counter value (9) into R2
JSRR R1                                         ; Call subroutine to fill array

LD R1, SUB_CONVERT_ARRAY_3400                   ; Load address of convert array subroutine into R1
LD R2, DEC_9                                    ; Reload loop counter value (9) into R2
ADD R2, R2, #1                                  ; Increment counter to include 0 in the count
LD R3, DEC_48                                   ; Load ASCII value of '0' into R3
JSRR R1                                         ; Call subroutine to convert array to ASCII characters

HALT                                          

SUB_FILL_ARRAY_3200 .FILL x3200                 ; Address of fill array subroutine
SUB_CONVERT_ARRAY_3400 .FILL x3400              ; Address of convert array subroutine
DEC_9 .FILL #9                                  ; Constant 9
DEC_48 .FILL #48                                ; ASCII value for '0'

.END                                             

;------------------------------------------------------------------------
; Subroutine: SUB_FILL_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: The array has values from 0 through 9.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3200

LD R1, ARRAY                                    ; Load starting address of the array into R1

FILL_ARRAY_LOOP
    ADD R0, R0, #1                              ; Increment value to store in the array
    ADD R1, R1, #1                              ; Move to next array position
    STR R0, R1, #0                              ; Store incremented value in the array
    ADD R2, R2, #-1                             ; Decrement loop counter
    BRp FILL_ARRAY_LOOP                         ; Loop if counter is positive
RET                                             ; Return from subroutine

ARRAY .FILL x4000                               ; Address of the array start

.END                                             ; End of SUB_FILL_ARRAY subroutine

;------------------------------------------------------------------------
; Subroutine: SUB_CONVERT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Each element (number) in the array should be represented as a character. E.g. 0 -> ‘0’
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3400

LD R1, ARRAY1                                   ; Load starting address of the array into R1

CONVERT_ARRAY_LOOP
    LDR R0, R1, #0                              ; Load number from the array
    ADD R0, R0, R3                              ; Convert number to ASCII character
    STR R0, R1, #0                              ; Store ASCII character in the array
    ADD R1, R1, #1                              ; Move to next array position
    ADD R2, R2, #-1                             ; Decrement loop counter
    BRp CONVERT_ARRAY_LOOP                      ; Loop if counter is positive
RET                                             ; Return from subroutine

ARRAY1 .FILL x4000                              ; Address of the array (same as before)

.END                                           


.ORIG x4000

ARRAY_RESERVE .BLKW #10                         ; Reserve space for 10 elements in the array

.END                                             ; End of array reservation
