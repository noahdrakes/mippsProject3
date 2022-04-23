.data   
    userInput: .space 1002
    newLineCharacter: .asciiz "\n"
    array4characters: .space 4
    invalidInputString: .asciiz "Not recognized"
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


    # sub_a checks for valid # of characters
    sub_a:




        j sub_b


    # converts
    sub_b:



    exitProgram:
        li $v0, 10
        syscall