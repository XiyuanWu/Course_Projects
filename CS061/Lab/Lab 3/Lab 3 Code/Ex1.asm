.ORIG x3000       ; Start of the program

; Let's assume DATA1 and DATA2 are the remote data values at addresses x4000 and x4001, respectively

; First, we need to store the addresses of these remote data values in local data
LEA R0, POINTER   ; Load the address of the local pointer into R0
LDR R1, R0, #0    ; Load the first remote data value into R1
;ADD R0, R0, #1    ; Increment the pointer to the next data value
LDR R2, R0, #1    ; Load the second remote data value into R2

; Now R1 contains the first data value, and R2 contains the second data value

HALT              ; Halt the program

; Local data
POINTER .FILL x4000  ; The pointer contains the address of DATA1
.end

; Remote data values
.orig x4000          ; Define where remote data starts
DATA1 .FILL #123     ; Remote data value 1
DATA2 .FILL #456     ; Remote data value 2

.END               ; End of the program
