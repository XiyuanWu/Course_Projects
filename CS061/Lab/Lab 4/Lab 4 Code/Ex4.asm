.ORIG x3000

AND R0, R0, #0                          ; Clear R0 register
LD R1, SUB_FILL_ARRAY_3200              ; Load address of fill array subroutine into R1
LD R2, DEC_9                            ; Load loop counter value (9) into R2
JSRR R1                                 ; Call subroutine to fill array

LD R1, SUB_CONVERT_ARRAY_3400           ; Load address of convert array subroutine into R1
LD R2, DEC_9                            ; Reload loop counter value (9) into R2
ADD R2, R2, #1                          ; Increment counter to include 0 in the count
LD R3, DEC_48                           ; Load ASCII value of '0' into R3
JSRR R1                                 ; Call subroutine to convert array to ASCII characters

LD R1, SUB_PRINT_ARRAY_3600             ; Load the address of the print array subroutine into R1
LD R2, DEC_9                            ; Reload loop counter for printing
ADD R2, R2, #1                          ; Adjust loop counter to process all elements
JSRR R1                                 ; Jump to the subroutine at R1 (print array)

LD R1, SUB_PRETTY_PRINT_ARRAY_3800      ; Load the address of the pretty print array subroutine into R1
JSRR R1                                 ; Jump to the subroutine at R1 (pretty print array)

HALT                                          

SUB_FILL_ARRAY_3200 .FILL x3200         ; Address of fill array subroutine
SUB_CONVERT_ARRAY_3400 .FILL x3400      ; Address of convert array subroutine
SUB_PRINT_ARRAY_3600 .FILL x3600        ; Address of print array subroutine
SUB_PRETTY_PRINT_ARRAY_3800 .FILL x3800 ; Address of pretty print array subroutine
DEC_9 .FILL #9                          ; Constant 9
DEC_48 .FILL #48                        ; ASCII value for '0'

.END                                             

;------------------------------------------------------------------------
; Subroutine: SUB_FILL_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: The array has values from 0 through 9.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3200

LD R1, ARRAY                            ; Load starting address of the array into R1

FILL_ARRAY_LOOP
    ADD R0, R0, #1                      ; Increment value to store in the array
    ADD R1, R1, #1                      ; Move to next array position
    STR R0, R1, #0                      ; Store incremented value in the array
    ADD R2, R2, #-1                     ; Decrement loop counter
    BRp FILL_ARRAY_LOOP                 ; Loop if counter is positive
RET                                     ; Return from subroutine

ARRAY .FILL x4000                       ; Address of the array start

.END                                  

;------------------------------------------------------------------------
; Subroutine: SUB_CONVERT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Each element (number) in the array should be represented as a character. E.g. 0 -> ‘0’
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3400

LD R1, ARRAY1                           ; Load starting address of the array into R1

CONVERT_ARRAY_LOOP
    LDR R0, R1, #0                      ; Load number from the array
    ADD R0, R0, R3                      ; Convert number to ASCII character
    STR R0, R1, #0                      ; Store ASCII character in the array
    ADD R1, R1, #1                      ; Move to next array position
    ADD R2, R2, #-1                     ; Decrement loop counter
    BRp CONVERT_ARRAY_LOOP              ; Loop if counter is positive
RET                                     ; Return from subroutine

ARRAY1 .FILL x4000                      ; Address of the array (same as before)

.END                                           

;------------------------------------------------------------------------
; Subroutine: SUB_PRINT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Each element (character) in the array is printed out to the console.
; Return Value (None)
;-------------------------------------------------------------------------
.ORIG x3600 
LD R1, ARRAY2                           ; Load the starting address for printing

PRINT_ARRAY_LOOP
LDR R0, R1, #0                          ; Load array element into R0
OUT                                     ; Output character in R0
ADD R1, R1, #1                          ; Move to next array element
ADD R2, R2, #-1                         ; Decrement loop counter
BRp PRINT_ARRAY_LOOP                    ; Loop if more elements to print
END_PRINT_ARRAY_LOOP

RET                                     ; Return from the subroutine

ARRAY2 .FILL x4000                      ; Start address of the array for printing

.END

;------------------------------------------------------------------------
; Subroutine: SUB_PRETTY_PRINT_ARRAY
; Parameter (R1): The starting address of the array. This should be unchanged at the end of the subroutine!
; Postcondition: Prints out “=====” (5 equal signs), prints out the array, and after prints out “=====” again.
; Return Value (None)
;-------------------------------------------------------------------------

.ORIG x3800

LD R1, ARRAY_3800                       ; Load address of the main array to print
LEA R0, EQUALS                          ; Load the address of the string "====="
PUTS                                    ; Print the string "=====" to signify the start of pretty print

; Setup and call the subroutine to print the array contents
LD R3, ARRAY1_3600                      ; Load the address of the print array subroutine
LD R2, DEC1_9                           ; Load the counter value for looping through array elements
ADD R2, R2, #1                          ; Adjust counter to include zero in the loop

; This will cause infinite loop, because RET will always return the address that store in R7
; To avoid this, we need save R7 address, and change it back after JSR being called
; ADD R6, R7, 0;                          Save R7 Address
JSRR R3                                 ; Jump to subroutine to print array elements
; ADD R7, R6, 0;                          Change address back
; Now in line 130, RET should return main program, R7 has correct address
; Be note the excerise given this week does not expected program work , this is just a note, a way to fix the infinite loop

; After printing the array, print the equals sign string again to signify the end
LEA R0, EQUALS                          ; Reload the address of the "=====" string
PUTS                    

RET                   

ARRAY_3800 .FILL x4000                  ; Address of the array to be pretty printed
EQUALS .STRINGZ "====="                 ; Define the string "=====" to be printed before and after the array
DEC1_9 .FILL #9                         ; Define the counter for the number of elements in the array, used in loop control
ARRAY1_3600 .FILL x3600                 ; Address of the subroutine to print array elements

.END                       


; -----------------

.ORIG x4000

ARRAY_RESERVE .BLKW #10                 ; Reserve space for 10 elements in the array

.END                                            
