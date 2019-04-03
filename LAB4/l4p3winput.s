.macro output meg,len
	mov r7, #4	@ System number, #4 for 'write'
	mov r0, #1	@ Specify output is monitor
	ldrb r2, =\len	@ String is len characters long
	ldr r1, =\meg	@ Start printing from the memory address--specified in R1
	swi 0
.endm

.macro input string, len
	mov r7, #3	@ System number, #3 for 'read'
	mov r0, #0	@ stdin is keyboard
	ldrb r2, =\len	@ String is len characters long
	ldr r1, =\string	@ started storing from the address specified in R1
	swi 0
.endm

.macro INC_COUNT charscount
	ldr r5, =\charscount //address of count
	ldrb r8, [r5] //value of count
	add r8, r8, #1 //incrementing by 1
	str r8, [r5] //getting the value
.endm

.data
message1: .ascii "Please enter a string: "
message2: .ascii "You entered: "
message3: .ascii "There are "
message4: .ascii " numbers in this string.\n"
message5: .ascii " capital letters in this string.\n"
message6: .ascii " lower case letters in this string.\n"
message7: .ascii " other characters in this string.\n"
message8: .ascii " total characters in this string.\n"
prompt:    	.space 40	@ Declare string buffer with empty space
COUNT_DIGIT: .byte 0
COUNT_CAP: .byte 0
COUNT_SMALL: .byte 0
COUNT_OTHER: .byte 0
COUNT_TOTALCHARS: .byte 0

.text
.global main

main:
	//Initializing counters
	mov r8, #0 //COUNT register
	mov r9, #0 //NUM counter
	mov r10, #0 //CAP counter
	mov r11, #0 //LOWER counter
	mov r12, #0 //OTHER counter
	
	output message1, 23
	input prompt, 40
	output message2, 13
	output prompt, 40
	
	loop: ldrb r3, [r1], #1
	cmp r3, #0x20
	beq loop
	
	//Catching the null terminator
	cmp r3, #0x00
	beq end2
	
	//IS NUM
	cmp r3, #0x30
	blt addOth
	cmp r3, #0x39
	ble addNum
	
	//IS CAP
	cmp r3, #0x41
	blt addOth
	cmp r3, #0x5A
	ble addCap
	
	//IS LOWER
	cmp r3, #0x61
	blt addOth
	cmp r3, #0x7A
	ble addLow
	
	//IS OTHER >#0x7A
	cmp r3, #0x7A
	bgt addOth
	
	//All Labels
	addNum: add r9, r9, #1
			INC_COUNT COUNT_TOTALCHARS
			b end1
	addCap: add r10, r10, #1
			INC_COUNT COUNT_TOTALCHARS
			b end1
	addLow: add r11, r11, #1
			INC_COUNT COUNT_TOTALCHARS
			b end1
	addOth: add r12, r12, #1
			INC_COUNT COUNT_TOTALCHARS
			b end1
	end1: b loop
	end2: 
	
		  ldr r1, =COUNT_DIGIT
		  add r9, r9, #48
		  str r9, [r1]
	
		  ldr r2, =COUNT_CAP
		  add r10, r10, #48
		  str r10, [r2]
	
		  ldr r3, =COUNT_SMALL
		  add r11, r11, #48
		  str r11, [r3]
	
		  ldr r4, =COUNT_OTHER
		  add r12, r12, #47
		  str r12, [r4]
	
		  //Tells the nums
		  output message3, 10
		  output COUNT_DIGIT, 1
		  output message4, 25
		  
		  //Tells the capital
		  output message3, 10
		  output COUNT_CAP, 1
		  output message5, 33
		  
		  //Tells the lower
		  output message3, 10
		  output COUNT_SMALL, 1
		  output message6, 36
		  
		  //Tells the other
		  output message3, 10
		  output COUNT_OTHER, 1
		  output message7, 34
		  
		  //Tells the total characters
		  output message3, 10
		  output COUNT_TOTALCHARS, 1
		  output message8, 34
		  
		  mov r7, #1 //exits program
		  swi 0
