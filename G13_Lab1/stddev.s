			.text
			.global _start
_start:
			LDR R4, =RESULT		//R4 points to the result localtion
			LDR R2, [R4, #4] 	//R2 holds the number of elements in the list
			ADD R3, R4, #8		//R3 points to the first number
			LDR R0, [R3]		//R0 holds the first number in the list (Maximum)
			LDR R1, [R3]		//R1 holds the first number in the list (Minimum)

LOOP:		SUBS R2, R2, #1		// decrement the loop counter
			BEQ	DONE			// end loop if counter has reached 0
			LDR R5, [R3, #4]!	// R1 holds the next number in the list
			CMP R0, R5			// Check if maximum is smaller than current number
			BGE NOT_BIG			// If no, branch back to the top
			MOV R0, R5			// if yes, update curent max in R0
NOT_BIG:	
			CMP R1, R5			// compare if the current number is smaller than R1
			BLE NOT_LESS 		// if R1 < R5 then do nothing
			MOV R1, R5			// else update R1
NOT_LESS:	
			B LOOP				// branck back to the top

DONE:		SUB R6, R0, R1		// find the difference between max and min
			Mov R6, R6, ASR #2  // shift right 2 bits to divide 4
			STR R6, [R4];

END:		B END		

RESULT:		.word	0			//memory assigned for result location
N:			.word	7			//number of entries in the list
NUMBERS:	.word	4, 5, 6, 6, 1, 8, 100
