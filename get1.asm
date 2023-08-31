;
;
	.ORIG x3000
	
	LEA R0, MYSTRING
	PUTS
	
	GETC
	
	OUT
	
	LD R1, NEG30
	ADD R0, R0, R1
	
	ADD R2, R0, R0  ;  double
	LEA R0, MY2
	PUTS
	LD R3, PLUS30
	ADD R0, R2, R3

	OUT
	HALT
	
	
MYSTRING	.STRINGZ "Please enter the number "
MY2         .STRINGZ "\n The double is "
NEG30       .FILL    #-48
PLUS30      .FILL  x0030

.END
