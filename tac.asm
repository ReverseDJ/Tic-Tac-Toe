;Justin Dhillion   4/25/2021
;Tic tac toe game where the user has to input where they want their shape to go based on 9
;different spots to choose from. After each turn, the symbol changes from X to O or vice versa



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
		
BLACK		.FILL x0000			;The color black
BLANK		.FILL #15872		;The amount of pixel
START		.FILL xC000			;Starting address of the display
STARTV		.FILL xC01E			;Starting address of the first vertical line
STARTH		.FILL xCF00 		;Starting address of the first horizontal line
WHITE		.FILL x7FFF			;Color white
PIXELS		.FILL #90			;Number of pixels in the boxes formed in DRAWB
ROW			.FILL #128			;Offset to get to the next row
ROWB		.FILL #108			;Offset to get to the next row in DRAWB
OFFV		.FILL #30			;Offset to draw the next veritcal line
OFFH		.FILL #3840			;Offset to draw the next horizontal line
BLOCK		.FILL #20			;Number of pixels in each block row
BLOCKX		.FILL xA000			;Starting address of blockx.asm
BLOCKO		.FILL xA200			;Starting address of blocko.asm

CLEAR	LD R5, START			;Load the starting pixel address into R5
		LD R4, BLANK			;Counter for the number of pixels
		LD R0, BLACK			;Load the color black into R0
		
SCREEN	STR R0, R5, #0			;Put the color black into the designated pixel
		ADD R5, R5, #1			;Move the pixel one to the right
		ADD R4, R4, #-1			;Decrement the counter by 1
		BRp SCREEN				;Loop until screen clear
		BRnzp BOARD
		
DRAWH	LD R5, STARTH			;Subroutine to draw the horizonal lines
		ADD R5, R5, R1			;Add the offset of the starting position to see where to draw the line
		LD R4, PIXELS			;Counter for the number of pixels
		LD R0, WHITE			;Load the color white into R0
		
HOR		STR R0, R5, #0			;Loop to draw the horizontal line with the loaded values
		ADD R5, R5, #1			
		ADD R4, R4, #-1	
		BRp HOR
		RET

DRAWV	LD R5, STARTV			;Subroutine to draw the horizonal lines
		ADD R5, R5, R1			;Add the offset of the starting position to see where to draw the line
		LD R4, PIXELS			;Counter for the number of pixels
		LD R3, ROW				;Offset for the row
		LD R0, WHITE			;Load the color white into R0
		
VER		STR R0, R5, #0			;Loop to draw the vertical line with the loaded values
		ADD R5, R5, R3 	
		ADD R4, R4, #-1
		BRp VER
		RET
		
BOARD	JSR DRAWH				;This is the main code that draws the tic-tac-toe board
		LD R1, OFFH				;using the DRAWV and DRAWH subroutines
		JSR DRAWH
		AND R1, R1, #0
		JSR DRAWV
		LD R1, OFFV
		JSR DRAWV
		
CODE	JSR GETMOV				;This is the main code that puts the symbols in the right spots 
		JSR CHECK				;based on the input from the user using GETMOV, CHECK, DRAWB, and SWITCH
		JSR DRAWB
		JSR SWITCH
		BRnzp CODE				;Code loops infinitely
		
		
GETMOV	BRnzp TEST				;First, GETMOV tests if it is X turn or O turn
		
GOX		LEA R0 XPROMPT			;If TEST resulted in 0, the X prompt displays, if TEST resulted in 1, the O prompt displays
		ST R7, SEVEN			;Save the R7 value so it doesn't change with the TRAP commands
		PUTS
		LD R7, SEVEN
		AND R6, R6, #0 			;Set alternator value equal to 0 so the program knows it's X's turn
		BRnzp FIRST				;Unconditional branch to first
		
GOO		LEA R0 OPROMPT			;Same as GOX, but this is for the O prompt
		ST R7, SEVEN
		PUTS
		LD R7, SEVEN
		AND R6, R6, #0 
		ADD R6, R6, #1			;Set alternator value equal to 0 so the program knows it's X's turn
		
FIRST	ST R7, SEVEN			;Save R7
		GETC					;Get the box number from user and echo it
		OUT			
		LD R7, SEVEN			;Reload the PC
		LD R2, ascii			;Convert the input from ascii to decimal and store it in R1
		ADD R1, R0, R2
		
SORT	ST R7, SEVEN			;Save R7
		GETC					;The user should hit enter here and echo it
		OUT	
		LD R7, SEVEN
		LD R2, ENT				;Load the value and add to see if the user did hit enter
		ADD R2, R0, R2
		BRz ENTER				;If they did hit enter, branch to ENTER
		AND R0, R0, #0 			;If not, set R1 to -1, which means it's an illegal move ,so then you just loop back until the user hits enter
		ADD R1, R0, #-1
		BRnzp SORT
		
ENTER	ADD R1, R1, #0			;Check if R1 is -1. If so, re-prompt the user 
		BRn GETMOV
		LD R2, asciiq 			;Check if the user typed q
		ADD R2, R1, R2
		BRnp NUMTEST			;If it's not q, check if its a valid number. If so, branch to NUMTEST
		AND R1, R1, #0
		ADD R1, R1, #9			;Since they typed q, set R1 to 9 and halt
		HALT
		
NUMTEST	ADD R3,R1,#0			;Check if the number is above 0
		BRzp RANGE				;If so, go to RANGE to see if its 8 or below
TEST	ADD R6, R6, #0			;If the input is illegal, reprompt based on if it was X or O turn. 
		BRz GOX					;This label TEST is also used to see which prompt to put in the beginning
		BRnzp GOO
		
RANGE	LD R2, nmaxrange		;Checks if the input is 0-8
		ADD R3, R1, R2
		BRp	TEST				;If not, branch to TEST
		ST R1, SPOT				;Store the user input into SPOT
		RET						;Return to main code

DRAWB	ADD R6, R6, #0			;Check if we should draw and X or an O
		BRz X
		BRnzp O
		
X		LD R2, BLOCKX			;If we need to draw an X, load the origin of blockx.asm and the color yellow
		LD R3, YELLOW
		BRnzp MARK

O		LD R2, BLOCKO			;If we need to draw an O, load the origin of blocko.asm and the color green
		LD R3, GREEN

MARK	LD R4, BLOCK			;This label decides which box to draw the X or O. Load the "pixel per row" counter into R4
		LEA R5, ZERO			;There is an array on line 206 that has the origin locations of all of the spots
		ADD R5, R5, R1			;Here, we are loading the address of the first origin, adding the user's entry, and getting the value of the address
		LDR R5, R5, #0
		LD R1, BLOCK			;Load the row counter
		
LOOP1	LDR R0, R2, #0			;Load the value of the first address in either blockx or blocko
		BRp ASSIGN				;Checks if it's a 0 or 1, If 1, branch to ASSIGN
		ADD R5, R5, #1			;If 0, increment the addresses of the graphic display and blockx or blocko, and decrement the pixel counter
		ADD R2, R2, #1
		ADD R4, R4, #-1
		BRz NEXT				;If the row is full of pixels, branch to NEXT to go to the next row
		BRnzp LOOP1				;If not, loop until that is the case
		
ASSIGN	STR R3, R5, #0			;Store the color of the pixel into the address of the grapic address
		ADD R5, R5, #1			;Increment the addresses of the graphic display and blockx or blocko, and decrement the pixel counter
		ADD R2, R2, #1
		ADD R4, R4, #-1
		BRz NEXT				;If the row is full of pixels, branch to NEXT to go to the next row
		BRnzp LOOP1				;If not, loop until that is the case

NEXT	LD R4, ROWB				;This label loads a row offset and moves the graphic address to the next row and decrements the row counter by 1
		ADD R5, R5, R4
		LD R4, BLOCK
		ADD R1, R1, #-1			;This line decrements the row counter by 1
		BRp LOOP1				;Loop back to LOOP1
		
FILL	LEA R0, OCCUPIED		;This label fills the occupied spot once it is drawn. OCCUPIED is an array of blank .FILLs
		LD R1, SPOT				;Load the users number
		ADD R0, R1, R0			;Get the address of the spot dedicated to a certain spot
		LD R1, NO				;Load the number 1 into R1
		STR R1, R0, #0			;Store the number 1 into that location to show that that spot is occupied
		RET						;Return to the main code
		
SWITCH	NOT R6, R6				;This subroutine changes a 1 to a 0 or a 0 to a 1 and stores it back in R6
		AND R6, R6, #1			;This is used to tell the program who's turn it is
		RET						;Return to main code

CHECK	LEA R0, OCCUPIED		;This subroutine checks if the spot is filled already
		LD R1, SPOT
		ADD R0, R1, R0
		LDR R0, R0, #0			
		BRp SKIP				;If the address of the spot has a 1, then go to SKIP. 
		RET						;If not, return  to the main program and run as normal
		
SKIP	ADD R7, R7, #-2			;If the spot is occupied, set the PC behind where it was called from so it can call GETMOV again
		RET						;Return to the main code

SPOT		.BLKW #1			;Empty line to store the user input
SEVEN		.BLKW #1			;Empty line to store R7
OCCUPIED	.BLKW #9			;Array of occupied slots to show which spots are occupied
XPROMPT		.STRINGZ "X move: "	;Prompt for the X turn
OPROMPT		.STRINGZ "O move: "	;Prompt for the O turn
NO			.FILL #1			;The number 1
nmaxrange	.FILL #-8			;Offset to test if input is in the range 0-8
ascii		.FILL #-48			;Offset to convert from ascii to decimal
asciiq		.FILL #-65			;Offset to test if the user input q
ENT			.FILL #-10			;Offset to test if the user input q
GREEN		.FILL x03E0 		;The color green in hex
YELLOW		.FILL x7FED			;The color yellow in hex

ZERO	.FILL xC285				;Array of origins for each block of pixels on the board
ONE		.FILL xC2A3
TWO		.FILL xC2C1
THREE	.FILL xD185
FOUR	.FILL xD1A3
FIVE	.FILL xD1C1
SIX		.FILL xE085
SEV		.FILL xE0A3
EIGHT	.FILL xE0C1

.END							;END