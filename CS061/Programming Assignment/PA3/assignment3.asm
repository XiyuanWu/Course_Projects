
.ORIG x3000       

LD R6, Value_ptr       ; R6 <-- Memory address of the value
LDR R1, R6, #0         ; R1 <-- Value to be converted to binary

;---------------------------------------

; Initialize a counter for the number of bits to process
LD R2, BitCount        ; Load the bit count into R2

; Begin the outer loop to process each bit
ProcessBits
    LD R3, BitCount    ; Reset the inner loop counter

    ; Inner loop to process each individual bit
    CheckEachBit
        LD R0, ASCII_ZERO_BASE   ; Load the ASCII base for '0'
        LD R5, BitMask           ; Load the bit mask to isolate the MSB
        AND R5, R1, R5           ; Isolate the MSB of the value

        ; Check if the MSB is '1' and output the correct ASCII character
        BRn OutputOne            ; If negative, MSB is '1', so branch to OutputOne
        OUT                      ; Output ASCII '0' since MSB is not '1'
        BR EndBitCheck           ; Skip to the next bit
        
        ; Output '1' since the MSB is '1'
        OutputOne
        ADD R0, R0, #1           ; Convert ASCII '0' to '1'
        OUT                      ; Output ASCII '1'

        ; Prepare for the next bit.
        EndBitCheck
        ADD R1, R1, R1           ; Left shift the value to move the next bit to MSB
        ADD R3, R3, #-1          ; Decrement the inner loop counter
        BRp CheckEachBit         ; Repeat if more bits to check

    ; Prepare for the next segment of bits if needed
    ADD R2, R2, #-1             ; Decrement the outer loop counter
    BRz EndConversion           ; If done with all bits, end conversion

    ; Output a space for readability between segments
    LD R0, ASCII_SPACE          ; Load ASCII code for space
    OUT                         ; Output space character
    BR ProcessBits              ; Continue with the next segment of bits

EndConversion
    ; Output a newline character at the end
    LD R0, ASCII_NEWLINE
    OUT

HALT                    


Value_ptr        .FILL xCA01             ; The address where value to be displayed is stored
ASCII_NEWLINE    .FILL x0A               ; ASCII code for newline
BitCount         .FILL #4                ; Counter for 4 bits
ASCII_SPACE      .FILL x0020             ; ASCII code for space
ASCII_ZERO_BASE  .FILL x30               ; ASCII code for '0' base
BitMask          .FILL x8000             ; Mask to isolate the MSB

.END

; Remote data
.ORIG xCA01
StoredValue      .FILL xABCD             ; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.

.END
