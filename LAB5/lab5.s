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
newline: .ascii "\n"

error:		.ascii	"Error!!\nInput format: Operand1 Operator Operand2\nOperand: decimal numbers\nOperators: _ - * / %\n"

test: .ascii "255 / 9 + 1\n"

//other variables
operand1_A:	.space 2
operator:	.space 1
operand2_A: .space 2
operand1_H: .byte 0
operand2_H: .byte 0
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
		mov r0, #0 //if op2 gotten
		mov r8, #0 //if op2 was neg
		mov r4, #10 //holding the 10 value to multiply later
		mov r5, #0 //if operand one is obtained this will be set to one
		mov r6, #0 //This will hold the final op1 value
		mov r7, #0 //This will hold the final op2 value
		mov r12, #0 //If operator taken
		
		//Loaded registers
		ldr r9, =operand1_A
		ldr r10, =operator
		ldr r11, =operand2_A

		output message1, 33
		//ldr r1, =test
		input input, 20
		
		//Loading each char of the input into r3
		loop: ldrb r3, [r1], #1 //post index update
		
		//Throwing error after Op is gotten
		//cmp r8, #1
		//beq throwError
		
		//Catching the null terminator
		cmp r3, #0x0a
		beq end
		
		//PARSING STARTS HERE
		
		//IS NUM
		cmp r3, #0x20 //is space
		beq loop
		
		// Doing each operator
		cmp r3, #0x2A // *
		streq r3, [r10] //Store r3 as operator
		beq loop
		cmp r3, #0x2B // +
		streq r3, [r10]
		beq loop
		cmp r3, #0x2D // -
		streq r3, [r10]
		beq loop
		cmp r3, #0x2F // /
		streq r3, [r10]
		beq loop
		
		// Doing op1_A and op2_A
		cmp r3, #0x30
		blt throwError
		cmp r3, #0x39 //making sure is number
		cmple r5, #1
		blt isNumOp1
		beq isNumOp2
		
		
		//labels
		isNumOp1:
			
			//Getting the two digit number
			mov r5, #1 //Setting the flag that will say that Operator1_A has already been retrieved
			str r3, [r9]
			sub r8, r3, #0x30 //Keeping the tens digit in the first register
			ldrb r3, [r1], #1
			cmp r3, #0x20 //Checking if the next char is a space if so r8 = Operator1_A
			beq loop
			mul r8, r4, r8 //If not then: multiplying r8 by 10
			str r3, [r9, #1] //storing the second because it has been determine to be two numbers
			sub r3, r3, #0x30
			add r6, r8, r3 //adding the next number
			b loop //Loops and stores until any length of digits can be entered followed by a space
			
		isNumOp2:
			str r3, [r11] //storing the first value
			sub r8, r3, #0x30 //Keeping the tens digit in the first register
			@str r8, [r11] //storing the first value
			ldrb r3, [r1], #1
			cmp r3, #0x0a
			beq end
			cmp r3, #0x20 //Checking if the next char is a space if so r8 = Operator1_A
			beq loop
			mul r8, r4, r8 //multiplying r8 by 10
			str r3, [r11, #1] //Storing the second digit
			sub r3, r3, #0x30
			add r7, r8, r3 //r8 has the total number
			b loop //Loops and stores until any length of digits can be entered followed by a space
			
		throwError:
			output error, 95
			b forceEnd
			
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
forceEnd:		mov		r7, #1
				swi 	0
