.ORIG x3000

LD R6, BACKUP            ; Backup the initial value of R6 to preserve the original stack pointer
LD R3, STACK_BASE        ; Load the base address of the stack into R3
LD R4, STACK_MAX         ; Load the maximum (end) address of the stack into R4
LD R5, STACK_TOS         ; Load the initial Top of Stack (TOS) address into R5

LEA R0, PROMPT           ; Load the address of the prompt message into R0
PUTS                     ; Print the prompt message to console

LD R1, SUB_STACK_PUSH    ; Load the address of the PUSH subroutine into R1
JSRR R1                  ; Jump to the PUSH subroutine, saving return address in R7

; After pushing values, prepare to pop them
LEA R0, NEWLINE          ; Load the address of the newline character into R0
PUTS                     ; Print newline to separate output sections

LD R1, SUB_STACK_POP     ; Load the address of the POP subroutine into R1
JSRR R1                  ; Jump to the POP subroutine, saving return address in R7

HALT                     ; Halt execution

BACKUP .FILL xFE00       ; Backup location for original stack pointer
PROMPT .STRINGZ "Type an input: "
STACK_BASE .FILL xA000   ; Define the start of the stack
STACK_MAX .FILL xA005    ; Define the end of the stack
STACK_TOS .FILL xA000    ; Define the initial top of the stack
SUB_STACK_PUSH .FILL x3200 ; Address of the push subroutine
SUB_STACK_POP .FILL x3400  ; Address of the pop subroutine
NEWLINE .FILL x0A        ; Newline character for formatting output

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
    GETC                     ; Get a character from the user
    OUT                      ; Output the character (echo)
    
    ADD R1, R0, #0           ; Copy the character to R1
    
    LD R7, ASCII_TO_DEC
    ADD R1, R1, R7
    
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
    BR PUSH_INTO_STACK       ; Loop back to get next character

END_PUSH_INTO_STACK:

OVERFLOW_DETECTED:
    LEA R0, NEWLINE1          ; Load address of newline character
    PUTS                     ; Print newline
    LEA R0, OVERFLOW_ERROR   ; Load address of overflow error message
    PUTS                     ; Print overflow error message
END_OVERFLOW_DETECTED:

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
NEWLINE1 .FILL x0A            ; ASCII code for newline
ASCII_TO_DEC .FILL #-48      ; ASCII code for -48

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
ADD R6, R6, #-1
STR R3, R6, #0             ; Back up R3

POP_OFF_STACK:
    AND R2, R2, #0         ; Clear R2 for use
    ADD R2, R3, #0         ; Copy BASE address to R2
    NOT R2, R2             ; Invert for comparison
    ADD R2, R2, #1         ; Adjust for comparison
    ADD R2, R5, R2         ; Compare TOS with BASE
    BRnz UNDERFLOW_DETECTED; Branch if TOS is at BASE (underflow)
    LDR R0, R5, #0         ; Load value from TOS into R0
    ADD R5, R5, #-1        ; Decrement TOS
    BR POP_OFF_STACK       ; Loop back (Note: typically pop is a one-time action, loop might not be necessary)

END_POP_OFF_STACK:

; Handle underflow error
UNDERFLOW_DETECTED:
    LEA R0, UNDERFLOW_ERROR; Load underflow error message address
    PUTS                   ; Print underflow error message

END_UNDERFLOW_DETECTED:

; Restore registers R3, R2, R7 from the stack
LDR R3, R6, #0
ADD R6, R6, #1
LDR R2, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1

RET                        ; Return to caller

UNDERFLOW_ERROR .STRINGZ "Underflow has occured."

.END
