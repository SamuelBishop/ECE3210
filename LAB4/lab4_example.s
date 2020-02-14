.macro output meg,len

	mov r7, #4				@ System number, #4 for 'write'
	mov r0, #1				@ Specify output is monitor
	ldrb r2, =\len			@ String is len characters long
	ldr r1, =\meg			@ Start printing from the memory address--specified in R1
	swi 0	
.endm


.data

message1: .ascii 	"Please enter a string: "
message2: .ascii 	"You entered: "
input:    .space 	40		@ Declare string buffer with empty space

.text
.global main

main:
        
	@ Print a message asking for string 
	mov r7, #4
	mov r0, #1
	ldr r2, =23
	ldr r1, =message1
	swi 0

	@ Get the string
	mov r7, #3
	mov r0, #0
	mov r2, #40
	ldr r1, =input
	swi 0
	
	@ Print second message
	output message2, 13
	
	@ Print the entered string
	output input, 40

	@ exit syscall
	mov r7, #1
	swi 0 
