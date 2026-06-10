
.ORIG x3000		
;-------------
;Instructions
;-------------

; R0, User input
; R1, 
; R2, Counter
; R3, Load Label and compare
; R4, Result
; R5, Flag: 1 mean postive, 0 mean negetive
; R6, 
; R7, 

BR INTRO
; if input error
ERROR
    LD R0, NEWLINE
    OUT
    LD R0, errorMessagePtr
    PUTS
END_ERROR

; output intro prompt
INTRO
LD R0, introPromptPtr
PUTS

; Set up flags, counters, accumulators as needed
AND R0, R0, #0                  
AND R1, R1, #0              
AND R2, R2, #0               
AND R3, R3, #0                 
AND R4, R4, #0  
AND R5, R5, #0                   
AND R6, R6, #0    
LD R2, DEC_5    ; Counter, always 5

; Get first character, test for '\n', '+', '-', digit/non-digit 	
GETC   ; In R0
OUT

; If user enter a char, there are 4 possible outcome: \n, +, -, D, Other
; "\n"  -> END_PROGRAM
; "+"   -> R5 (Flag) = 1, BR AFTER_FIRST_CHAR_LOOP
; "-"   -> R5 (Flag) = 0, BR AFTER_FIRST_CHAR_LOOP
; "D"   -> R5 (Flag) = 1, R2 (Counter) --, BR AFTER_FIRST_CHAR_LOOP
; "Other" -> BR ERROR

; Case 1: is very first character = '\n'? if so, just quit (no message)!
LD R3, NEWLINE_CHECK
ADD R3, R3, R0
BRz END_PROGRAM

; Case 2: is it = '+'? if so, ignore it, go get digits
LD, R3, PLUS_CHECK
ADD R3, R3, R0
BRz SET_FLAG
BR END_SET_FLAG

SET_FLAG
    ADD R5, R5, #1    ; Flag = 1
    BR AFTER_FIRST_CHAR_LOOP
END_SET_FlAG

; Case 3: is it = '-'? if so, set neg flag, go get digits
LD R3, MINUS_CHECK
ADD R3, R3, R0
BRz AFTER_FIRST_CHAR_LOOP

; Case 4: is it < '0' and > '9'? if so, it is not a digit	- o/p error message, start over
; if < "0"
LD R3, DEC_48       ; R3 now has ASCII 48 (0)
NOT R3, R3
ADD R3, R3, #1      ; take 2's complement
ADD R3, R3, R0      ; compare R3 and R0
BRn ERROR           ; Case 5: if R3 negetive, mean < 0, error 
; if > "9"
LD R3, DEC_57       ; R3 now has ASCII 57 (9)
NOT R3, R3
ADD R3, R3, #1      ; take 2's complement
ADD R3, R3, R0      ; compare R3 and R0
BRp ERROR	        ; Case 5: if R3 positive, mean > 9, error

; complete digit validation, all digit are valid, set flag and decrement counter
ADD R5, R5, #1      ; Flag is 1
BR JUMP_GET_CHAR

; if none of the above, first character is first numeric digit - convert it to number & store in target register!
; Step 1: Get char and out
; Step 2: 2 case: "D" or "Other"
;     "D": R4 = R0*10+D (R0)
;     "Other": Error
; Step 3: Counter(R2) --
; Step 4: Repeat Loop

; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator


AFTER_FIRST_CHAR_LOOP
    ; 1. get char and input
    GETC
    OUT
    ; add a check if it's a digit
    JUMP_GET_CHAR
    
    ; if new line, quit
    LD R3, NEWLINE_CHECK
    ADD R3, R3, R0
    BRz CHECK_FLAG
    ; if < "0"
    LD R3, DEC_48       ; R3 now has ASCII 48 (0)
    NOT R3, R3
    ADD R3, R3, #1      ; take 2's complement
    ADD R3, R3, R0      ; compare R3 and R0
    BRn ERROR           ; Case 5: if R3 negetive, mean < 0, error 
    ; if > "9"
    LD R3, DEC_57       ; R3 now has ASCII 57 (9)
    NOT R3, R3
    ADD R3, R3, #1      ; take 2's complement
    ADD R3, R3, R0      ; compare R3 and R0
    BRp ERROR	        ; Case 5: if R3 positive, mean > 9, error
    
    ; 2. R4 = R4*10+R0
    LD R7, NEG_48
    ADD R0, R7, R0
    
    AND R6, R6, x0
    AND R7, R7, x0
    ADD R7, R7, #10
    
    ; R6 = R4 * 10
    LOOP
        ADD R6, R6, R4
        ADD R7, R7, #-1
    BRp LOOP
    
    ADD, R4, R6, R0
    
    ; 3. Counter --
    ADD R2, R2, #-1
    ; 4. Repeat Loop
    BRp AFTER_FIRST_CHAR_LOOP
END_AFTER_FIRST_CHAR_LOOP


; 5. if R5 is 0, take 2's complement of R4, if R5 is 1, do nothing
; Flag: 1 mean postive(flag), 0 mean negetive

CHECK_FLAG
    ADD R5, R5, #0
    BRz TWO_COMPLE_R4
    BRnp END_PROGRAM

TWO_COMPLE_R4
    NOT R4, R4
    ADD R4, R4, #1


END_PROGRAM

; remember to end with a newline!
LD R0, NEWLINE
OUT
		
HALT

;---------------	
; Program Data
;---------------

introPromptPtr  .FILL xB000
errorMessagePtr .FILL xB200
NEWLINE         .FILL x0A
NEWLINE_CHECK   .FILL #-10
PLUS_CHECK      .FILL #-43
MINUS_CHECK     .FILL #-45

NEG_48          .FILL #-48
DEC_5           .FILL #5
DEC_48          .FILL #48
DEC_57          .FILL #57

.END

;------------
; Remote data
;------------
.ORIG xB000	 ; intro prompt
.STRINGZ	 "Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"

.END					
					
.ORIG xB200	 ; error message
.STRINGZ	 "ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
