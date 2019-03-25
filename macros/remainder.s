.global remainder

.data
remainder 	.req r0
divisor		.req r1
dividend	.req r2

/*
r0 remainder(r1 divisor, r2 dividend)
-------------------------------------
Return the unsigned remainder after the integer division r1 / r2
Overflow is set if r2 = 0
-------------------------------------
*/

.text
.balign 4
remainder:
	push {r1-r12, lr}
	// Get the division r1 / r2
	bl idiv
	// Branch straight to the end if overflow is set
	bvs _end
	// Multiply the result of the division by the dividend
	mul remainder, dividend, remainder
	// Subtract the divisor from the remainder
	subs remainder, divisor, remainder  
	// If remainder is negative, force it to be positive
	blt _if__remneg
	bal _end
	_if__remneg:
		sub remainder, #1
		mvn remainder, remainder
	_end:
		// Restore the return address and branch back to it
		pop {r1-r12, pc}
		