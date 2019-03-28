.data
fibonacci:  .byte   1, 1, 0, 0, 0, 0, 0, 0, 0, 0

.text
.global main
main:
        @ Your Program
		ldr r0, =fibonacci
		ldrb r1, [r0] //pre-index
		ldrb r2, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r3, r1, r2 //adding 1 & 1
		strb r3, [r0, #1] 
		
		ldrb r2, [r0] //pre-index update
		ldrb r3, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r4, r2, r3 //adding 2 & 1
		strb r4, [r0, #1]
		
		ldrb r3, [r0] //pre-index update
		ldrb r4, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r5, r3, r4 //adding 3 & 2
		strb r5, [r0, #1]
		
		ldrb r4, [r0] //pre-index update
		ldrb r5, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r6, r4, r5 //adding 5 & 3
		strb r6, [r0, #1]
		
		ldrb r5, [r0] //pre-index update
		ldrb r6, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r7, r5, r6 //adding 8 & 5
		strb r7, [r0, #1]
		
		ldrb r6, [r0] //pre-index update
		ldrb r7, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r8, r6, r7 //adding 13 & 8
		strb r8, [r0, #1]
		
		ldrb r7, [r0] //pre-index update
		ldrb r8, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r9, r7, r8 //adding 21 & 13
		strb r9, [r0, #1]
		
		ldrb r8, [r0] //pre-index update
		ldrb r9, [r0, #1]! //Now both r1 and r3 have 1 and 1 in them
		add r10, r8, r9 //adding 34 & 21
		strb r10, [r0, #1]
		
        @ exit syscall
        swi 0 
