 .data
string: .ascii  "tOdAyIsAsUnNyDaY"

.text
.global main
main:
    @The asciis are all hex
    ldr r0, =string
	ldrb r1, = 'T'
	strb r1, [r0]
	ldrb r2, = 'D'
	strb r2, [r0, #2]!
	ldrb r3, = 'Y'
	strb r3, [r0, #2]!
	ldrb r4, = 'S'
	strb r4, [r0, #2]!
	ldrb r5, = 'S'
	strb r5, [r0, #2]!
	ldrb r6, = 'N'
	strb r6, [r0, #2]!
	ldrb r7, = 'Y'
	strb r7, [r0, #2]!
	ldrb r8, = 'A'
	strb r8, [r0, #2]
    @ exit syscall
    swi 0
