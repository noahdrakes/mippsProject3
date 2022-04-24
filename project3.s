.data   
    userInput: .space 1002
    newLineCharacter: .asciiz "\n"
    array4characters: .space 1002
    invalidInputString: .asciiz "-"
.text

main:

#   $s0 = M
#   $s1 = N
#   $a3 = characters from user input
#   #t6 = new register for update user input without unnecessary spaces


    
    li $t8, 12345678 #loading bison id
    li $t9, 11 #divisor

    div $t8, $t9 #calulcation
    mfhi $t0 # n value 

    addi $s0, $t0, 26 #N is in $s0 add 26 to modulus
    addi $s1, $s0, -10 #M is in $s1

    li $v0, 8               #get input from user
    la $a0, userInput       #read 1000 characters
    li $a1, 1001             #set amount of characters (bytes)
    syscall                 #execute previous instruction

    #   allocate 4 bytes for stack pointer
    addi $sp, $sp, -4
    #   store user input string to address 0 of stack pointer
    sw $a0, 0($sp)



    # sub_a checks for valid # of characters
    sub_a:

        #   loads user input address to stack pointer
        lw $t0, 0($sp)
        #   restore 4 bytes to stack pointer
        addi $sp, $sp, 4
        
        lb $t8, 0($t0)

        

        #   loop to process entire string
        li $t1, 0
        loop:
            beq $t1, $zero, exitProgram
            

            #                                   #
            #           PARSE STRING            #
            #                                   #
            loop1:
                lb $t2, 0($t0)
                beq $t2, 59, loop


            j loop1 
            

            j sub_b


            

        addi $t1, $t1, 1
        j loop

    # converts integers to valid characters
        sub_b:

    exitProgram:
        li $v0, 10
        syscall





        # print register testing , putting at the bottom for 
        # debugging purposes
        