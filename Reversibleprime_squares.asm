#==================================================================
# @author: Phooko M 
# @purpose: reversible prime square program that are not palidome
# @date: October 2022
# @contact: 
#==================================================================

.data
.text
.globl main

main:
    li $s0, 0           #count
    li $s1, 10         #terminate
    li $s2, 1           #reversed
    li $s3, 1           #Pinterger
    li $s4, 0           #squareNum
    li $s5, 0           #reverse_square
    li $s6, 0,          # isperfect
    li $s7, 0           

    #Implement a while loop to run until number of required reversible prime square is met
    While:
        beq $s0, $s1, endWhile
        
        #Reversed number
        addi $a1, $s3, 0
        jal		reverse_func				# jump to reverse_func and save position to $ra
        addi $s2, $v1, 0

        addi $a1, $s3, 0
        jal is_perfect
        addi $s6, $v1, 0

        addi $a1, $s2, 0
        jal is_perfect
        addi $s7, $v1, 0

        bne $s7,$s6, loop
            addi $a1, $s3, 0
            jal square_root
            addi $s4, $v1, 0

            addi $a1, $s2, 0
            jal square_root
            addi $s5, $v1, 0

            addi $a1, $s4,0
            jal is_prime
            addi $k0, $v1, 0

            addi $a1, $s5, 0
            jal is_prime
            addi $k1, $v1, 0

            bne $k0, $k1, loop
                addi $a1, $s3, 0
                jal palindrome_check
                addi $k1, $v1, 0

                bnez $k1, loop
                    li      $v0, 1
                    move    $a0, $s3
                    syscall

                    addi $s0, $s0, 1
        loop:
        addi $s3, $s3, 1
        j while
    endWhile:

    # exit program (return 0)
	li $v0, 10
	syscall

    is_prime:
        addi $t0, $a1, 0
        li $t1, 1
        li $t2, 2           # i == 2

        ble $t0, $t1, not_prime

        for_prime_loop:
            li $t2, 2 # Load immediate (i = 2).
            sle $t3, $t2, $t0
            beqz $t3, is_prime

            div  $t0, $t1 #divide $t0 ny $t1
            mfhi $t4	# (n % i)
            beqz $t4, not_prime

            addi $t2, $t2, 1
            j for_prime_loop

        isPrime:
            li $t6, 1
            addi $v1, $t6, 0
        jr		$ra	

        not_prime:
            li $t6, 0
            addi $v1, $t6, 0
        jr		$ra	


    reverse_func:
        addi $t0, $a1, 0
        rev_func:
            beq $s3, 0, end_rev_func

            div		$t0, $10			# n/10
            mflo	$t2					# n/10 
            mfhi	$t3					# n%10

            mul 	$t0, $t0, 10		# sum = sum*10

            add    $t0, $t0, $t3
            add    $s3, $s3, $t3

            j rev_func
        end_rev_func:
            addi $v1, $t0, 0                #

            jr		$ra					# jump to $ra


    is_perfect:
        addi $t2, $a1, 0
        li $t0, 1
        for_perfect_loop:
            mul $t1, $t0, $t0       

            sle $t3, $t1, $t2
            beqz $t3, not_perfect

            div		$t5, $t1			
            mflo	$t3					
            mfhi	$t4		

            bnez $t4, not_perfect
            bne $t3, $t1, not_perfect		
            
            addi $t0, $t0, 1
            j for_perfect_loop

            isPerfect:

            not_perfect:
                addi $v1, $t0, 0                #
                jr		$ra					# jump to $ra


    square_root:
        addi $t0, $a1, 0        #int x = n;
        li $t1, 2
        li $t2, 0

        div		$t0, $t1			
        mflo	$t3					
        

        for_loop:
            sle $t4, $t2, $t3
            beqz $t4, end_for_loop

            div $t0, $s1
            mflo $t5

            add $s1, $s1, $t5

            div $s1, $t1
            mflo $t6

            addi $s1, $t6, 0

            addi $t2, $t2, 1
            j for_loop

        end_for_loop:
            addi $v1, $s1, 0
        
        jr		$ra					# jump to $ra
    

    palindrome_check:
        addi $t0, $a1, 0 
        addi $t1, $a2, 0 

        bne $t0, $t1, notPalindrome

        li $t2, 1
        addi $a1, $t2, 0
        jr		$ra	

        notPalindrome:
        li $t3, 0
        addi $a1, $t3, 0
        jr		$ra	