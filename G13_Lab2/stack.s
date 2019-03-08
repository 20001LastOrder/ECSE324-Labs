.text
.global _start

_start:	LDR R0, N

		STR R0, [SP, #-4]!
		STR R0, [SP, #-4]!
		STR R0, [SP, #-4]!
		STR R0, [SP, #-4]!
		LDMIA SP!,{R0,R1,R2}
END:	B END
N:		.word 2
