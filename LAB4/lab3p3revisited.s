.data
fibonacci:  .byte   1, 1, 0, 0, 0, 0, 0, 0, 0, 0

//Main
.text
.global main
main:
        @ Your Program
		ldr r0, =fibonacci
		mov r10, #0 //clearing r10 to store program's final value
		mov r11, #0 //This will be my counting register
		
		loop: 
		ldrb r1, [r0] //pre-index
		ldrb r2, [r0, #1]! //Loading the variables of the fib
		add r3, r1, r2 //adding the variables
		strb r3, [r0, #1]
		add r11, r11, #1
		CMP r11, #8 //this loop will run nine times
		BLE loop
		 
        @ exit syscall
        mov r7, #1
        swi 0 
