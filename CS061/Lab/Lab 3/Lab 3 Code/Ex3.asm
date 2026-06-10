.ORIG x3000        

LEA R1, ARRAY         ; Load the address of the array into R1
AND R2, R2, #0        ; Clear R2 to use as a counter
ADD R2, R2, #10       ; Set counter to 10

INPUT_LOOP
    TRAP x20          ; TRAP x20 is GETC (get character from keyboard)
    OUT               ; Print the character
    STR R0, R1, #0    ; Store the character into the array at the address in R1
    ADD R1, R1, #1    ; Increment the array address pointer
    ADD R2, R2, #-1   ; Decrement the counter
    BRp INPUT_LOOP    ; Repeat the loop while the counter is positive

; Print a newline to separate input from output
PUTS_NEWLINE
    LEA R0, NEWLINE
    PUTS             ; Print the newline character

; Reset R1 to the start of the array and R2 as a counter for output loop
LEA R1, ARRAY         
AND R2, R2, #0        
ADD R2, R2, #10       

OUTPUT_LOOP
    LDR R0, R1, #0    ; Load the character from the array into R0
    OUT               ; Print the character
    ADD R1, R1, #1    ; Increment the array address pointer
    ADD R2, R2, #-1   ; Decrement the counter
    BRp OUTPUT_LOOP   ; Repeat the loop while the counter is positive

HALT                  

ARRAY .BLKW 10       ; Reserve array of 10 locations
NEWLINE .STRINGZ "\n" ; Newline string

.END                  
