////////// INPUT AND OUTPUT //////////
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
//////////////////////////////////////

.data
//messages
message1:	.ascii	"Enter an algebraic command line: "
message2:	.ascii	"Operand 1: "
message3:	.ascii	"Operand 2: "
message4:	.ascii	"Operator: "
message5:	.ascii	"Result: "

error:		.ascii	"Error!!\nInput format: Operand1 Operator Operand2\nOperand: decimal numbers\nOperators: _ - * / %\n"
newline:	.ascii	"\n"

//other variables
operand1_A:	.space 2
operator:	.space 1
operand2_A: .space 2
result: 	.space 3
input:    	.space 20	@ Declare string buffer with empty space

.text
.global main

//////////// GIVEN FUNCTIONS //////////
// ===== HEX to ASCII conversion ===== 
// r0 - address of a hex value variable
// r1 - addrees of a ASCII value variable
 
hex_to_ascii: //Makes up to 2 digit hex number into up to three digit ascii 
        push    {r1, r2, r3, r5, r6, r7, r8, r9, lr}
		ldrb	r8, [r0]
		mov		r9,	r1
		
        @ Initialization for hex to ascii
        mov     r1, r8      @ dividend
        mov     r2, #10     @ divisor
        mov     r5, #0      @ counter

        @ Start conversion with dividing by 10
next_digit:
		udiv	r3, r1, r2
		mul		r7, r3, r2
		sub		r1, r1, r7

        add     r1, r1, #0x30   @ increment by 0x30 to get the ascii value
        push    {r1}            @ push the converted value into the stack
        add     r5, r5, #1      @ increment the counter
        mov     r1, r3          @ update the dividend
        cmp     r3, #0          @ check whether the conversion is finished
        bne     next_digit 

        @ Store the converted value into memory
        mov     r6, r9	
store_asci:
        pop     {r1}            @ pop each digit from the stack
        strb    r1, [r6]        @ store the digit into memory
        add     r6, r6, #1      @ increment the address
        sub     r5, r5, #1      @ decrement the counter
        cmp     r5, #0
        bne     store_asci

        pop     {r1, r2, r3, r5, r6, r7, r8, r9, lr}
        bx      lr
        
////////// Subroutines ////////////////
Subroutine1:@ Subroutines name
        push    {r4, lr}
        @ the beginning of your Subroutine
        
        @ the end of your Subroutine
        pop     {r4, lr}
        bx      lr
//////////////////////////////////////

main:
		//Initializing registers to use later
		mov r6, #0 //if operand one is obtained this will be set to one
		mov r4, #10 //holding the 10 value for now
		mov r8, #0
		mov r9, #0
		mov r10, #0
		
		//Loaded registers
		ldr r8, =operand1_A
		ldr r9, =operator
		ldr r10, =operand2_A

		output message1, 34
		input input, 20
		
		//Loading each char of the input into r3
		loop: ldrb r3, [r1], #1 //post index update
		
		//Catching the null terminator
		cmp r3, #0x00
		beq end
		
		//Parse here
		
		//IS NUM
		cmp r3, #0x20 //is space
		beq loop
		cmp r3, #0x30
		blt loop //if not a num and not an operator go back to beginning (do something about spaces)
		cmp r3, #0x39
		cmple r6, #1
		blt isNumOp1
		beq isNumOp2
		
		//IS OPERATOR
		cmp r3, #0x2A // *
		streq r3, [r9] //Store r3 as operator
		cmp r3, #0x2B // +
		streq r3, [r9]
		cmp r3, #0x2D // -
		streq r3, [r9]
		cmp r3, #0x2F // /
		streq r3, [r9]
		b loop
		
		//labels
		isNumOp1:
			sub r8, r3, #0x30
			ldrb r3, [r1], #1
			cmp r3, #0x20
			mov r6, #1
			beq loop
			sub r2, r3, #0x30
			mul r8, r4, r8
			add r8, r8, r2
			b isNumOp1
		isNumOp2:
			sub r10, r3, #0x30
			ldrb r3, [r1], #1
			cmp r3, #0x20
			beq loop
			sub r2, r3, #0x30
			mul r10, r4, r10
			add r10, r10, r2
			b isNumOp1
		end: 
			//Tells the Operand1
			output message2, 11
			output operand1_A, 2
			output newline, 1
			
			//Tells the Operand2
			output message3, 11
			output operand2_A, 2
			output newline, 1

			//Tells the Operator
			output message4, 10
			output operator, 1
			output newline, 1
			
			//Tells the Result
			output message5, 8
			output result, 3
			output newline, 1
			
		@ exit system call
		mov		r7, #1
		swi 	0
