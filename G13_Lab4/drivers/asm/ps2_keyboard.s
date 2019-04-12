	.text
    .equ PS2_Data, 0xFF200100
    .equ PS2_Control, 0xFF200104
    .equ impulseAt, 0x8000
    .global read_PS2_data_ASM

read_PS2_data_ASM:
    PUSH {R4, R5, R6, R7}
    MOV R1, R0              //save pointer to R1
    MOV R0, #0
    LDR R4, =PS2_Data
    LDR R5, [R4]            //load the data
    LDR R7, =impulseAt
    AND R6, R5, R7            
    AND R4,R5, #0xFF       
    CMP R6, #1
    BLT read_end            //R4 Store the data
    MOV R0, #1
    STRB R4, [R1]

read_end:
    POP {R4, R5, R6, R7}
    BX LR

    .end