			.text
			.global MAX

MAX:		PUSH {LR, R4, R5}
			LDR R4, [R1]		//R4 holds the first number in the list
LOOP:		SUBS R0, R0, #1		// decrement the loop counter
			BEQ	RETURN			// end loop if counter has reached 0
			ADD R1, R1, #4		// R1 points to next number in the list
			LDR R5, [R1]		// R5 holds the next number in the list
			CMP R4, R5			// Check if it is greater than the maximum
			BGE LOOP			// If no, branch back to the top
			MOV R4, R5			// if yes, update curent max in R4
			B LOOP				// branck back to the top
RETURN:		MOV R0, R4
			POP {LR, R4, R5}
			BX LR

