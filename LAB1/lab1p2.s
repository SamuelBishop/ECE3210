.data
num1:	.byte	5
num2:	.byte	0b1010
num3:	.byte	0x0c
num4:	.byte	23
num5:	.byte	0b0101101
num6:	.byte	0x4B
msg:   .ascii  "Super!"

.text
.global main
main:

    @ exit syscall
    ldr r1, =num1
    ldr r2, =num2
    ldr r3, =num3
    ldr r4, =num4
    ldr r5, =num5
    ldr r6, =num6
    ldr r7, =msg
    mov r7, #60
    swi 0
