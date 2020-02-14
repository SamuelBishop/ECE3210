//Variables
.data
array:  .byte   0, 2, 4, 6, 8, -1, -3, -5, -7

//Main
.text
.global main
main:



	//////////////////////
    @ Register Immediate
    mov r4, #0 //count
	ldr r0, =array
	
	loop1: ldrsb r1, [r0] //loads the address of r0 int array into r1
	add r10, r1, r10 //adds r1 to r10
	add r4, r4, #1
	add r0, r0, #1 //updates the memory address of r0
	CMP r4, #8 //this loop will run eight times
	BLE loop1
	//////////////////////
	
	
	
	//////////////////////
	@ Register Offset
	mov r4, #0 //This will be my increment register
	ldr r0, =array //r0 is now the address of where the array is stored in memory

	loop2:	ldrsb r3, [r0, r4]
	add r11, r3, r11 //adds stored number to r11 continually
	add r4, r4, #1 //increments the count
	CMP r4, #8 //this loop will run eight times
	BLE loop2
	//////////////////////
	
	
	
	//////////////////////
	@ Immediate Pre-Indexed
	mov r4, #0 //count
	mov r12, #0 //setting the r12 register to 0
	ldr r0, =array
	ldrsb r3, [r0] //loading the first element
	add r12, r3, r12 //adding the first element
	
	loop3: ldrsb r3, [r0, #1]!
	add r12, r3, r12
	add r4, r4, #1
	CMP r4, #7 //this loop will run 7 times
	BLE loop3
	///////////////////////
	
	
	
    @ exit syscall
    mov r7, #1
    swi 0
