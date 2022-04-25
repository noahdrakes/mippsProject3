.data   
    userInput: .space 1002
    newLineCharacter: .asciiz "\n"
    array4characters: .space 1002
    realSubstring: .space 4
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

        sub_a_GET_USERINPUT_ADDRESS_AND_PARSE_STRING:
            #   loads user input address to stack pointer
            lw $t0, 0($sp)
            #   restore 4 bytes to stack pointer
            addi $sp, $sp, 4
            
    

            li $t3, 0               #counter reg

            # allocate 4 bytes for stack pointer 
            addi $sp, $sp, -4
            # load address for the character array
            la $t2, array4characters
            #store that address to the stack pointer
            sb $t2, 0($sp)

            loopParseSubstring:
                # load one character (one byte) to reg $t1
                lb $t1, 0($t0)

                # check to see if current character is semicolon
                #if it is jump to 
                beq $t1, 59, sub_b
                # check for end-line character
                beq $t1, 10, sub_b

                #store character in substring array
                sb $t1, array4characters($t3)

                addi $t3, $t3, 1
                addi $t0, $t0, 1

                

                j loopParseSubstring

        sub_a_PRINT_VALUES:
            invalidInput:
            
            validInput: 


            j loopParseSubstring



    #   remember $t3 stores the amount of values in the current substring
    #   remember $T0 store the base address of the user input




    # converts integers to valid characters
    sub_b:
        # store semi-colon
        sb $t1, array4characters($t3)
        
        #increment to next character in user input and save that value
        addi $t0, $t0, 1

      
        li $t1, 0

        lw $t1, 0($sp)  #loading address of character array from stack pointer


        convert_To_Integers:

            #value for storing single byte
            li $t6, 0

            #increment for removeSpaces and Tabs
            li $t5, 0 
            

            removeSpacesAndTabs:
            beq $t5, 1000, storeRealValues  #check if reached end of input
            lb $t6, 0($t1)      #load single byte from user input into register $t6


            #       checks if there are any spaces

            beq $t6, 11, skip   #if character is line tab -> skip
            beq $t6, 9, skip    #if character is char tab -> skip
            beq $t6, 32, skip   #if character is space    -> skip


            j storeRealValues   #once first real value is detected jump to store real values 

            skip:

            addi $t5, $t5, 1 #increment loop index
            addi $t1, $t1, 1 #increment index for array of user input characters
            j removeSpacesAndTabs


         storeRealValues:  
            li $t4, 0                   #increment for store real values
            #li $t3, 0                   #load address to store array of 4 bytes for the 4 real characters

            loopStoreRealValues:  
                beq $t4, 4, checkRemainingTrailingCharacters        #check if increment is less than 4

                #       if it sees a space, it jumps to trailing characters

                beq $t6, 11, checkRemainingTrailingCharacters   #if character is line tab -> checkRemainingCharacters
            
                beq $t6, 9, checkRemainingTrailingCharacters    #if character is char tab -> checkRemainingCharacters
                beq $t6, 32, checkRemainingTrailingCharacters   #if character is space    -> checkRemainingCharacters

                beq $t6, 59, check4CharactersArray  #if character is semicolon -> end of string
                beq $t6, 10, check4CharactersArray   #if character is new line character character -> end of string, determine if its valid
                beq $t6, 0, check4CharactersArray   #if character is null terminating character -> end of string, determine if its valid
                

                sb $t6, array4characters($t4)                       #store valid characters in new array                   
    
                
                addi $t4, $t4, 1        #increment loop
                addi $t1, $t1, 1        #increment index for array of user input characters
                lb $t6, 0($t1)          #get next character from four bit array
                
                j loopStoreRealValues
            
            checkRemainingTrailingCharacters:
                beq $t5, 1000, check4CharactersArray #loop condition -> once program has reached the 1000th character

                beq $t6, 10, check4CharactersArray   #if character is new line character character -> end of string, determine if its valid
                beq $t6, 0, check4CharactersArray   #if character is null terminating character -> end of string, determine if its valid
                beq $t6, 0, check4CharactersArray   #if character is null terminating character -> end of string, determine if its valid
                beq $t6, 59, check4CharactersArray  #if character is semicolon -> end of string


                beq $t6, 11, skip1   #if character is line tab -> skip
                beq $t6, 9, skip1    #if character is char tab -> skip
                beq $t6, 32, skip1   #if character is space    -> skip

                j invalidInput

            skip1: 
                addi $t1, $t1, 1
                lb $t6, 0($t1)          #get next character from four bit array

                j checkRemainingTrailingCharacters

        invalidInput:
            li $v0, 4       #selecting print function for syscall
            la $a0, invalidInputString  #selecting address of string
            syscall
            j exitProgram
            
            # lb $t0, 0($t1)

        






    exitProgram:
        li $v0, 10
        syscall





        # print register testing , putting at the bottom for 
        # debugging purposes

        # li $v0, 1       #selecting print function for syscall
        # move $a0, $t8   #selecting return register to print out
        # syscall