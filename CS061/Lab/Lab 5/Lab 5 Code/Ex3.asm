.ORIG x3000

LD R6, BACKUP               ; Load the backup register address to R6

LD R3, STACK_BASE           ; Load the base address of the stack into R3
LD R4, STACK_MAX            ; Load the maximum address of the stack into R4
LD R5, STACK_TOS            ; Load the current Top Of Stack address into R5

; Get the first number and store it in the stack
LEA R0, PROMPT              ; Load the address of the first prompt into R0
PUTS                        ; Print the first prompt message

GETC                        ; Get a single character (digit) from the user
OUT                         ; Echo the character
; Convert ASCII character to its numeric value by subtracting 48
ADD R0, R0, #-16            
ADD R0, R0, #-16            
ADD R0, R0, #-16            
ADD R1, R0, #0              ; Move converted digit into R1
LD R2, SUB_STACK_PUSH       ; Load the address of the stack push subroutine into R2
JSRR R2                     ; Call the push subroutine to store the digit on the stack
LD R0, NEWLINE              ; Load the newline character
OUT                         ; Print newline for formatting

; Get the second number and store it in the stack
LEA R0, PROMPT2             ; Load the address of the second prompt into R0
PUTS                        ; Print the second prompt message
GETC                        ; Get a single character (digit) from the user
OUT                         ; Echo the character
; Convert ASCII character to its numeric value by subtracting 48 (3 times 16)
ADD R0, R0, #-16            
ADD R0, R0, #-16            
ADD R0, R0, #-16            
ADD R1, R0, #0              ; Move converted digit into R1
LD R2, SUB_STACK_PUSH       ; Load the address of the stack push subroutine into R2 again
JSRR R2                     ; Call the push subroutine to store the second digit on the stack
LD R0, NEWLINE              ; Load the newline character again
OUT                         ; Print newline for formatting

; Get the operand (though it is not used in this specific operation as it's hardcoded for addition)
LEA R0, GET_OPERAND         ; Load the address of the operand prompt into R0
PUTS                        ; Print the operand prompt message
LD R0, NEWLINE              ; Load the newline character
OUT                         ; Print newline for formatting

; Perform RPN addition of the top two numbers on the stack
LD R1, SUB_RPN_ADDITION    ; Load the address of the RPN addition subroutine into R1
JSRR R1                     ; Call the RPN addition subroutine

HALT                        ; Halt the program

; Data and addresses
BACKUP .FILL xFE00
PROMPT .STRINGZ "Type a single digit numeric character: "
PROMPT2 .STRINGZ "Type another single digit numeric character: "
GET_OPERAND .STRINGZ "Type of operand: + "
STACK_BASE .FILL xA000
STACK_MAX .FILL xA005
STACK_TOS .FILL xA000
SUB_STACK_PUSH .FILL x3200
SUB_STACK_POP .FILL x3400
SUB_RPN_ADDITION .FILL x3600
NEWLINE .FILL x0A
PLUS .FILL #-43            ; ASCII value for '+' minus 48, not directly used in this code

.END




;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R1): The value to push onto the stack
; Parameter (R3): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R4): MAX: The "highest" available address in the stack
; Parameter (R5): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R1) onto the stack (i.e to address TOS+1).
; If the stack was already full (TOS = MAX), the subroutine has printed an
; overflow error message and terminated.
; Return Value: R5 ← updated TOS
;------------------------------------------------------------------------------------------

.ORIG x3200

ADD R6, R6, #-1              ; Decrement R6 to make space for R7
STR R7, R6, #0               ; Back up R7 on the stack
ADD R6, R6, #-1              ; Repeat process for R1
STR R1, R6, #0               ; Back up R1 on the stack
ADD R6, R6, #-1              ; Repeat process for R2
STR R2, R6, #0               ; Back up R2 on the stack
ADD R6, R6, #-1              ; Repeat process for R3
STR R3, R6, #0               ; Back up R3 on the stack

LD R2, ENTER                 ; Load the 'Enter' key code into R2
    NOT R2, R2               ; Invert bits of R2
    ADD R2, R2, #1           ; Add 1 to R2 to get the negative value of 'Enter' key code

PUSH_INTO_STACK:
    
    ADD R3, R0, R2           ; Check if the 'Enter' key was pressed
    BRz END_OVERFLOW_DETECTED ; If 'Enter' is pressed, end push process
    
    AND R3, R3, #0           ; Clear R3
    ADD R3, R4, #0           ; Copy the stack maximum address to R3
    NOT R3, R3               ; Invert bits of R3
    ADD R3, R3, #1           ; Prepare to compare with stack pointer
    ADD R3, R5, R3           ; Compare stack pointer with maximum
    BRzp OVERFLOW_DETECTED   ; Branch if overflow detected
    
    STR R1, R5, #1           ; Store the character at the top of the stack
    ADD R5, R5, #1           ; Increment the top of stack pointer
    BR END_OVERFLOW_DETECTED ; Loop back to get next character

END_PUSH_INTO_STACK

OVERFLOW_DETECTED:
    LEA R0, NEWLINE1         ; Load address of newline character
    PUTS                     ; Print newline
    LEA R0, OVERFLOW_ERROR   ; Load address of overflow error message
    PUTS                     ; Print overflow error message
END_OVERFLOW_DETECTED

LDR R3, R6, #0               ; Restore R3 from the stack
ADD R6, R6, #1               ; Adjust stack pointer
LDR R2, R6, #0               ; Restore R2 from the stack
ADD R6, R6, #1               ; Adjust stack pointer
LDR R1, R6, #0               ; Restore R1 from the stack
ADD R6, R6, #1               ; Adjust stack pointer
LDR R7, R6, #0               ; Restore R7 from the stack
ADD R6, R6, #1               ; Adjust stack pointer

RET                          ; Return from the subroutine

OVERFLOW_ERROR .STRINGZ "Overflow has occured."
ENTER .FILL #10              ; ASCII code for 'Enter' key
NEWLINE1 .FILL x0A           ; ASCII code for newline

.END

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R3): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R4): MAX: The "highest" available address in the stack
; Parameter (R5): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack and copied it to R0.
; If the stack was already empty (TOS = BASE), the subroutine has printed
; an underflow error message and terminated.
; Return Values: R0 ← value popped off the stack
; R5 ← updated TOS
;------------------------------------------------------------------------------------------

.ORIG x3400

; Backup registers R7, R2, R3 on the stack
ADD R6, R6, #-1
STR R7, R6, #0             ; Back up R7
ADD R6, R6, #-1
STR R2, R6, #0             ; Back up R2


POP_OFF_STACK:
    AND R2, R2, #0         ; Clear R2 for use
    ADD R2, R3, #0         ; Copy BASE address to R2
    NOT R2, R2             ; Invert for comparison
    ADD R2, R2, #1         ; Adjust for comparison
    ADD R2, R5, R2         ; Compare TOS with BASE
    BRnz UNDERFLOW_DETECTED; Branch if TOS is at BASE (underflow)
    
    LDR R0, R5, #0         ; Load value from TOS into R0
    ADD R5, R5, #-1        ; Decrement TOS
    BR END_UNDERFLOW_DETECTED

END_POP_OFF_STACK

; Handle underflow error
UNDERFLOW_DETECTED:
    LEA R0, UNDERFLOW_ERROR; Load underflow error message address
    PUTS                   ; Print underflow error message

END_UNDERFLOW_DETECTED

; Restore registers R3, R2, R7 from the stack
LDR R2, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET                       

UNDERFLOW_ERROR .STRINGZ "Underflow has occured."

.END


;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_ADDITION
; Parameter (R3): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R4): MAX: The "highest" available address in the stack
; Parameter (R5): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    added them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R5 ← updated TOS address
;------------------------------------------------------------------------------------------

.ORIG x3600

; Backup registers before modifying them
ADD R6, R6, #-1
STR R7, R6, #0             ; Backup R7
ADD R6, R6, #-1
STR R1, R6, #0             ; Backup R1
ADD R6, R6, #-1
STR R2, R6, #0             ; Backup R2
ADD R6, R6, #-1
STR R3, R6, #0             ; Backup R3

; Pop the first value off the stack
LD R3, POP_1
JSRR R3                    ; Call POP subroutine

ADD R1, R0, #0             ; Store popped value from R0 into R1

; Pop the second value off the stack
LD R3, POP_2
JSRR R3                    ; Call POP subroutine again

ADD R1, R0, R1             ; Add the second popped value to the first, result in R1

; Push the result back onto the stack
LD R3, PUSH
JSRR R3                    ; Call PUSH subroutine to store the result

; Pop the result for printing
LD R3, POP_3
JSRR R3                    ; Call POP subroutine to retrieve the result for printing

; Call the print digit subroutine
LD R3, SUB_PRINT_DIGIT
JSRR R3                    ; Call PRINT_DIGIT subroutine to print the result

; Restore registers after operation
LDR R3, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R1, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET                      

; Address labels for other subroutines
POP_1 .FILL x3400
POP_2 .FILL x3400
POP_3 .FILL x3400
PUSH .FILL x3200
SUB_PRINT_DIGIT .FILL x3800

.END

; -------------------------------------
; SUB_PRINT_DIGIT Subroutine
; -------------------------------------

.ORIG x3800

; Backup registers before modifying them
ADD R6, R6, #-1
STR R7, R6, #0             ; Backup R7
ADD R6, R6, #-1
STR R3, R6, #0             ; Backup R3
ADD R6, R6, #-1
STR R2, R6, #0             ; Backup R2

; Convert the numeric result in R0 to its ASCII representation
LD R2, DEC_TO_ASCII
ADD R0, R0, R2             ; Add 48 to convert decimal digit to ASCII
OUT                   

; Restore registers after operation
LDR R2, R6, #0
ADD R6, R6, #1
LDR R3, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET                        ; Return from subroutine

DEC_TO_ASCII .FILL #48     ; Conversion constant from decimal digit to ASCII

.END

