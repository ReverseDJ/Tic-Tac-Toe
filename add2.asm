;
;
	.ORIG x3000
	
GO	AND R5, R5, 0
	AND R5, R5, 0
		
OUT1	LEA R0, MYSTRING1
	PUTS
	
	GETC
	
	OUT
	
	LD R1, NEG30
	ADD R0, R0, R1
	
	ADD R5, R5, R0		;store for later

OUT2	LEA R0, MYSTRING2
	PUTS
	
	GETC
	
	OUT
	
	LD R1, NEG30
	ADD R0, R0, R1
	
	ADD R6, R6, R0		;store for later
	
	ADD R1, R5, R6      ;  add two numbers
	LEA R0, MY2
	PUTS
	LD R3, PLUS30		; convert to ASCII
	ADD R0, R1, R3

	OUT
	HALT
	
	
MYSTRING1	.STRINGZ "Please enter the first number "
MYSTRING2	.STRINGZ "\nPlease enter the second number "
MY2         .STRINGZ "\n The sum is "
NEG30       .FILL    #-48
PLUS30      .FILL  x0030

.END
