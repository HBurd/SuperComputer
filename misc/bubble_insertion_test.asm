ORG 0x0000
	LOADIMM.LOWER 0x5
	NOP
	NOP
	NOP
	MOV R0, R7
	LOADIMM.LOWER 0x01
	NOP
	NOP
	NOP
	LOADIMM.UPPER 0x40
	NOP
	NOP
	NOP
	MOV R1, R7
	MOV R2, R1
	MOV R3, R2
	MOV R4, R1
	STORE R1, R0
	LOAD R2, R1
	END
	