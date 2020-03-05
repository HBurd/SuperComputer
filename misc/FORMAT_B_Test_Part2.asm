ORG  0x0000

LOADIMM.lower 02	;	-- This example tests the branching capabilities of the design.No data dependencies.
MOV R0 R7
LOADIMM.lower 03	;	-- The values to be loaded into the corresponding register.
MOV R1 R7
LOADIMM.lower 01	;	
MOV R2 R7
LOADIMM.lower 05	;	--  End of initialization
MOV R3 R7
LOADIMM.lower 32	;	
MOV R4 R7
LOADIMM.lower 01	;	-- for absolute branching
MOV R5 R7
LOADIMM.lower 05	;	-- r6 is counter for the loop and indicates the number of times the loop is done.
MOV R6 R7
LOADIMM.lower 00	;	
BR.SUB R4, 1 		; 		-- Go to the subroutine
BRR 0     			; 		-- Infinite loop (the end of the program)
ADD R2, R1, R5  	;		-- Start of the subroutine. It runs for 5 times. R2 <-- R1 + 1
SUB R6, R6, R5  	; 		-- R6 <-- R6 - 1   The counter for the loop.
TEST R6         	; 		-- Set the z flag for the branch decision
BRR.z 2      	    ; 		-- If r6 is zero, jump out of the loop. 
BRR -4				; 		-- If not jump to the start of the subroutine.
RETURN 

END
