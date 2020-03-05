ORG 0x0000

LOADIMM.upper 255
LOADIMM.lower 254
MOV R0 R7 ; -2   -- This example tests how fast a multiplication operation is performed.
LOADIMM.lower 03
MOV R1 R7 ; 03   -- The values to be loaded into the corresponding register.
LOADIMM.lower 01
MOV R2 R7 ; 01   
LOADIMM.upper 0
LOADIMM.lower 05
MOV R3 R7 ; 05   --  End of initialization
MUL R6, R0, R3  ; expect -10
OUT R6
BRR 0

END