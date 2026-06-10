.ORIG x3000

LD R1, SUB_FILL_ARRAY_3200      ; Load the starting address of the subroutine into R1
LD R2, DEC_9                    ; Load the counter value (9) into R2
JSRR R1                         ; Jump to subroutine located at address stored in R1, 
                                ; saving return address in R7

HALT 

SUB_FILL_ARRAY_3200 .FILL x3200 
DEC_9 .FILL #9 

.END 

;------------------------------------------------------------------------
; Subroutine: SUB_FILL_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: The array has values from 0 through 9.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3200 

LD R1, ARRAY                    ; Load the starting address of the array into R1

LOOP
    ADD R0, R0, #1              ; Increment R0 (used as the value to store in the array)
    ADD R1, R1, #1              ; Move to the next array element address
    STR R0, R1, #0              ; Store the value of R0 into the array at the address in R1
    ADD R2, R2, #-1             ; Decrement the loop counter in R2
    BRp LOOP                    ; If R2 positive, branch to LOOP to continue the loop
END_LOOP

RET                             ; Return from the subroutine

ARRAY .FILL x4000               ; Store the starting address of the array in memory for loading

.END

;===============================================

.ORIG x4000

ARRAY_RESERVE .BLKW #10         ; Reserve 10 words of memory for the array

.END
