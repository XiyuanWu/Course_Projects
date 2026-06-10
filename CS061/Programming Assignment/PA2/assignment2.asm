
.ORIG x3000			; Program begins here


; Step 0: Output prompt
LEA R0, Intro			
PUTS			   


; Step 1: Get number from user

; Read first number
GETC                ; Read number from user
ADD R1, R0, #0      ; Store in R1
OUT
LD R0, Newline  
OUT
; Read second number
GETC                ; Read number from user
ADD R2, R0, #0      ; Store in R2
OUT
LD R0, newline  
OUT


; Step 2 Output equaltion

; Ouput first number
ADD R0, R1, #0
OUT
; Output Space
LD R0, Space
OUT
; Output minus sign
LD R0, MinusSign
OUT
; Output Space
LD R0, Space
OUT
; Output second number
ADD R0, R2, #0
OUT
; Output Space
LD R0, Space
OUT
; Output equal sign
LD R0, EqualSign
OUT
; Output Space
LD R0, Space
OUT


; Step3: Convert ASCII to Binary

LD R3, ASCII_ZERO   ; Load ASCII code for "0" to R3
NOT R3, R3          ; Invert bits
ADD R3, R3, #1      ; Two's complement, add 1
ADD R1, R1, R3      ; Subtract ASCII of "0" from R1
; R1 now contain binary value of R1

LD R3, ASCII_ZERO   ; Load ASCII code for "0" to R3
NOT R3, R3          ; Invert bits
ADD R3, R3, #1      ; Two's complement, add 1
ADD R2, R2, R3      ; Subtract ASCII of "0" from R2
; R2 now contain binary value of R2


; Step 4: Actual operation (R1 - R2)

NOT R2, R2          ; Invert bits
ADD R2, R2, #1      ; Add 1 to R2 get 2's complement
; Perform subtraction by add R1 and 2's complement of R2
ADD R5, R1, R2      ; R5 = R1 + (-R2)
; R5 now contains result(binary) of the subtraction

; Check if the result is negative
BRn HANDLE_NEGATIVE  ; If negative, branch to HANDLE_NEGATIVE
BRzp CONTINUE_STEP5  ; If positive or zero, continue to Step 5

HANDLE_NEGATIVE:
    LD R0, MinusSign
    OUT              ; Output minus sign
    NOT R5, R5       ; Take 2's complement of R5 to get magnitude
    ADD R5, R5, #1
    ; R5 now contains the magnitude of the negative result
    BR CONTINUE_STEP5  ; Branch unconditionally to continue with Step 5


CONTINUE_STEP5:
; Step 5: Convert binary to ASCII and output

; ; Check if result are negetive and output a minus sign
; BRz POSITIVE_RESULT
; LD R0, MinusSign
; OUT

;POSITIVE_RESULT:
LD R4, ASCII_ZERO   ; Load ASCII code for "0" to R4
ADD R0, R5, R4      ; Add ASCII value for "0" to R5 and store in R0
; R0 now contains ASCII result
OUT                 ; Output result
LD R0, Newline 
OUT                 ; Output newline


HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
Intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
Newline .FILL x0A	; newline character - use with LD followed by OUT
Space   .FILL x20   ; ASCII value for space
MinusSign .FILL x2D ; ASCII value for "-"
EqualSign .FILL x3D ; ASCII value for "="
ASCII_ZERO .FILL x30; ASCII value for "0"
NEGATIVE_FLAG .FILL xFFFF  ; A non-zero value to indicate negative result


;---------------	
;END of PROGRAM
;---------------	
.END

