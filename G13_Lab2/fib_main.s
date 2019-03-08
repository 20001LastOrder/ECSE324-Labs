		.text
		.global _start

_start:	LDR R0, N
		LDR R4, =RESULT
		BL FIB
		STR R0, [R4]
DONE: 	B DONE

RESULT: .space 4
N:		.word 10
