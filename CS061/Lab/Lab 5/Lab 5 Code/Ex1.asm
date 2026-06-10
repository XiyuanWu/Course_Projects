.ORIG x3000

LD R6, BACKUP                ; Load the backup address into R6
LEA R0, PROMPT               ; Load the address of the PROMPT string into R0
PUTS                          ; Output the PROMPT string to the console

LD R3, STACK_BASE            ; Load the base address of the stack into R3
LD R4, STACK_MAX             ; Load the maximum address of the stack into R4
LD R5, STACK_TOS             ; Load the top of stack address into R5

LD R1, SUB_STACK_PUSH        ; Load the address of the stack push subroutine into R1
JSRR R1                      ; Jump to the stack push subroutine, saving the return address in R7

HALT                         ; Halt the execution of the program

BACKUP .FILL xFE00           ; Reserve a memory location for backup
PROMPT .STRINGZ "Type an input: " ; Display prompt to user
STACK_BASE .FILL xA000       ; Initialize stack base address
STACK_MAX .FILL xA005        ; Initialize stack maximum address
STACK_TOS .FILL xA000        ; Initialize top of stack address
SUB_STACK_PUSH   .FILL x3200 ; Address of the stack push subroutine

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
NOT R2, R2                   ; Invert bits of R2
ADD R2, R2, #1               ; Add 1 to R2 to get the negative value of 'Enter' key code

PUSH_INTO_STACK:
    GETC                     ; Get a character from the user
    OUT                      ; Output the character (echo)
    
    ADD R1, R0, #0           ; Copy the character to R1
    
    ADD R3, R0, R2           ; Check if the 'Enter' key was pressed
    BRz END_OVERFLOW_DETECTED ; If 'Enter' is pressed, end push process
    
    AND R3, R3, #0           ; Clear R3
    ADD R3, R4, #0           ; Copy the stack maximum address to R3
    NOT R3, R3               ; Invert bits of R3
    ADD R3, R3, #1           ; Prepare to compare with stack pointer
    ADD R3, R5, R3           ; Compare stack pointer with maximum
    BRzp OVERFLOW_DETECTED   ; Branch if overflow detected
    
    STR R1, R5, #0           ; Store the character at the top of the stack
    ADD R5, R5, #1           ; Increment the top of stack pointer
    BR PUSH_INTO_STACK       ; Loop back to get next character

END_PUSH_INTO_STACK:

OVERFLOW_DETECTED:
    LEA R0, NEWLINE          ; Load address of newline character
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
NEWLINE .FILL x0A            ; ASCII code for newline

.END
