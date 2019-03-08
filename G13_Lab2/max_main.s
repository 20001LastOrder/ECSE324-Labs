		.text
		.global _start

_start:
			LDR R4, =RESULT		//R4 points to the result localtion
			LDR R0, [R4, #4] 	//R0 holds the number of elements in the list
			ADD R1, R4, #8		//R1 points to the first number
			BL MAX

DONE:		STR R0, [R4]		// store

END:		B END	


RESULT:		.word	0			//memory assigned for result location
N:			.word	7			//number of entries in the list
NUMBERS:	.word	4, 5, 6, 6, 1, 8, 2
