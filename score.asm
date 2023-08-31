;Justin Dhillion   4/12/2021
;Program 1: Print the given hex number in a graphic design using 7 segment code. 
;Display the numbers or letters in red on the display board

;P.S. I know that the last two digits don't print. I couldn't get it to work with the space in between labels and branches.
;All of the letters and numbers on the display should be correct and every other aspect of the code should work, it just doesn't
;display the last two letters/numbers that are inputed, however they are saved in memory into SLOT3 and SLOT4.

		.ORIG x3000     		;Start at address x3000
CLEAR0	AND R0, R0, #0  		;Clear all the registers
		AND R1, R1, #0
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0
		AND R7, R7, #0
		BRnzp CLEAR
	
BLACK1		.FILL x0000			;The color black
PIXELS		.FILL #15872		;The amount of pixel
FILL		.FILL #16			;Use the value 16 to input into the memory when the user hits enter
START		.FILL xC000			;Starting address of the display
ENTER 		.FILL #-10			;Offset to test if the user input the enter key
numadjust	.FILL #-48			;Offset to change ascii numbers to numbers
alphaadjust	.FILL #-87			;Offset to change ascii letters to numbers
lmaxrange	.FILL #-102			;Offset to test if input is in the range A-F
lminrange	.FILL #-97			;Offset to test if input is in the range A-F
nmaxrange	.FILL #-57			;Offset to test if input is in the range 0-9
nminrange	.FILL #-48			;Offset to test if input is in the range 0-9
asciiq		.FILL #-113			;Offset to see if the input is q
PROMPT1 	.STRINGZ "\nEnter between 1 and 4 hex characters from 0 to F: "		;Prompt string 
q 			.STRINGZ "Thank you for playing  Go Wolfpack!"						;Quit string
		
		
CLEAR	LD R5, START			;Load the starting pixel address into R5
		LD R4, PIXELS			;Counter for the number of pixels
		LD R0, BLACK1			;Load the color black into R0
		
SCREEN	STR R0, R5, #0			;Put the color black into the designated pixel
		ADD R5, R5, #1			;Move the pixel one to the right
		ADD R4, R4, #-1			;Decrement the counter by 1
		BRp SCREEN				;Loop until screen clear
	
START1	LEA R0 PROMPT1			;Prompt the user to type in their first hex value
		PUTS					;Display the input value back to the user
			
LOOP1
QCHECK1	GETC 					;Recieve and input from the user
		OUT						;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1			;Subtract the ascii value of q from the entered value
		BRnp SORT1				;Check if the input is q. If it is not q, go to label SORT1
		LEA R0, q				;If the input is q, load the quit string stored in label "q" into R0
		PUTS					;Display the string back to the user
		HALT					;The program is finished if the user recieved their quit message
		
SORT1	LD R1 nmaxrange			;Sort input into either a possible number or letter
		ADD R2, R0, R1
		BRp LETTER1		
				
NUMBER1	LD R1 nminrange			;This label checks if the possible number really is a number
		ADD R2,R0,R1			;If it is a number, store into SLOT1, if not, loop back and try again
		BRn LOOP1
		LD R1 numadjust
		ADD R0, R0, R1
		ST R0 SLOT1
		BRnzp LOOP2
	
LETTER1	LD R1 lminrange			;This label checks if the possible letter really is a letter
		ADD R2, R1,R0			;If it is a letter, store into SLOT1, if not, loop back and try again
		BRn LOOP1
		LD R1 lmaxrange
		ADD R2, R1, R0
		BRp LOOP1
		LD R1 alphaadjust
		ADD R0, R0, R1
		ST R0 SLOT1
		
LOOP2
QCHECK2	GETC 					;Recieve and input from the user
		OUT						;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1			;Subtract the ascii value of q from the entered value
		BRnp SORT2				;Check if the input is q. If it is not q, go to label SORT2
		LEA R0, q				;If the input is q, load the quit string stored in label "q" into R0
		PUTS					;Display the string back to the user
		HALT					;The program is finished if the user recieved their quit message
		
SORT2	LD R1 ENTER
		ADD R2, R0, R1			;Check if the user hit enter as their second input
		BRz FILL2				;If the user input enter, branch to FILL2
		LD R1 nmaxrange
		ADD R2, R0, R1
		BRp LETTER2
		BRn NUMBER2
		
FILL2	LD R2, FILL				;Loads the number #16 into the remaining number slots since the user hit enter
		ST R2, SLOT2
		LD R2, FILL
		ST R2, SLOT3
		LD R2, FILL
		ST R2, SLOT4
		BRnzp FIRST

NUMBER2	LD R1 nminrange			;See NUMBER1 for description (Line 61)
		ADD R2,R0,R1
		BRn LOOP2
		LD R1 numadjust
		ADD R0, R0, R1
		ST R0 SLOT2
		BRnzp LOOP3
	
LETTER2	LD R1 lminrange			;See LETTER1 for description (Line 69)
		ADD R2, R1,R0	
		BRn LOOP2
		LD R1 lmaxrange
		ADD R2, R1, R0
		BRp LOOP2
		LD R1 alphaadjust
		ADD R0, R0, R1
		ST R0 SLOT2
		
LOOP3
QCHECK3	GETC 					;Recieve and input from the user
		OUT						;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1			;Subtract the ascii value of q from the entered value
		BRnp SORT3				;Check if the input is q. If it is not q, go to label SORT3
		LEA R0, q				;If the input is q, load the quit string stored in label "q" into R0
		PUTS					;Display the string back to the user
		HALT					;The program is finished if the user recieved their quit message
		
SORT3	LD R1 ENTER
		ADD R2, R0, R1			;Check if the user hit enter as their third input
		BRz FILL3				;If the user input enter, branch to FILL3
		LD R1 nmaxrange
		ADD R2, R0, R1
		BRp LETTER3
		BRn NUMBER3

FILL3	LD R2, FILL				;See FILL2 for description (Line 97)
		ST R2, SLOT3
		LD R2, FILL
		ST R2, SLOT4
		BRnzp FIRST
		
NUMBER3	LD R1 nminrange			;See NUMBER1 for description (Line 61)
		ADD R2,R0,R1
		BRn LOOP3
		LD R1 numadjust
		ADD R0, R0, R1
		ST R0 SLOT3
		BRnzp LOOP4
	
LETTER3	LD R1 lminrange			;See LETTER1 for description (Line 69)
		ADD R2, R1,R0
		BRn LOOP3
		LD R1 lmaxrange
		ADD R2, R1, R0
		BRp LOOP3
		LD R1 alphaadjust
		ADD R0, R0, R1
		ST R0 SLOT3
LOOP4
QCHECK4	GETC 					;Recieve and input from the user
		OUT						;Display the user input back to the user
		LD R1, asciiq 	
		ADD R2, R0, R1			;Subtract the ascii value of q from the entered value
		BRnp SORT4				;Check if the input is q. If it is not q, go to label SORT3
		LEA R0, q				;If the input is q, load the quit string stored in label "q" into R0
		PUTS					;Display the string back to the user
		HALT					;The program is finished if the user recieved their quit message
		
SORT4	LD R1 ENTER
		ADD R2, R0, R1			;Check if the user hit enter as their fourth input
		BRz FILL4				;If the user input enter, branch to FILL4
		LD R1 nmaxrange
		ADD R2, R0, R1
		BRp LETTER4
		BRn NUMBER4

FILL4	LD R2, FILL				;See FILL2 for description (Line 97)
		ST R2, SLOT4	
		BRnzp FIRST
		
NUMBER4	LD R1 nminrange			;See NUMBER1 for description (Line 61)
		ADD R2,R0,R1
		BRn LOOP4
		LD R1 numadjust
		ADD R0, R0, R1
		ST R0 SLOT4
		BRnzp FIRST
	
LETTER4	LD R1 lminrange			;See LETTER1 for description (Line 69)
		ADD R2, R1,R0
		BRn LOOP4
		LD R1 lmaxrange
		ADD R2, R1, R0
		BRp LOOP4
		LD R1 alphaadjust
		ADD R0, R0, R1
		ST R0 SLOT4
		BRnzp FIRST


FIRST 	JSR DRAW1				;Draw the graphic for the first digit
SECOND	JSR DRAW2				;Draw the graphic for the second digit
THIRD	BRnzp START1			;Loop back to the beginning 
FOURTH	;JSR DRAW3				;This is where I was going to the subroutine for the last two inputs.
		;JSR DRAW4

DRAW1	LD R0, SLOT1			;This label makes branches according to what number is in R0
		BRz ZERO1				;If R0=0, then branch to the label that creates the 0 graphic
		ADD R0, R0, #-1			;If R0=1, then branch to the label that creates the 1 graphic, etc.
		BRz	ONE1				;This is also the exact same process for DRAW2
		ADD R0, R0, #-1
		BRz TWO1
		ADD R0, R0, #-1
		BRz THREE1
		ADD R0, R0, #-1
		BRz FOUR1
		ADD R0, R0, #-1
		BRz FIVE1
		ADD R0, R0, #-1
		BRz SIX1
		ADD R0, R0, #-1
		BRz SEVEN1
		ADD R0, R0, #-1
		BRz EIGHT1
		ADD R0, R0, #-1
		BRz NINE1
		ADD R0, R0, #-1
		BRz A1
		ADD R0, R0, #-1
		BRz BEE1
		ADD R0, R0, #-1
		BRz C1
		ADD R0, R0, #-1
		BRz D1
		ADD R0, R0, #-1
		BRz E1
		ADD R0, R0, #-1
		BRz F1
		ADD R0, R0, #-1			;Since R0=16 is the case when the user hits enter, by the time the counter decrements to here, it will be at 0 if R0=16
		BRz BLANK1				;BLANK1 just draws an 8 in all black so it is not visible to the user
			
		
SLOT1		.BLKW #1			;Reserve one line of memory for SLOT1, SLOT2, SLOT3, SLOT4
SLOT2		.BLKW #1
SLOT3		.BLKW #1
SLOT4		.BLKW #1
								;THIS APPLIES TO A MAJORITY OF MY CODE:
ZERO1 	JSR	DRAWAR1				;Subroutines that draw the characters 0-F
		JSR	DRAWBR1				;In my program, AR1 means that the graphic  
		JSR	DRAWCR1				;will be drawn in the input 1 spot (far left),
		JSR	DRAWDR1				;and it will draw a segment A in red
		JSR	DRAWER1
		JSR	DRAWFR1				;EX. BB2 would be segment B in black in spot 2
		JSR DRAWGB1				;For the case of the number 0, the display should turn every segment red except G, which can be seen in the label ZERO1
		BRnzp SECOND			;After the character is drawn, branch to label that draws the second input (SECOND). 
								;This pattern continues for the rest of the code 
ONE1	JSR DRAWAB1	
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDB1	
		JSR DRAWEB1	
		JSR DRAWFB1	
		JSR DRAWGB1	
		BRnzp SECOND

TWO1	JSR DRAWAR1
		JSR	DRAWBR1
		JSR DRAWCB1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFB1	
		JSR DRAWGR1	
		BRnzp SECOND
		
THREE1	JSR DRAWAR1	
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDR1	
		JSR DRAWEB1	
		JSR DRAWFB1	
		JSR DRAWGR1	
		BRnzp SECOND
		
FOUR1	JSR DRAWAB1
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDB1	
		JSR DRAWEB1
		JSR DRAWFR1
		JSR DRAWGR1
		BRnzp SECOND
		
FIVE1	JSR DRAWAR1
		JSR	DRAWBB1
		JSR DRAWCR1
		JSR DRAWDR1	
		JSR DRAWEB1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND
		
SIX1	JSR DRAWAR1
		JSR	DRAWBB1
		JSR DRAWCR1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND
		
SEVEN1	JSR DRAWAR1
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDB1	
		JSR DRAWEB1	
		JSR DRAWFB1	
		JSR DRAWGB1	
		BRnzp SECOND

EIGHT1  JSR DRAWAR1
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND
		
NINE1	JSR DRAWAR1
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDB1	
		JSR DRAWEB1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND
		
A1		JSR DRAWAR1
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDB1	
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND	
		
BEE1	JSR DRAWAB1
		JSR	DRAWBB1
		JSR DRAWCR1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND

C1		JSR DRAWAR1
		JSR	DRAWBB1
		JSR DRAWCB1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGB1	
		BRnzp SECOND

D1		JSR DRAWAB1
		JSR	DRAWBR1
		JSR DRAWCR1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFB1	
		JSR DRAWGR1	
		BRnzp SECOND
		
E1		JSR DRAWAR1
		JSR	DRAWBB1
		JSR DRAWCB1
		JSR DRAWDR1	
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND

F1		JSR DRAWAR1
		JSR	DRAWBB1
		JSR DRAWCB1
		JSR DRAWDB1
		JSR DRAWER1	
		JSR DRAWFR1	
		JSR DRAWGR1	
		BRnzp SECOND	
		
BLANK1	JSR DRAWAB1		;Draws all black segments
		JSR	DRAWBB1
		JSR DRAWCB1
		JSR DRAWDB1
		JSR DRAWEB1
		JSR DRAWFB1
		JSR DRAWGB1
		BRnzp SECOND
		
THIRD1	BRnzp THIRD			;Had to add this because branch was out of range

DRAW2	LD R0, SLOT2		;See DRAW1 for description (Line 212)
		BRz ZERO2
		ADD R0, R0, #-1
		BRz	ONE2
		ADD R0, R0, #-1
		BRz TWO2
		ADD R0, R0, #-1
		BRz THREE2
		ADD R0, R0, #-1
		BRz FOUR2
		ADD R0, R0, #-1
		BRz FIVE2
		ADD R0, R0, #-1
		BRz SIX2
		ADD R0, R0, #-1
		BRz SEVEN2
		ADD R0, R0, #-1
		BRz EIGHT2
		ADD R0, R0, #-1
		BRz NINE2
		ADD R0, R0, #-1
		BRz A2
		ADD R0, R0, #-1
		BRz BEE2
		ADD R0, R0, #-1
		BRz C2
		ADD R0, R0, #-1
		BRz D2
		ADD R0, R0, #-1
		BRz E2
		ADD R0, R0, #-1
		BRz F2
		ADD R0, R0, #-1
		BRz BLANK2

ZERO2 	JSR	DRAWAR2			;See ZERO1 for description (Line 253)
		JSR	DRAWBR2
		JSR	DRAWCR2
		JSR	DRAWDR2
		JSR	DRAWER2
		JSR	DRAWFR2
		JSR DRAWGR2
		BRnzp THIRD1
		
ONE2	JSR DRAWAB2	
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDB2	
		JSR DRAWEB2	
		JSR DRAWFB2	
		JSR DRAWGB2	
		BRnzp THIRD1

TWO2	JSR DRAWAR2
		JSR	DRAWBR2
		JSR DRAWCB2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFB2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
THREE2	JSR DRAWAR2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDR2	
		JSR DRAWEB2	
		JSR DRAWFB2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
FOUR2	JSR DRAWAB2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDB2	
		JSR DRAWEB2
		JSR DRAWFR2
		JSR DRAWGR2
		BRnzp THIRD1
		
FIVE2	JSR DRAWAR2
		JSR	DRAWBB2
		JSR DRAWCR2
		JSR DRAWDR2	
		JSR DRAWEB2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
SIX2	JSR DRAWAR2
		JSR	DRAWBB2
		JSR DRAWCR2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
SEVEN2	JSR DRAWAR2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDB2	
		JSR DRAWEB2	
		JSR DRAWFB2	
		JSR DRAWGB2	
		BRnzp THIRD1

EIGHT2  JSR DRAWAR2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
NINE2	JSR DRAWAR2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDB2	
		JSR DRAWEB2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
A2		JSR DRAWAR2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDB2	
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
BEE2	JSR DRAWAB2
		JSR	DRAWBB2
		JSR DRAWCR2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1

C2		JSR DRAWAR2
		JSR	DRAWBB2
		JSR DRAWCB2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGB2	
		BRnzp THIRD1

D2		JSR DRAWAB2
		JSR	DRAWBR2
		JSR DRAWCR2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFB2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
E2		JSR DRAWAR2
		JSR	DRAWBB2
		JSR DRAWCB2
		JSR DRAWDR2	
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1

F2		JSR DRAWAR2
		JSR	DRAWBB2
		JSR DRAWCB2
		JSR DRAWDB2
		JSR DRAWER2	
		JSR DRAWFR2	
		JSR DRAWGR2	
		BRnzp THIRD1
		
BLANK2	JSR DRAWAB2
		JSR	DRAWBB2
		JSR DRAWCB2
		JSR DRAWDB2
		JSR DRAWEB2
		JSR DRAWFB2
		JSR DRAWGB2
		BRnzp THIRD1
		
DRAWAR1	LD R5, ORIGA1			;These labels are loading the necessary values to draw a red segment.
		LD R4, CTR10			;As stated before, AR1 means segment A in red in spot 1
		LD R3, CTR5				;This label, as well as all of the others, will load the origin of the segment, 
		LD R0, RED				;the color, the counters, and then branches over to the loop that corresponds to
		BRnzp LOOPA				;the segment being draw, in this case it is A. This rule applies for all segments
		
DRAWAR2	LD R5, ORIGA2
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPA

DRAWAR3	LD R5, ORIGA3
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPA
		
DRAWAR4	LD R5, ORIGA4
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPA

DRAWAB1	LD R5, ORIGA1
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPA
		
DRAWAB2	LD R5, ORIGA2
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPA
		
DRAWAB3	LD R5, ORIGA3
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPA
		
DRAWAB4	LD R5, ORIGA4
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPA
		
ORIGA1		.FILL xCE13		;These are the origins of the A segments depending on which spot they go in
ORIGA2		.FILL xCE2C		;ORIGA1 is the origin of segment A when it is being used in the first spot
ORIGA3		.FILL xCE45		;ORIGA2 is the origin of segment A when it is being used in the second spot, etc
ORIGA4		.FILL xCE5E		;This pattern applies to everything moving forward that starts with ORIG
		
LOOPA	STR R0, R5, #0		;This loop draws each color pixel by pixel
		ADD R5, R5, #1		;and has another loop inside for when the address
		ADD R4, R4, #-1		;needs to go to the next row. Once the whole segment has been drawn,
		BRp LOOPA			;the program returns to the program counter stored in R7, which depends
		LD R4, CTR1			;on which letter or number the display is making
		LD R1, ROWA			
		ADD R5, R5, R1		;This pattern continues for 400 lines
		ADD R3, R3, #-1
		BRp LOOPA
		RET					;Return back to the PC counter stored in R7
		
DRAWBR1	LD R5, ORIGB1		;See DRAWAR1 for description of entire section(Line 596)
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPB
		
DRAWBR2	LD R5, ORIGB2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPB
		
DRAWBR3	LD R5, ORIGB3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPB
		
DRAWBR4	LD R5, ORIGB4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPB
		
DRAWBB1	LD R5, ORIGB1
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPB
		
DRAWBB2	LD R5, ORIGB2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPB

DRAWBB3	LD R5, ORIGB3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPB
		
DRAWBB4	LD R5, ORIGB4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPB	

ORIGB1		.FILL xCF1C			;See ORIGA1 for description (Line 644)
ORIGB2		.FILL xCF35
ORIGB3		.FILL xCF4E
ORIGB4		.FILL xCF67		
		
LOOPB	STR R0, R5, #0			;See LOOPA for description (Line 649)
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp LOOPB
		LD R4, CTR4
		LD R1, ROWB
		ADD R5, R5, R1
		ADD R3, R3, #-1
		BRp LOOPB
		RET

DRAWCR1	LD R5, ORIGC1			;See DRAWAR1 for description of entire section (Line 596)
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPC

DRAWCR2	LD R5, ORIGC2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPC

DRAWCR3	LD R5, ORIGC3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPC
		
DRAWCR4	LD R5, ORIGC4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPC
		
DRAWCB1	LD R5, ORIGC1
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPC
		
DRAWCB2	LD R5, ORIGC2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPC
		
DRAWCB3	LD R5, ORIGC3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPC
		
DRAWCB4	LD R5, ORIGC4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPC
		
ORIGC1		.FILL xD71C			;See ORIGA1 for description (Line 644)
ORIGC2		.FILL xD735
ORIGC3		.FILL xD74E
ORIGC4		.FILL xD767
		
LOOPC	STR R0, R5, #0			;See LOOPA for description (Line 649)
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp LOOPC
		LD R4, CTR4
		LD R1, ROWB
		ADD R5, R5, R1
		ADD R3, R3, #-1
		BRp LOOPC
		RET
		
BLACK		.FILL x0000			;Fill BLACK with the hex of the color black
RED			.FILL x7C00			;Fill RED with the hex of the color red
ROWA		.FILL #118			;Offset when moving the next row with segments A, D ,and G
ROWB		.FILL #124			;Offset when moving the next row with segments B, C , E, and F
CTR4		.FILL #4			;Counter with 4
CTR15		.FILL #15			;Counter with 15
CTR5		.FILL #5			;Counter with 5
CTR10		.FILL #10			;Counter with 10
		
DRAWDR1	LD R5, ORIGD1			;See DRAWAR1 for description of entire section(Line 596)
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPD
		
DRAWDR2	LD R5, ORIGD2
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPD
		
DRAWDR3	LD R5, ORIGD3
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPD
		
DRAWDR4	LD R5, ORIGD4
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPD
		
DRAWDB1	LD R5, ORIGD1
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPD
		
DRAWDB2	LD R5, ORIGD2
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPD
		
DRAWDB3	LD R5, ORIGD3
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPD
		
DRAWDB4	LD R5, ORIGD4
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPD
		
ORIGD1		.FILL xDD13			;See ORIGA1 for description (Line 644)
ORIGD2		.FILL xDD2C
ORIGD3		.FILL xDD45
ORIGD4		.FILL xDD5E
		
LOOPD	STR R0, R5, #0			;See LOOPA for description (Line 649)
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp LOOPD
		LD R4, CTR10
		LD R1, ROWA
		ADD R5, R5, R1
		ADD R3, R3, #-1
		BRp LOOPD
		RET
		
DRAWER1	LD R5, ORIGE1			;See DRAWAR1 for description of entire section(Line 596)
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPE
		
DRAWER2	LD R5, ORIGE2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPE
		
DRAWER3	LD R5, ORIGE3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPE
		
DRAWER4	LD R5, ORIGE4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPE
		
DRAWEB1	LD R5, ORIGE1
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPE
		
DRAWEB2	LD R5, ORIGE2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPE
		
DRAWEB3	LD R5, ORIGE3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPE
		
DRAWEB4	LD R5, ORIGE4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPE
		
ORIGE1		.FILL xD710			;See ORIGA1 for description (Line 644)
ORIGE2		.FILL xD729
ORIGE3		.FILL xD742
ORIGE4		.FILL xD75B		
		
LOOPE	STR R0, R5, #0			;See LOOPA for description (Line 649)
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp LOOPE
		LD R4, CTR4
		LD R1, ROWB
		ADD R5, R5, R1
		ADD R3, R3, #-1
		BRp LOOPE
		RET
		
DRAWFR1	LD R5, ORIGF1			;See DRAWAR1 for description of entire section(Line 596)
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPF
		
DRAWFR2	LD R5, ORIGF2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPF
		
DRAWFR3	LD R5, ORIGF3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPF
		
DRAWFR4	LD R5, ORIGF4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, RED
		BRnzp LOOPF
		
DRAWFB1	LD R5, ORIGF1
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPF	

DRAWFB2	LD R5, ORIGF2
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPF	
		
DRAWFB3	LD R5, ORIGF3
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPF	
		
DRAWFB4	LD R5, ORIGF4
		LD R4, CTR4
		LD R3, CTR15
		LD R0, BLACK
		BRnzp LOOPF	

ORIGF1		.FILL xCF10			;See ORIGA1 for description (Line 644)
ORIGF2		.FILL xCF29
ORIGF3		.FILL xCF42
ORIGF4		.FILL xCF5B

LOOPF	STR R0, R5, #0			;See LOOPA for description (Line 649)
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp LOOPF
		LD R4, CTR4
		LD R1, ROWB
		ADD R5, R5, R1
		ADD R3, R3, #-1
		BRp LOOPF
		RET
		
DRAWGR1	LD R5, ORIGG1			;See DRAWAR1 for description of entire section(Line 596)
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPG
		
DRAWGR2	LD R5, ORIGG2
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPG
		
DRAWGR3	LD R5, ORIGG3
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPG
		
DRAWGR4	LD R5, ORIGG4
		LD R4, CTR10
		LD R3, CTR5
		LD R0, RED
		BRnzp LOOPG
		
DRAWGB1	LD R5, ORIGG1
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPG
		
DRAWGB2	LD R5, ORIGG2
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPG
		
DRAWGB3	LD R5, ORIGG3
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPG
		
DRAWGB4	LD R5, ORIGG4
		LD R4, CTR10
		LD R3, CTR5
		LD R0, BLACK
		BRnzp LOOPG
		
ORIGG1		.FILL xD593			;See ORIGA1 for description (Line 644)
ORIGG2		.FILL xD5AC
ORIGG3		.FILL xD5C5
ORIGG4		.FILL xD5DE		
		
LOOPG	STR R0, R5, #0			;See LOOPA for description (Line 649)
		ADD R5, R5, #1
		ADD R4, R4, #-1
		BRp LOOPG
		LD R4, CTR10
		LD R1, ROWA
		ADD R5, R5, R1
		ADD R3, R3, #-1
		BRp LOOPG
		RET
		
HALT							;Halt the program

.END							;End the program