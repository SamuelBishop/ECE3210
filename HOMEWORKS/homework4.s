.data

.text
.global main

main:
ldr r1, =0x1A2B3C4D
rev r0, r1
swi 0
