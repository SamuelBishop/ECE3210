.data
array:   .byte -1, 5, 3, 8, 10, 23, 6, 5, 2, -10
size:    .byte 10

.text
.global main

main:

	mov r0, #0 //this is going to be my max register
	mov r1, #0 //this is the count for the array
	ldr r2, =array //loading array's address ingto r1
	
	loop: ldrsb r3, [r2, r1]
	add r1, r1, #1 //adding 1 to r1
	
	cmp r3, r0
	movgt r0, r3
	
	cmp r1, #10
	blt loop
	bgt end
	
	//label
	end: swi 0
