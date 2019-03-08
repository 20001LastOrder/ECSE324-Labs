		.text
		.global FIB

FIB: 	PUSH {LR, R4, R5, R6}
		CMP R0, #2
        BLT DEFAULT
        MOV R6, R0
		SUB R0, R6, #1
		BL FIB
		MOV R4, R0
		SUB R0, R6, #2
		BL FIB
		MOV R5, R0
		ADD R4, R4, R5
		B DONE
DEFAULT:   
		MOV R4,#1
DONE:	MOV R0, R4
		POP {LR, R4, R5, R6}
		BX LR
