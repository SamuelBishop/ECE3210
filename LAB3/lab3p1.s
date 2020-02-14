.data
array:  .byte   0, 2, 4, 6, 8, -1, -3, -5, -7

.text
.global main
main:
        @ Register Immediate
	ldr r0, =array
	
	ldrb r1, [r0]
	add r0, r0, #1
	
	ldrb r2, [r0]
	add r0, r0, #1
	
	ldrb r3, [r0]
	add r0, r0, #1
	
	ldrb r4, [r0]
	add r0, r0, #1
	
	ldrb r5, [r0]
	add r0, r0, #1
	
	ldrb r6, [r0]
	add r0, r0, #1
	
	ldrb r7, [r0]
	add r0, r0, #1
	
	ldrb r8, [r0]
	add r0, r0, #1
	
	ldrb r9, [r0]
	add r0, r0, #1
	
	add r10, r1, r2
	add r10, r3, r10
	add r10, r4, r10
	add r10, r5, r10
	add r10, r6, r10
	add r10, r7, r10
	add r10, r8, r10
	add r10, r9, r10
	
	
	@ Register Offset
	ldr r0, =array //r0 is now the address of where the array is stored in memory

	ldrb r1, [r0] //loads 0
	ldrb r2, [r0, #1] //2
	add r11, r1, r2 //adds r1 and r2 to r11

	ldrb r3, [r0, #2] //4
	add r11, r3, r11 //adds r3 to r11

	ldrb r4, [r0, #3] //6
	add r11, r4, r11 //adds r4 to r11

	ldrb r5, [r0, #4] //8
	add r11, r5, r11 //adds r5 to r11

	ldrb r6, [r0, #5] //-1
	add r11, r6, r11 //adds r6 to r11

	ldrb r7, [r0, #6] //-3
	add r11, r7, r11 //adds r7 to r11

	ldrb r8, [r0, #7] //-5
	add r11, r8, r11 //adds r8 to r11

	ldrb r9, [r0, #8] //-7
	add r11, r9, r11 //adds r9 to r11
	
	@ Immediate Pre-Indexed
	ldr r0, =array @ Need to use ldrsb
	ldrsb r1, [r0]
	ldrsb r2, [r0, #1]!
	ldrsb r3, [r0, #1]!
	ldrsb r4, [r0, #1]!
	ldrsb r5, [r0, #1]!
	ldrsb r6, [r0, #1]!
	ldrsb r7, [r0, #1]!
	ldrsb r8, [r0, #1]!
	ldrsb r9, [r0, #1]!
	add r12, r1, r2
	add r12, r3, r12
	add r12, r4, r12
	add r12, r5, r12
	add r12, r6, r12
	add r12, r7, r12
	add r12, r8, r12
	add r12, r9, r12

        @ exit syscall
        swi 0 
