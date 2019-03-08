			.text
			.global _start
_start:		LDR R0, =N			// R0 points to the memory location of legth
			LDR R1, [R0] 		// R1 stores the length of array
			LDR R0, =NUMBERS	// now R0 points to the first number
			LDR R3, [R0]		// R3 used to store sum
			
LOOP:		SUBS R1, R1, #1
			BLE CENTER			//if we iterate all numbers, then return
			LDR R4, [R0, #4]!   //load the next number to R4 then update
								// memory
			ADD R3, R3, R4      // add R4 to the sum
			B LOOP

CENTER:		LDR R0, =N			// R0 points to the memory location of legth
			LDR R1, [R0]		// R1 stores the length of array
			MOV R4, #1			
			MOV R5, #0
POWER:		CMP R4, R1			// Comare R4 and R1
			BGE UPDATE			// if R4 > R1 then go to update				
			MOV R4, R4, LSL #1  // update R4 by multiplying 2
			ADD R5, R5, #1      // update the power
			B POWER
UPDATE:		MOV R3, R3, ASR R5	// divide the sum by the number of elements using shifting
			LDR R0, =NUMBERS	// now R0 points to the first number
			LDR R4, [R0]		// R4 store the first number

NORM:		SUB R4, R4, R3
			STR R4, [R0]
			SUBS R1, R1, #1 
			BLE DONE
			LDR R4, [R0, #4]!
			B NORM


DONE: 		B DONE

N:			.word	8			//number of entries in the list
NUMBERS:	.word	4, 12,42,54,12,45,2,214
