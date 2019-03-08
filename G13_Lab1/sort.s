			.text
			.global _start
_start:
			MOV R1, #1			// record how many times we have gone through the array + 1 since we do not need to check the last element
			MOV R6, #0			// use R6 to sotre if the array has been sorted

SORT:       CMP R6, #0
			BGT DONE 
			LDR R0, =NUMBERS
			LDR R2, SIZE		// R2 contains the size of the array
			SUB R2, R1			// every time we go through the array, we have the last element to be the largest element so next time we do not need to go there
			MOV R6, #1			// set is sorted to true

LOOP:		LDR R3, [R0]		// R3 contains the i-th element
			LDR R4, [R0, #4]!	// R4 contains the i+1-th element
			CMP R3, R4			//compare R3 and R4
			BLE NOTHING			// if R3 <= R4, do nothing
			//else switch R3 and R4 and set R6 to false
			STR R4, [R0, #-4]	//	Store R3 to the element in i-th element
			STR R3, [R0]		//	Store R4 to i+1 th element
			MOV R6, #0
NOTHING:	SUBS R2, #1
			BEQ SORT
			B LOOP

DONE: 		B DONE

SIZE:		.word	16
NUMBERS:	.word	232,1,4,125564,2377,22,-11,-346,244,4,33,11,35454,-56643,456,56