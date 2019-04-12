	.text
    .equ COntrol, 0xFF203040
    .equ Fifospace, 0xFF203044
    .equ Leftdata, 0xFF203048
    .equ Rightdata, 0xFF20304C

    .global write_audio_data_ASM

write_audio_data_ASM:
    PUSH {R4, R5, R6}
    MOV R1, R0      //store data to R1
    MOV R0, #0      //default to 0
    LDR R4, =Fifospace
    LDRB R5, [R4, #2]       //get space for the left
    CMP R5, #0
    BLE write_end
    LDRB R5, [R4, #3]       //get space for the right
    CMP R5, #0
    BLE write_end
    LDR R4, =Leftdata
    LDR R5, =Rightdata 
    STR R1, [R4]    //store to left data
    STR R1, [R5]    //store to right data
    MOV R0, #1      //indicate write works
write_end:
    POP {R4, R5, R6}
    BX LR

    .end
