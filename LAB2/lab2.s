.data
@var:	.length	info
num1:	.byte	11
num2:	.byte	0x0d
result:	.byte	0

@ Your program

.text
.global main

main:

    @ Your program
	mov r4, #0x3AB
	mov r5, #0b1101
	mov r6, #25
	ldr r7, =num1
	ldr r8, =num2
	ldrb r9, [r7]
	ldrb r10, [r8]
	add r11, r9, r10

	@ In order to store the r11 register into variable result we need to store the address of the variable into the register then
	@ use that to change the value
	ldr r12, =result
	strb r12, [r11]
    @ exit syscall
    swi 0
