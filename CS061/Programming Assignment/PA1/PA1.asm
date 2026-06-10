

;------------------------------------------
;           BUILD TABLE HERE
;------------------------------------------
;REG VALUES     R0  R1  R2  R3  R4  R5  R6  R7
;------------------------------------------
;Pre-loop       0   6   12  12  0   0   0   0   
;Iteration 1    0   5   12  24  0   0   0   0   
;Iteration 2    0   4   12  32  0   0   0   0
;Iteration 3    0   3   12  44  0   0   0   0
;Iteration 4    0   2   12  56  0   0   0   0   
;Iteration 5    0   1   12  68  0   0   0   0
;Iteration 6    0   0   12  72  0   0   0   0
;End_of program 0   32767   12  72  0   0   12286   0
;-------------------------------------------


.ORIG x3000 ; Program begins here
;-------------
;Instructions: CODE GOES HERE
;-------------
LD R1, DEC_6 ; Sign 6 to R1
LD R2, DEC_12 ; Sign 12 to R2
AND R3, R3, #0

MULTIPLY
    ADD R3, R3, R2 ; R3 = R3 + R2
    ADD R1, R1, #-1 ; R1 = R1 - 1
    BRp MULTIPLY ; If R1 still positive, repeats loop

HALT
;---------------	
;Data (.FILL, .STRINGZ, .BLKW)
;---------------
DEC_0 .FILL #0 ; Fill 0 to the memory
DEC_6 .FILL #6 ; Fill 6 to the memory
DEC_12 .FILL #12 ; Fill 12 to the memory

;---------------	
;END of PROGRAM
;---------------	
.END


