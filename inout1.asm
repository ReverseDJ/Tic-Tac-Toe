;;
;
;   Bob Evans  ECE109  6/23/2020
;
;
;
		.ORIG x3000
		
		AND R5, R5, #0
		
		LEA R0, STRING1		; Load Effective Address into R0
		PUTS
		LEA R0, STRING2
		PUTS
		
		GETC 
		OUT					; echo
		
		ADD R5, R5, R0
		
		LEA R0, STRING3
		PUTS
		
		
		
		
		
		
		
		
		
		
		HALT
		
	STRING1 .STRINGZ "\n\n   Hello!  Welcome to our program! \n\n"
	STRING2 .STRINGZ "Enter a single character: "
	STRING3 .STRINGZ "\n\nThank you for playing!\n\n"