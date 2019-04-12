	.text
	.equ BUTTON_DATA, 0xFF200050
	.equ BUTTON_INTERRUPT, 0xFF200058
	.equ BUTTON_EDGE, 0xFF20005C

	//external data
	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM

	//external BUTTON_INTERRUPT
	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM

	//external BUTTON_EDGE
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM

//external data
//no param
read_PB_data_ASM:
	LDR R1, =BUTTON_DATA
	LDR R0, [R1]
	AND R0, R0, #15					//and R0 to only reserve the last 4 bits			
	BX LR
//R0: buttons to be pressed
PB_data_is_pressed_ASM:
	PUSH {LR}
	LDR R1, =BUTTON_DATA
	BL compare
	POP {LR}
	BX LR

enable_PB_INT_ASM:
	LDR R1, =BUTTON_INTERRUPT
	LDR R2, [R1]
	AND R2, R2, #15
	ORR R2, R2, R0					//enable BUTTON_INTERRUPT
	STR R2, [R1]					//Store it back to R1
	BX LR

disable_PB_INT_ASM:
	LDR R1, =BUTTON_INTERRUPT
	LDR R2, [R1]
	AND R2, R2, #15
	BIC R2, R2, R0					//Disable BUTTON_INTERRUPT
	STR R2, [R1]					//Store it back to R1
	BX LR

read_PB_edgecap_ASM:
	LDR R1, =BUTTON_EDGE
	LDR R2, [R1]
	AND R2, R2, #15
	AND R0, R0, R2					//and R0 to only reserve the last 4 bits			
	BX LR

PB_edgecap_is_pressed_ASM:
	PUSH {LR}
	LDR R1, =BUTTON_EDGE
	BL compare
	POP {LR}
	BX LR

PB_clear_edgecap_ASM:
	LDR R1, =BUTTON_EDGE
	STR R0, [R1]					//Store any value will reset the edge value
	BX LR

//R0: Buttons to assign
//R1: address to store the buttons
//R2: number code to assign
compare:
	PUSH {R4, R5}
	MOV R5, R0
	MOV R0, #0
	LDR R4, [R1]
	AND R4, R4, #15					//only keep the last 4 bits
	CMP R5, R4						//compare query and data
	MOVEQ R0, #1					//if they are equal then return true
	POP {R4, R5}
	BX LR
