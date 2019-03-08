	.text
	.equ HEXBASE_0_3, 0xFF200020
	.equ HEXBASE_4_5, 0xFF200030

	.global HEX_clear_ASM
	.global HEX_flood_ASM
	.global HEX_write_ASM
//R0: which HEX display to clear
HEX_clear_ASM:
	PUSH {LR}
	MOV R1, #0
	BL loop_and_assign
	POP {LR}
	BX LR

//R0: which HEX display to show
HEX_flood_ASM:
	PUSH {LR}
	MOV R1, #127			//turn on all 7 lights
	BL loop_and_assign
	POP {LR}
	BX LR

//R0: which HEX display to show
//R1: what number to show
HEX_write_ASM:
	PUSH {R4, LR}
	MOV R4, R0				//Store R1 in R4
	MOV R0, R1				//Store number in R0 for the map
	BL MAP_NUMBER_TO_DISP	
	MOV R1, R0				//Move the DISP code to R1 for next subroutine
	MOV R0, R4				//Resote R0
	BL loop_and_assign
	POP {R4, LR}	
	BX LR


//LOCAL SUB Rtines
//loop through the HEX displays and assign accordingly
//R0: HEX displays assign   R1: display on/off of the 7 segments
loop_and_assign:
	PUSH {R4,R5,R6, R7, R8, LR}	// store register values
	MOV R5, R0				// Move R0 to R5 becase we need to call other subroutines
	MOV R6, #0				//use R6 as a counter and numbering the HEX display
	MOV R7, #1				//R7 uses to peak which HEX display to clear
	MOV R8, R1				//MOV R1 to R8 to holds the number we want to display
assign_loop:
	CMP R6, #6				// there are only 6 displays
	BGE assign_end
	AND R4, R7, R5			//check if the R7-th display needs to be clear
	ADD R6, R6, #1			//add counter
	LSL R7, #1				//shift R7 peak
	CMP R4, #0				//compare R4 with 0 to chech if we need to clear it
	BEQ assign_loop			//if it is 0 means we do not need to be clear
	SUB R6, R6, #1			//Sub R6 to its current place
	MOV R0, R6				//if it is not 0 it means we need to be clear
	ADD R6, R6, #1
	BL MAP_NUMBER_TO_BASE_ADDRESS
	SUB R2, R6, #1			//get the id of the hex-display again
	MOV R1, R8
	BL assign   			//branch to assign to the HEX
	B assign_loop
assign_end:
	POP {R4,R5,R6, R7, R8, LR}
	BX LR




//Map number to the LED address
MAP_NUMBER_TO_BASE_ADDRESS:
	PUSH {R4}				
	CMP R0, #3				
	BLE BASE_LOW         //if the param is smaller then 3 then use BASE_0_3   
	LDR R4, =HEXBASE_4_5
	B MAP
BASE_LOW:
	LDR R4, =HEXBASE_0_3
MAP:
	MOV R0, R4
	POP {R4}
	BX LR

MAP_NUMBER_TO_DISP:
	MOV R1, R0			//move display code base on the number value 
	CMP R1, #0
	MOVEQ R0, #63
	CMP R1, #1			//1
	MOVEQ R0, #6
	CMP R1, #2			//2
	MOVEQ R0, #91
	CMP R1, #3			//3
	MOVEQ R0, #79
	CMP R1, #4			//4
	MOVEQ R0, #102
	CMP R1, #5			//5
	MOVEQ R0, #109
	CMP R1, #6			//6
	MOVEQ R0, #125
	CMP R1, #7			//7
	MOVEQ R0, #7
	CMP R1, #8			//8
	MOVEQ R0, #127
	CMP R1, #9			//9
	MOVEQ R0, #111
	CMP R1, #10			//A
	MOVEQ R0, #119
	CMP R1, #11			//B
	MOVEQ R0, #124
	CMP R1, #12			//C
	MOVEQ R0, #57
	CMP R1, #13			//D
	MOVEQ R0, #94
	CMP R1, #14			//E
	MOVEQ R0, #113
	CMP R1, #15			//F
	MOVEQ R0, #121
	BX LR

//assgin value to the HEX display address (R0) based on the param (R1)
assign:
	PUSH {R4, R5}
	CMP R2, #3	
	SUBGT R2, R2, #4			//if R2 is >= 4, sub it by 4
	LDR R3, [R0]				//R0 holds the display base address
	MOV R4, #0
	MOV R5, #127				//use this to get the value just for this id
assign_shift:
	CMP R4, R2
	BGE assign_start
	LSL R1, #8					//shift 1 byte
	LSL R5, #8
	ADD R4, R4, #1
	B assign_shift
assign_start:
	BIC R3, R3, R5
	ADD R1, R3, R1
	STR R1, [R0]
	POP {R4, R5}
	BX LR
