.data
    message: .asciiz "Enter a string. "
    userInput: .space 8
.text
    main:
        #Getting using input as text
        li $v0, 8
        la $a0, userInput
        li $a1, 9
        syscall
        
        #
        
        
        
        
        
        
        
        
    #end of main
    li $v0, 10
    syscall