.global _start

.data
str1:	.asciz "Hello, world!"
str2:	.asciz "How are you, world?!"
str3:	.asciz "I'm good, how are you, Codey?!"
find:	.asciz "Hello"
cCR:	.byte 10

.text
.balign 4
_start:
	// Construct a list
	bl List
	mov r4, r0

	mov r0, r4
	ldr r1, =str1
	bl List_addstr

	mov r0, r4
	ldr r1, =str2
	bl List_addstr

	mov r0, r4
	ldr r1, =str3
	bl List_addstr

	mov r0, r4
	ldr r1, =find
	ldr r2, =String_contains
	ldr r3, =putstring_and_endline
	bl List_foreach_cmp

	mov r0, #0
	mov r7, #1
	svc 0

// r0 =boolean String_contains(r1 str, r2 otherStr)
String_contains:
	push {lr}
	bl String_indexOfString
	
	// Branch 
	cmp r0, #0
	bge scontains__if__index_not_negative
	bal scontains__if__index_negative

	scontains__if__index_not_negative:
		mov r0, #1
		bal scontains__end
	scontains__if__index_negative:
		mov r0, #0
	scontains__end:
		pop {pc}

// (r1 = string)
putstring_and_endline:
	push {lr}
	bl putstring
	ldr r1, =cCR
	bl putch
	pop {pc}
