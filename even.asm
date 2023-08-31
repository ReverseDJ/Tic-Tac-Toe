; Justin Dhillion   3/31/2021
; Program 1: Print the even numbers between two given values entered by the user.

		.ORIG x3000     ;Start at address x3000
CLEAR	AND R0, R0, #0  ;Clear all the registers
		AND R1, R0, #0
		AND R2, R0, #0
		AND R3, R0, #0
		AND R4, R0, #0
		AND R5, R0, #0
		AND R6, R0, #0
	
FIRST	LEA R0 PROMPT1	;Prompt the user to type in their first number
		PUTS			;Display the input value back to the user
	
LOOP1
QCHECK1	GETC 			;Recieve and input from the user
		OUT				;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1	;Subtract the ascii value of q from the entered value
		BRnp FNUM1		;Check if the input is q. If it is not q, go to label FNUM1
		LEA R0, q		;If the input is q, load the quit string stored in label "q" into R0
		PUTS			;Display the string back to the user
		HALT			;The program is finished if the user recieved their quit message

FNUM1	LD R1, UPRANGE1	
		ADD R2, R0, R1	;Adjust the ascii to see if ascii character is a number less than 9
		BRp LOOP1		;If the ascii character is positive, loop back to LOOP1
		LD R1 LOWRANGE1
		ADD R2, R0, R1	;Adjust the ascii to see if ascii character is a number greater than 0
		BRn LOOP1		;If the ascii character is negative, loop back to LOOP1
		LD R1, ascii	
		ADD R3, R0, R1	;Convert ascii value to decimal

LOOP2
QCHECK2	GETC 			;Recieve and input from the user
		OUT				;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1	;Convert the ascii input to decimal
		BRnp FNUM2		;Check if the input is q. If it is not q, go to label FNUM2
		LEA R0, q		;If the input is q, load the quit string stored in label "q" into R0
		PUTS			;Display the string back to the user
		HALT			;The program is finished if the user recieved their quit message

FNUM2	LD R1 ENTER
		ADD R2, R0, R1	;Check if the user hit enter as their second input
		BRz SECOND		;If the user input enter, branch to SECOND, and the first input stays in R3
		LD R1, UPRANGE2	
		ADD R2, R0, R1	;Adjust the ascii to see if ascii character is a number less than 9
		BRp LOOP2		;If the ascii character is positive, loop back to LOOP2
		LD R1 LOWRANGE2
		ADD R2, R0, R1	;Adjust the ascii to see if ascii character is a number greater than 0
		BRn LOOP2		;If the ascii character is negative, loop back to LOOP2
		LD R1, ascii
		ADD R3, R0, R1	;Convert the ascii value of R0 into decimal and store into R3
		ADD R3, R3, #10	;Given that the user input a two digit number, we know that the number must be ten plus the second entered digit
		
SECOND	
		LEA R0 PROMPT2	;Prompt the user to type in their first number
		PUTS
		
LOOP3
QCHECK3	GETC 			;Recieve and input from the user
		OUT				;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1	;Convert the ascii input to decimal
		BRnp FNUM3		;Check if the input is q. If it is not q, go to label FNUM3
		LEA R0, q		;If the input is q, load the quit string stored in label "q" into R0
		PUTS			;Display the string back to the user
		HALT			;The program is finished if the user recieved their quit message

FNUM3	LD R1, UPRANGE1	
		ADD R2, R0, R1	;Adjust the ascii to see if ascii character is a number less than 9
		BRp LOOP3		;If the ascii character is positive, loop back to LOOP 3
		LD R1 LOWRANGE1
		ADD R2, R0, R1	;Adjust the ascii to see if ascii character is a number greater than 0
		BRn LOOP3		;If the ascii character is positive, loop back to LOOP 3
		LD R1, ascii
		ADD R4, R0, R1	;Convert ascii value to decimal

LOOP4
QCHECK4	GETC 			;Recieve and input from the user
		OUT				;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1	;Convert the ascii input to decimal
		BRnp FNUM4		;Check if the input is q. If it is not q, go to label FNUM4
		LEA R0, q		;If the input is q, load the quit string stored in label "q" into R0
		PUTS			;Display the string back to the user
		HALT			;The program is finished if the user recieved their quit message

FNUM4	LD R1 ENTER		
		ADD R2, R0, R1	;Check if the user hit enter as their second input
		BRz OEQUAL		;If the user input enter, branch to OEQUAL
		LD R1, UPRANGE2	
		ADD R2, R0, R1	;If the user entered a number, adjust the ascii to see if ascii character is a number less than 9
		BRp LOOP4		;If the ascii character is positive, loop back to LOOP 4
		LD R1 LOWRANGE2
		ADD R2, R0, R1	;If the user entered a number, adjust the ascii to see if ascii character is a number less than 9
		BRn LOOP4		;If the ascii character is positive, loop back to LOOP 4
		LD R1, ascii
		ADD R4, R0, R1	;Convert the ascii value of R0 into decimal and store into R4
		ADD R4, R4, #10	;Given that the user input a two digit number, we know that the number must be ten plus the second entered digit
		

OEQUAL	LEA R0, PROMPT3	;Display the string notifying the user of their total
		PUTS
		AND R1, R3, #1 	;AND R3 with 1 to check if the value is even or odd, and store the value into R1
		BRz FINAL		;If the value is 0, that means the value was even, and it branches to FINAL
		AND R2, R4, #1	;AND R4 with 1 to check if the value is even or odd, and store the value into R2
		BRZ FINAL		;If the value is 0, that means the value was even, and it branches to FINAL
		NOT R1, R4		;Take the two's complement of R4 and store into R1
		ADD R1, R1, #1
		ADD R1, R1, R3
		BRz ODDS		;If the difference between the odd numbers is zero, then it branches to ODDS
		
FINAL	AND R1, R3, #1 	;AND R3 with 1 to check if the value is even or odd, and store the value into R1
		BRz SKIP1		;If the value is 0, that means the value was even, and it branches to SKIP1
		ADD R3, R3, #1	;Since the value of R3 is odd, add 1 to the value to make the starting value even
	
SKIP1	AND R2, R4, #1	;AND R4 with 1 to check if the value is even or odd, and store the value into R2
		BRz SKIP2		;If the value is 0, that means the value was even, and it branches to SKIP2
		ADD R4, R4, #-1	;Since the value of R4 is odd, add -11 to the value to make the starting value even
		
SKIP2	NOT R1, R4		;Take the two's complement of R4 and store it in R1
		ADD R1, R1, #1
		
EEQUAL	ADD R1, R1, R3	;Take the difference between R4 and R3
		BRz SKIP3		;If their difference is zero, then they are the same number and branch to SKIP3
		
		NOT R1, R4		;Take the two's complement of R4 and store it in R1
		ADD R1, R1, #1
		
ADDING	ADD R6, R6, R3	;Add the initial value (R3) to the R6, which will be the register that calulates the total
		ADD R3, R3, #2	;Add 2 to the original number to get the next number that will be added to R6
		ADD R5, R3, R1	;Take the difference between R3 and R4 to see if the max number has been reached 
		BRn ADDING		;If the value is negative, then the max has not been reached and loops back to ADDING
		
SKIP3	ADD R6, R6, R3	;Since the inputs are both the same even number, display just the number

		AND R1,R1,#0	;Clear R1 to use later
		ADD R5, R6, #-10;Adjust for the earlier addition test
		BRn SINGLE		;If the total is a single digit, branch to SINGLE
		
SUB1	ADD R1, R1,#1	;Use R1 as a counter for the tens place
		ADD R5, R5,#-10	;Use R5 as a counter for the ones place
		BRzp SUB1		;If the ones place is still zero or positive, loop back to SUB1
		
		ADD R5, R5, #10	;Adjust for subtraction test 
		LD R2, asciiplus
		ADD R0, R2, R1	;Convert to ascii
		OUT				;Print tens place back to user
		ADD R0, R2, R5	;Convert to ascii
		OUT				;Print ones place back to user
		HALT
		
SINGLE	LD R2, asciiplus
		ADD R0, R2, R6	;If the total is a single digit, conver to ascii
		OUT				;Print the ones place back to user
		HALT
		
ODDS	LD R0, ZERO
		ADD R0, R0, #0	;Given that the user input two identical odd numbers, the total should be zero
		OUT				;Print zero back to the user
		HALT
asciiq		.FILL #-113										;Offset to convert ascii to decimal and test if input is q
ascii		.FILL #-48										;Offset to convert from ascii to decimal
asciiplus	.FILL #48										;Offset to convert from decimal to ascii
UPRANGE1	.FILL #-57										;Offset to test the value of the ascii entered by the user
LOWRANGE1	.FILL #-48										;Offset to test the value of the ascii entered by the user
UPRANGE2	.FILL #-54										;Offset to test the value of the ascii entered by the user
LOWRANGE2	.FILL #-48										;Offset to test the value of the ascii entered by the user
ENTER 		.FILL #-10										;Offset to test if the user input the enter key
ZERO		.FILL #48										;Offset to convert decimal value to ascii value zero		
PROMPT1	.STRINGZ "Enter Start Number (0-16): "				;String to prompt the user to input their first number
PROMPT2	.STRINGZ "\nEnter End Number (0-16): "				;String to prompt the user to input their last number
PROMPT3 .STRINGZ "\nThe sum of every even number between the two numbers is: " ;String to prompt the user of their total
q		.STRINGZ "\nThank you for playing!"					;Quit message

.END														;End of code