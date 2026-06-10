.ORIG x3000        

LEA R1, ARRAY         ; Load the address of the array into R1
AND R2, R2, #0        ; Clear R2 to use as a counter
ADD R2, R2, #10       ; Set counter to 10

INPUT_LOOP
    TRAP x20              ; TRAP x20 is GETC (get character from keyboard)
    OUT
    STR R0, R1, #0        ; Store the character into the array at the address in R1
    ADD R1, R1, #1        ; Increment the array address pointer
    ADD R2, R2, #-1       ; Decrement the counter
    BRp INPUT_LOOP        ; Repeat the loop while the counter is positive

HALT                  

ARRAY .BLKW 10            ; Reserve array of 10 locations

.END                  
