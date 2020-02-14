.data
string: .asciz "ECE32 10Th!"

.text
.global main

main:
	//Initializing counters
	mov r9, #0 //NUM counter
	mov r10, #0 //CAP counter
	mov r11, #0 //LOWER counter
	mov r12, #0 //OTHER counter
	
	ldr r0, =string //Loading string
	
	loop: ldrb r1, [r0], #1
	cmp r1, #0x20
	beq loop
	
	//Catching the null terminator
	cmp r1, #0x00
	beq end2
	
	//IS NUM
	cmp r1, #0x30
	blt addOth
	cmp r1, #0x39
	ble addNum
	
	//IS CAP
	cmp r1, #0x41
	blt addOth
	cmp r1, #0x5A
	ble addCap
	
	//IS LOWER
	cmp r1, #0x61
	blt addOth
	cmp r1, #0x7A
	ble addLow
	
	//IS OTHER >#0x7A
	cmp r1, #0x7A
	bgt addOth
	
	//All Labels
	addNum: add r9, r9, #1
			b end1
	addCap: add r10, r10, #1
			b end1
	addLow: add r11, r11, #1
			b end1
	addOth: add r12, r12, #1
			b end1
	end1: b loop
	end2: swi 0
