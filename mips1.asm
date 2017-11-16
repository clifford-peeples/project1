.data
    message: .asciiz "Invalid hexadecimal number."
    userInput: .space 9
    char: .space 2
    newLine: .asciiz "\n"
    null: .asciiz ""
    space: .ascii " "
.text
    main:
        la $a0, userInput
        li $v0, 8
        li $a1, 9
        syscall
        j gets
        
    gets:           #read multiple chars from keyboard buffer until ENTER key
        la $s1, userInput       #set base address of array to s1
        
    loopStart:           #start of read loop
        jal getChar        #jump to getc subroutine
        lb $t0, char        #load the char from char buffer into t0, stripping null
        sb $t0, 0($s1)      #store the char into the nth elem of array
        lb $t1, newLine     #load newline char into t1
        beq $t0, $t1, done  #end of string?  jump to done
        addi $s1, $s1, 1    #increments base address of array
        j loopStart          #jump to start of read loop
        
    getChar:           #read char from keyboard buffer and return ascii value
        li $v0, 8       #call code for read string
        la $a0, char        #load address of char for read
        li $a1, 2       #length of string is 1byte char and 1byte for null
        syscall         #store the char byte from input buffer into char
        jr $ra          #jump-register to calling function
        
    done:           #let s2 be the sum total
        addi $s1, $s1, -1   #reposition array pointer to last char before newline char
        la $s0, userInput       #set base address of array to s0 for use as counter
        addi $s0, $s0, -1   #reposition base array to read leftmost char in string
        add $s2, $zero, $zero   #initialize sum to 0
        li $t0, 10      #set t0 to be 10, used for decimal conversion
        li $t3, 1
        lb $t1, 0($s1)      #load char from array into t1
        blt $t1, 48, invalid  #if less than 48 invalid
        blt $t1, 58, validNum  #if less than 58 valid
        blt $t1, 65, invalid #if less than 65 invalid
        blt $t1, 71, validUpper #if less than 71 valid
        blt $t1, 97, invalid #if less than 97 invalid
        blt $t1, 103, validLow #if less than 103 valid

        
    loopSec:         #loop for all digits preceeding the LSB
        mul $t3, $t3, $t0   #multiply power by 10
        beq $s1, $s0, END   #exit if beginning of string is reached
        lb $t1, ($s1)       #load char from array into t1
        blt $t1, 48, invalid  #if less than 48 invalid
        blt $t1, 58, validNum  #if less than 58 valid
        blt $t1, 65, invalid #if less than 65 invalid
        blt $t1, 71, validUpper #if less than 71 valid
        blt $t1, 97, invalid #if less than 97 invalid
        blt $t1, 103, validLow #if less than 103 valid
        j loopSec            #jump to start of loop

    invalid:          #if non digit chars are entered, readInt returns 0
        add $s2, $zero, $zero
        li $v0, 4
        la $a0, message
        j END
        
    validNum:
        addi $t1, $t1, -48  #converts t1's ascii value to dec value
        mul $t1, $t1, $t3   #t1*10^(counter)
        add $s2, $s2, $t1   #sumtotal=sumtotal+t1
        addi $s1, $s1, -1   #decrement array address
        j loopSec            #jump to start of loop
        
    validUpper:
        addi $t1, $t1, -55  #converts t1's ascii value to dec value
        mul $t1, $t1, $t3   #t1*10^(counter)
        add $s2, $s2, $t1   #sumtotal=sumtotal+t1
        addi $s1, $s1, -1   #decrement array address
        j loopSec            #jump to start of loop
        
    validLow:
        addi $t1, $t1, -93  #converts t1's ascii value to dec value
        mul $t1, $t1, $t3   #t1*10^(counter)
        add $s2, $s2, $t1   #sumtotal=sumtotal+t1
        addi $s1, $s1, -1   #decrement array address
        j loopSec            #jump to start of loop

    END:
        li $v0, 1
        add $a0, $s2, $zero
        syscall
        li $v0, 10
        syscall