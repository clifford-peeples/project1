.data
    message: .asciiz "Enter a string. "
    userInput: .space 9
.text
    main:
      j readChar
        gets:           #read multiple chars from keyboard buffer until ENTER key, add NULL char and store into buffer pointed to by *array passed to the subroutine
            la $s1, array       #set base address of array to s1
        
    readInt:        #read string of ascii digits, store into a local variable, convert into integer, return that int
        j gets          #let s1 be top address of array, let s0 be the digitcounter
        
    gets:           #read multiple chars from keyboard buffer until ENTER key
        la $s1, array       #set base address of array to s1
        
        
        
        
        
        
        
    #end of main
    li $v0, 10
    syscall