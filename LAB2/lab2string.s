.data
@ Your program
string: .asciz "My name is **!"\n"

.text
.global main

main:

    @ Your program
	ldr r0, =string
	mov r1, S
	mov r2, B
	ldr [r0, #12], = r1
	ldr [r0, #19], = r2
    @ exit syscall
    mov r7, #1
    swi 0
