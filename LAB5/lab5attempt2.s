////////// MACROS //////////
.macro display meg,len
	mov r7, #4				@ System number, #4 for 'write'
	mov r0, #1				@ Specify output is monitor
	ldrb r2, =\len			@ String is len characters long
	ldr r1, =\meg			@ Start printing from the memory address--specified in R1
	swi 0	
.endm

.macro input meg,len

	mov r7, #3				@ System number, #3 for 'read'
	mov r0, #0				@ Specify input is from keyboard
	ldrb r2, =\len			@ String is len characters long
	ldr r1, =\meg			@ Start printing from the memory address--specified in R1
	swi 0	
.endm

.macro setflag flag  		@ Changes a flag from 0 to 1
	ldr r11, =\flag
	ldr r10, =1
	strb r10, [r11]
.endm
////////////////////////////////

.data
	//STATIC VARIABLES
	message1: .ascii "Enter an algebraic command line: "
	message2: .ascii "Operand 1: " 
	message3: .ascii "\nOperand 2: " 
	message4: .ascii "\nOperator:  " 
	message5: .ascii "\nResult:    "  

	errorFormat: .ascii "Error!!\nInput format: Operand1 Operator Operand2\nOperand: decimal numbers\nOperators: - * / %\n" 
	errorRange: .ascii "Error!! Enter operand values between -128 and 127\n"  
	newLine: .ascii "\n" 
	negative: .ascii "-"
	
	//DYNAMIC VARIABLES
	flag1: .byte 0
	flag2: .byte 0 
	flag3: .byte 0

	input: .space 20 

	operand1_A: .space 3 
	operator: .space 1 
	operand2_A: .space 3 
	result_A: .space 10 
	
	operand1_H: .byte 0 
	operand2_H: .byte 0 
	result_H: .word 0 
	neg_result: .byte 0 
	
.text
.global main
//////////// CONVERSION FUNCTIONS //////////
// ===== ASCII to HEX conversion ===== // 
// r1 - address of an operand1_A
// r2 - address of an operand1_H

A_to_H:
    push    {r4, lr} 
    mov r8, #0				@ Will hold the 10^x place
    mov r5, #10
			
loop:                		  
	ldrb r0, [r1], #1       @ r0 index holds an ascii character value     
	cmp r0, #0    			@ Checking if the character value is null
	beq finished 
			
    sub r0, r0, #0x30 		@ Subtracting from the ascii character to get the decimal value of the index
    mov r4, r8 				@ Tells the immediate power of the number
    mul r8, r4, r5			@ Multiplies to the correct 10^x power
    add r8, r8, r0 			@ Adds all the numbers up to get the final result
    b loop
    
finished:
	strb r8, [r2]			@ Store the result into operand1_H
    pop {r4, lr}
    bx  lr
        
        
        
// ===== HEX to ASCII conversion ===== 
// r0 - address of a hex value variable
// r1 - addrees of a ASCII value variable

H_to_A:
	push    {r1, r2, r3, r5, r6, r7, r8, r9, lr}
	ldr	r8, [r0]
	mov		r9,	r1
		
    @ Initialization for hex to ascii
    mov     r1, r8      	@ dividend
    mov     r2, #10     	@ divisor
    mov     r5, #0      	@ counter

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
//========================================//


main:
	display message1, 33 	@ Displaying input prompt and obtaining user input
    input input, 20  

    ldr r0, =input			@ Loading variable addresses
    ldr r1, =operand1_A
    ldr r2, =operand2_A 
    ldr r3, =operator 
		
operand1:  				@ Gets the operand1_A
    ldrb r4, [r0]    	@ Loads the first char of string into r4 
    add r0, r0, #1    	@ Changes pointer by 1
    cmp r4, #'-'    	@ Checks to see if the char index is a '-'
    beq    sflag1 		@ If char is '-' sets the negative op1 flag to true
 
    cmp r4, #0x20    	@ Checks to see if the char index is a ' '. If so then next step.
    beq    getOperator

    cmp r4, #0x30    	@ Checks to see if the char index is a number lower bounds
    blt    errorMsg1

    cmp    r4, #0x39    @ Checks to see if the char index is a number upper bounds
    bgt    errorMsg1
    
    strb r4, [r1]    	@ Stores the characters into the operand1_A variable
    add r1, r1, #1 		@ Increments byte location for operand1_A variable
    b operand1 

getOperator:    		@ Gets the operator
    ldrb r4, [r0]     	
    cmp r4, #'+'		@ Checks +
    beq setOp 
    	
    cmp r4, #'-'		@ Checks -
    beq setOp 

    cmp r4, #'/' 		@ Checks /
    beq setOp 

    cmp r4, #'*' 		@ Checks *
    beq setOp 

    b errorMsg1 

setOp:    				@ Stores r4 into operator location r3
    strb r4, [r3] 
    add r0, r0, #2		@ Skips the space and goes to look at the next number 

operand2:     			@ Gets the operand2_A (almost the same steps as operand1_A)
    ldrb r4, [r0]
    add r0, r0, #1
    cmp r4, #0x2D
    beq sflag2 

    cmp r4, #0xA    	@ Once reaches end of function then it converts operand1_A and operand2_A to hex values 
    beq toHex 

    cmp r4, #0x30
    beq errorMsg1 

    cmp r4, #0x39 
    bgt    errorMsg1 

    strb r4, [r2]
    add r2, r2, #1 
    b operand2

toHex:        				@ Converts ascii to hex 
    ldr r1, =operand1_A
    ldr r2, =operand1_H
    ldr r3, =flag1       	@ So it knows if operand1_A is negative
    bl A_to_H 
    mov r10, r8         	@ Stores total number in r10
    
    ldr r1, =operand2_A 
    ldr r2, =operand2_H
    ldr r3, =flag2       	@ So it knows if operand2_A is negative  
    bl A_to_H
    mov r9, r8         		@ Stores total number in r9
	
    b checkSize 
    
logicOp1:					@ Performs logic on operand1 (stored in r8) to check if negative
	ldr r2, =flag1 
    ldrb r8, [r2] 
    cmp r8, #1
    bne logicOp2
    
    mvn r10,r10		 		@ Op1 is negative then twos complement
    add r10, r10,#1
    
logicOp2:  
	ldr r6, =flag2			@ Same concept as logicOp1 but for operand2
	ldrb r8, [r6] 
	cmp r8, #1
    bne arithmetic
    
    mvn r9, r9
    add r9, r9, #1
	
arithmetic:    
	ldr r3, =operator      	@ Loads address of operator  
    ldrb r3, [r3]        	@ Loads value of operator into operator
    cmp r3, #'+'        	@ Checks for +   
    beq add 
   
    cmp r3, #'-'        	@ Checks for - 
    beq subtract 

    cmp r3, #'*'        	@ Checks for *
    beq multiply 

    cmp r3, #'/'        	@ Checks for /
    beq divide

add: 
    add r12, r10, r9    
    cmp r12, #0				@ Checks if answer is negative if not -> store results
    bgt add2				
    setflag flag3        	@ If the result is negative set neg flag to 1
    mvn r12,r12				@ 2's comp
    add r12, r12, #1
    
add2:    
    ldr r0, =result_H 		@ Putting the hex calculations back into ascii form again
    strb r12, [r0] 
    ldr r1, =result_A 
    bl H_to_A 
    
    b copys

subtract: 
    subs r12, r10, r9 		@ Same concept as addition
    cmp r12, #0
    bgt subtract2
    setflag flag3
    mvn r12,r12
    add r12, r12, #1 
    
subtract2:
    ldr r0, =result_H 
    strb r12, [r0] 
    ldr r1, =result_A 
    bl H_to_A
	
	b copys
  
multiply: 					@ Same concept as addition
    mul r12, r10, r9  
    cmp r12, #0
    bgt multiply2
    setflag flag3
    mvn r12,r12
    add r12, r12, #1
    
multiply2:
    ldr r0, =result_H 
    str r12, [r0] 
    ldr r1, =result_A 
    bl H_to_A

    b copys
  
divide: 					@ Same concept as additon (only keeps the remainder)
    sdiv r12, r10, r9 
    cmp r12, #0
    bgt divide2
    setflag flag3
    mvn r12,r12
    add r12, r12, #1
    
divide2: 
    ldr r0, =result_H 
    strb r12, [r0] 
    ldr r1, =result_A
    bl H_to_A
     
copys: 						@ Makes a negative copy of the result
    ldr r0, =neg_result
    mvn r1, r1				@ Making result (store in r1) negative with twos complement
    add r1, r1, #1
    strb r1, [r0]
    ldr r0, =neg_result		@ Now we have both the negative and positive results 
    ldr r1, =result_A

    add r3, r3, #1 			@ Adding 1 to r3
    b op1NegCheck     
   
checkSize: 
    cmp r9, #127			@ Self explainatory error checking
    bgt sizeError 
                     
    cmp r9, #-128
    blt sizeError 
    
    cmp r10, #127
    bgt sizeError 
                     
    cmp r10, #-128
    blt sizeError 
             
    b logicOp1 
  
sizeError: 
    display errorRange, 49    	@ Displays out of range error
    display newLine, 1
    b exit
     
sflag1:
    setflag flag1        		@ Operand1's negative flag
    b operand1 
       
sflag2: 
    setflag flag2        		@ Operand2's negative flag
    b operand2 
 
errorMsg1: 
    display errorFormat, 93     @ Occurs if there is a formatting error
    b exit

op1NegCheck: 					@ Checks if operand1 is negative and prints the correct result respectively
    display message2, 11     
    ldr r2, =flag1 
    ldrb r8, [r2] 
    cmp r8, #1 
    beq op1NegPrint 

    b printOp1 					@ If it isn't it just prints the regular one

op1NegPrint: 					@ Only adds a - infront of number
    display negative, 1
    b printOp1
        
printOp1: 						@ Prints out operand1
    display operand1_A, 3 
    b disOperator     

disOperator: 					@ Displays the operator
    display message4, 12 
    display operator, 1 
    b op2NegCheck

op2NegCheck:     				@ Same concept as the first go around
    ldr r6, =flag2 
    ldrb r8, [r6] 
    display message3, 12 
    cmp r8, #1 
    beq op2NegPrint 
        
    b printOp2 

op2NegPrint: 
    display negative,1 
    b printOp2

printOp2:
    display operand2_A, 3 
   
//////// FINALLY SHOWING THE RESULT ////////
display message5, 12 			@ Result message
ldr r10, =flag3
ldrb r10, [r10]
cmp r10, #0
bne insertMinus					@ If answer is negative print a minus
b printResult 					@ Print result
            
insertMinus:            
        display negative, 1 
   
printResult: 
        display result_A, 10
        display newLine,1 

        b exit                              
          
exit: 
		@ exit system call
		mov r7, #1
		swi 0
