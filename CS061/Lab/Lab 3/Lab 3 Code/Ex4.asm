.ORIG x3000        

; Initialize R1 with the remote array start address
LD R1, ARRAY_START    ; R1 will be our pointer to the current array position

; Input Loop - Sentinel controlled
INPUT_LOOP
    TRAP x20          ; TRAP x20 is GETC (get character from keyboard)
    OUT
    STR R0, R1, #0    ; Store the character into the array at the address in R1
    ADD R1, R1, #1    ; Increment the array address pointer
    ADD R0, R0, #-10  ; Subtract 10 to check if the character is a newline
    BRz INPUT_DONE    ; If R0 is zero (newline), we are done with input
    BRnzp INPUT_LOOP  ; Otherwise, keep looping
INPUT_DONE

; Store the sentinel character at the end of the input
AND R0, R0, #0        ; Clear R0 to store null terminator (sentinel)
STR R0, R1, #0        ; Store the sentinel in the array

; Print a newline to separate input from output
TRAP x21             ; Print the newline character

; Reset R1 to the start of the array for output loop
LD R1, ARRAY_START    

; Output Loop - Sentinel controlled
OUTPUT_LOOP
    LDR R0, R1, #0    ; Load the character from the array into R0
    BRz OUTPUT_DONE   ; If the character is the sentinel, we are done with output
    OUT               ; Print the character
    ADD R1, R1, #1    ; Increment the array address pointer
    BRnzp OUTPUT_LOOP ; Repeat the loop
OUTPUT_DONE

HALT                  

ARRAY .BLKW 100       ; Reserve 100 location
ARRAY_START .FILL x4000 ; Remote array start address
NEWLINE .FILL x0A       ; Newline character (sentinel)


.END                   
