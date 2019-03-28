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

.data
message1: .ascii "Please enter a string: "
message2: .ascii "You entered: "
message3: .ascii "There are "
message4: .ascii " numbers in this string.\n"
message5: .ascii " capital letters in this string.\n"
message6: .ascii " lower case letters in this string.\n"
message7: .ascii " other characters in this string.\n"
prompt:    	.space 40	@ Declare string buffer with empty space
numbers: .space 1
cletters: .space 1
lletters: .space 1
others: .space 1

.text
.global main

main:
	//Initializing counters
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
			b end1
	addCap: add r10, r10, #1
			b end1
	addLow: add r11, r11, #1
			b end1
	addOth: add r12, r12, #1
			b end1
	end1: b loop
	end2: 
	
		  ldr r1, =numbers
		  add r9, r9, #48
		  str r9, [r1]
	
		  ldr r2, =cletters
		  add r10, r10, #48
		  str r10, [r2]
	
		  ldr r3, =lletters
		  add r11, r11, #48
		  str r11, [r3]
	
		  ldr r4, =others
		  add r12, r12, #47
		  str r12, [r4]
	
		  //Tells the nums
		  output message3, 10
		  output numbers, 1
		  output message4, 25
		  
		  //Tells the capital
		  output message3, 10
		  output cletters, 1
		  output message5, 33
		  
		  //Tells the lower
		  output message3, 10
		  output lletters, 1
		  output message6, 36
		  
		  //Tells the other
		  output message3, 10
		  output others, 1
		  output message7, 34
		  
		  mov r7, #1 //exits program
		  swi 0
