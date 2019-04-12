	.text
    .equ PIXEL_BASE, 0xC8000000
    .equ CHAR_BASE, 0xC9000000

    .global VGA_clear_charbuff_ASM
    .global VGA_clear_pixelbuff_ASM
    .global VGA_write_char_ASM
    .global VGA_write_byte_ASM
    .global VGA_draw_point_ASM

    .equ CHAR_MAX_X, 79
    .equ CHAR_MAX_Y, 59
    .equ PIXEL_MAX_X, 319
    .equ PIXEL_MAX_Y, 239

BYTE_TABLE:
    .word 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70

VGA_clear_charbuff_ASM:
    PUSH {R4, LR}
    LDR R0, =CHAR_MAX_X 
    LDR R1, =CHAR_MAX_Y 
    LDR R2, =VGA_write_char_ASM     
    BL VGA_clear
    POP {R4, LR}
    BX LR

VGA_clear_pixelbuff_ASM:
    PUSH {R4, LR}
    LDR R0, =PIXEL_MAX_X 
    LDR R1, =PIXEL_MAX_Y
    LDR R2, =VGA_draw_point_ASM
    BL VGA_clear
    POP {R4, LR}
    BX LR

VGA_write_char_ASM:
    //input validation
    CMP R0, #79
    BXGT LR
    CMP R1, #59
    BXGT LR
    PUSH {R3, R4}
    MOV R3, R1          //mov y in
    LSL R3, #7          // shift y to its position
    ADD R3, R3, R0      // add x in
    LDR R4, =CHAR_BASE
    STRB R2, [R4, R3]
    POP {R3, R4}
	BX LR

VGA_write_byte_ASM:
    //input validation
    CMP R0, #78
    BXGT LR
    CMP R1, #59
    BXGT LR
    PUSH {R4, R5, R6, LR}
    LDR R6, =BYTE_TABLE
    LSR R4, R2, #4     //get upper half byte
    AND R5, R2, #15         //get lower half byte
    LSL R4, R4, #2
    LDR R2, [R6, R4]
    BL VGA_write_char_ASM
    LSL R5, R5, #2
    LDR R2, [R6, R5]
    ADD R0, R0, #1
    BL VGA_write_char_ASM
    POP {R4, R5, R6, LR}
    BX LR

VGA_draw_point_ASM:
    //input validation
    PUSH {R3, R4}
    LDR R3, =PIXEL_MAX_X
    CMP R0, R3
    BXGT LR
    LDR R3, =PIXEL_MAX_Y
    CMP R1, R3
    BXGT LR
    MOV R3, R1          //mov y in
    LSL R3, #10          // shift y to its position
    ADD R3, R3, R0, LSL #1      // add x in
    LDR R4, =PIXEL_BASE
    STRH R2, [R4, R3]
    POP {R3, R4}
    BX LR

//helper routine
//param 1: max value for x coor
//param 2: max value for y coor
//param 3: assign subroutine address 
VGA_clear:
    PUSH {R4, R5, R6, R7, R8, LR}
    MOV R4, R0                  //R4 holds the max x for char
    MOV R5, R1                  //R5 holds the max y for char
    MOV R6, #0                  //R6 iterates x
    MOV R7, #0                  //R7 iterates y
    MOV R8, R2                  //R2 holds the subroutine address
clear_char_x:
clear_char_y:
    MOV R0, R6
    MOV R1, R7
    MOV R2, #0
    BLX R8                      // go to clear sub routine
    ADD R7, R7, #1              
    CMP R7, R5                  //cmp y with the max
    BLE clear_char_y            //go back to clear if y smaller then or equal to max
    MOV R7, #0                  //reset y
    ADD R6, R6, #1              //add x iterater by 1
    CMP R6, R4                  //cmp x with the max
    BLE clear_char_x            // goback if x <= max
    POP {R4, R5, R6, R7, R8, LR}
    BX LR


.end
