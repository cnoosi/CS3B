.global _start

.data
// CONSTANTS
.equ INBUFSIZE, 12
.equ MIN, 0
.equ MAX, 100
// VARIABLES
// Output in the header
author:     .asciz "Codey Huntting"
date:       .asciz "03/05/2019"
program:    .asciz "Lab 8 - Grade"
// String integer input by user
strInput: .skip INBUFSIZE
// String integer input by user converted to an integer
intInput: .word 0
// Prompt for user input
inPrompt: .asciz "Enter number grade (0 - 100): "
// Endline ascii code
endl: .byte 10
// Message given if value is not an int
invalidValMsg:      .asciz "***ERROR*** invalid value\n"
// Message given if value is outside of valid range
invalidRangeMsg:    .asciz "***ERROR*** number outside of valid range\n"
// Prompt before printing the letter grade
resultReport:       .asciz "Letter Grade is: "
// Message output when the program termintates
goodbyeMsg:  	    .asciz "Lab 8.1 Complete!\n"
// Stores the letter grade
.balign 4
letterGrade:	    .byte 0

.balign 4
.text
_start:
    // Output a header with the data about this program
    ldr r0, =author
    ldr r1, =date
    ldr r2, =program
    bl OutputHeader
    _loopbody:
        // Prompt user for input
        ldr r1, =inPrompt
        bl putstring
        // Store user input into a string
        ldr r1, =strInput
        mov r2, #INBUFSIZE
        bl getstring
        // Try to convert the string to an integer
        ldr r1, =strInput
        bl ascint32
        // If integer input is negative, exit the loop
        cmp r0, #0
        blt _end
        // "Clear" the cpsr with simple move instruction
        movs r1, #1
        // If "carry" is set and r0 is 0, the string could not be converted to an integer
        cmpcs r0, #0
        beq _inputinvalid 
        _inputvalid:
            // Check to see if integer input is within range of min-max
            mov r1, r0
            mov r2, #MIN
            mov r3, #MAX
            bl InRange
            // Check contents of r0 to see if int value is in range
            cmp r0, #0
            bne _inputinrange
            beq _inputoutrange
        _inputinvalid:
            // Output invalid value message
            ldr r1, =invalidValMsg
            bl putstring
            bal _loopend
        _inputinrange:
            // Get the letter grade if input is out of range    
            bl GetGrade
            // Store letter grade in r4 for safekeeping
            ldr r1, =letterGrade
            str r0, [r1]
            // Title string for reporting result
            ldr r1, =resultReport
            bl putstring
            // Put grade character currently stored by r0
            ldr r1, =letterGrade
            bl putch
            // Put an endline
            ldr r1, =endl
            bl putch
            bal _loopend
        _inputoutrange:
            // Output appropriate error message if input is out of range
            ldr r1, =invalidRangeMsg
            bl putstring
            bal _loopend
    _loopend:
        // Put an endline and loop again
        ldr r1, =endl
        bl putch
        bal _loopbody
    _end:
	// Output goodbye message
	ldr r1, =goodbyeMsg
	bl putstring
        // Linux syscall to terminate the program
        mov r0, #0
        mov r7, #1
        swi 0
        .end

