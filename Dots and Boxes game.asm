	
#The code starts from the .text assembler directive
.text
#Declare main as a global function
.globl main
# The label 'main' represents the starting point
main:
	#$s0, $s1, $s2, $s3, $s4 will be used as global variable
	    		
		li		$s0, 0            		#$s0 = pcWin
		li      $s1, 0            		#$s1 = playerWin
		li      $s2, 0            		#$s2 = playerTurn
		li      $s3, 0            		#$s3  = m_w
		li      $s4, 0            		#$s4  = m_z
			
	#$s0, $s1, $s2, $s3 and $s4 have been initialized to zero
		
		jal     intro                   #to show the introduction    
		jal		makeBoard               #goto makeBoard and make the board for the game
		jal     playGame                #in order to start the game
		jal     showBoard               #after the game show the final condition of the board
		jal     result                  #show the score
			
		bge     $s1, 5, playerWon       #if player scores >= 5, he/she wins
		la      $a0, pcWon              #else pc wins and load the label to show that
		j       label                   #go to label

	playerWon:                          # a label
        
        la      $a0, youWon             #Show that player has won

	label:                              # a label
        
        li      $v0, 4                  #in order to show the message in the screen
        syscall                         #Show the message
        
        jal     credits                 #call credits
        
        li      $v0, 10                 #in order to terminate the program 
	    syscall                         #terminate the program
	    
	    #end of main
       	        
	makeBoard:                          #a function
        
        addi    $sp, $sp, -4            #make space in the stack
        sw      $ra,  0($sp)            #store the returning address in the stack
        jal     putInStack              #goto print stack and store all the temporary registers in the stack            
        

        li      $t0, 0        		   #$t0 = i = 0
    
           
	for1_mB:                            #for1_mB = 1st for loop inside makeBoard           
        
        beq     $t0, 4, exit_for1_mB    #if (i == 4) exit this loop
        li      $t1, 0        			#$t1 = j = 0
	
	
	for2_mB:                            #2nd for loop inside makeBoard 
            
        beq     $t1, 7, exit_for2_mB    #if(j == 7) exit this loop
        rem     $t3, $t1, 2             #find j mod 2
        mul     $t4, $t0, 8 			#(i * 8)
        add     $t4, $t4, $t1           #(i * 8) + j
            
        beq     $t3, 0, if1_for2_mB     #if (j % 2) == 0, goto if1_for2_mB
        lb      $t5, space              #else load a space character
        sb      $t5, row($t4)           #row[(i * 8) + j] = ' '

	exit_if1_for2_mB:                   # a label
			        
		lb     	$t5, space              #load a space character
		sb     	$t5, row1($t4)          #row1[(i * 8) + j] = ' '
	    addi    $t1, $t1, 1 		   	#j++           
        j       for2_mB                 #continue this loop
	
	if1_for2_mB:                        # a label
        
        lb      $t5, dot                #load '.'
        sb      $t5, row($t4)           #row[(i * 8) + j] = '.'
        j       exit_if1_for2_mB        #goto exit_if1_for2_mB

	exit_for2_mB:                       # a label
		
		addi    $t0, $t0, 1             #increment i
		j       for1_mB                 #continue the first for loop
	
		
	exit_for1_mB:                       #when the first loop ends
            
        jal     emptyStack              #goto empty stack and restore the values of all temporary registers
        lw      $ra, 0($sp)             #load $ra from stack
        addi    $sp, $sp, 4             #reset stack
        jr      $ra                     #return

    #end of makeBoard, this function has two loops where one is nested in another 
	
	
	showBoard:                          #a function
        
        addi    $sp, $sp, -4            #allocate space in the stack
        sw      $ra,  0($sp)            #store the return address
            
        jal     putInStack              #goto putInStack       
        li      $t0, 0        			#$t0 = i = 0
        lb      $t2, ch       			#$t2 = ch = 'a'
            
        la      $a0,	rowBoard        #load the address of rowBoard
        li      $v0, 4                  #in order to print a string
        syscall                         #this will print "  1 2 3 4\n"
            
	for1_sB:                            #1st for loop in showBoard
        
        beq     $t0, 4, exit_for1_sB    #if(i == 4)exit this loop
        move    $a0, $t2                #move the value of $t2 in $a0 to print
        li      $v0, 11                 #in order to print the character
        syscall                         #print the character
        
        lb      $t3, space 			    #load the character space
        move    $a0, $t3                #in order to print a space
        li      $v0, 11                 #to print a character
        syscall                         #print space
        addi    $t2, $t2, 1
        li      $t1, 0					#$t1 = j = 0
                                         
	for2_sB:                            #nested in for1_sB
        
        beq     $t1, 7, exit_for2_sB    #if(j == 7) exit the loop
        mul     $t3, $t0, 8             #(i * 8)
        add     $t3, $t3, $t1           #(i * 8) + j 
            
        lb      $t4, row($t3)           #load a byte from row[(i * 8) + j]
        move    $a0, $t4                #move the byte
        li      $v0, 11                 #to print a character
        syscall                         #print the character
        
        addi    $t1, $t1, 1				#j++ 
        j       for2_sB                 #continue the loop
            
	exit_for2_sB:                       #exit the nested loop
            
        la      $a0, newLine2           #load "\n "
        li      $v0, 4                  #to print a string
        syscall                         #print "\n "
            
        li      $t1, 0                  # j = 0, will be used in for3_sB
        lb      $a0, space              #load ' '
        li      $v0, 11                 #to print a character
        syscall                         #print the character
            
	for3_sB: 				            #third for loop in showBoard, nested in the first for loop
                        
        beq     $t1, 7, exit_for3_sB    #if(j == 7) exit
        mul     $t3, $t0, 8             #(i * 8)
        add     $t3, $t3, $t1           #(i * 8) + j
            
        lb      $t4, row1($t3)          #load a byte from row1[(i * 8) + j]
        move    $a0, $t4                #move the character
        li      $v0, 11                 #to print the character
        syscall                         #print the character
        
        addi    $t1, $t1, 1 			#j++
        j       for3_sB                 #continue the loop

	exit_for3_sB:                       #exit the third loop

       lb       $a0, newLine            #load '\n'
       li       $v0, 11                 #to print '\n'
       syscall                          #print '\n' on the console
       
       addi     $t0, $t0, 1             #i++
       j        for1_sB                 #continue the 1st for loop
              
	exit_for1_sB:                       #exit the first for loop

       jal      emptyStack              #goto emptyStack
       lw       $ra, 0($sp)             #load $ra from stack
       addi     $sp, $sp, 4             #adjust stack pointer
       jr       $ra                     #return
   
   #this function has three loops, where the second and the third loop in nested in the first one

   doCheck:                            	# a function       	        	        	        	               	        	        	        	        	        doCheck:
       
       addi     $sp, $sp, -4            #allocate space in the stack
       sw       $ra,  0($sp)            #store $ra
            
       jal      putInStack              #goto putInStack
            
       mul      $t0, $a0, 16            #i6 * x
       add      $t0, $t0, $a1           #(16 * x) + y
       
       mul      $t1,  $a1, 16           #16 * y
       add      $t1,  $t1, $a0          #(16 * y) + x
            
       li       $t2, 1                  #initialize
       mul      $t0, $t0, 4             #as words are 4 bytes long
       mul      $t1, $t1, 4             #multiply the index by 4
       sw       $t2, check($t0)         #store in check
       sw       $t2, check($t1)         #store in check  
            
       jal      emptyStack              #goto emptyStack
            
       lw       $ra, 0($sp)             #load return address
       addi     $sp, $sp, 4             #adjust stack pointer
       jr       $ra                     #return          	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	        
       
                 #the above function has two parameters x and y
	
	isBox:                              # a function
       addi     $sp, $sp, -4            #store space in stack
       sw       $ra,  0($sp)            #store return address
           
       jal      putInStack              #goto putInStack
      
       li       $t0, 0 					#i = 0
           
	for1_iB:                   			#1st for loop in isBox
        
       beq       $t0, 16, exit_for1_iB  #if(i == 16) exit this loop
       mul       $t7, $t0, 17           #i * 17
       addi      $t1, $t7, 1            #i * 17 + 1
       addi      $t2, $t7, 4            #i * 17 + 4
       addi      $t3, $t7, 21           #i * 17 + 21
       addi      $t4, $t7, 69           #i * 17 + 69
            
       mul       $t1, $t1, 4            #as words are of 4 bytes
       mul       $t2, $t2, 4            #multiply the index by 4
       mul       $t3, $t3, 4            #same reason as before
       mul       $t4, $t4, 4            #same reason as before
            
       lw        $t1, check($t1)        #load check[(i * 17) + 1]
       lw        $t2, check($t2)        #load check[(i * 17) + 4]
       lw        $t3, check($t3)        #load check[(i * 17) + 21]
       lw        $t4, check($t4)        #load check[(i * 17) + 69]
            
       beq       $t1, 1, if1_iB         #if(check[(i * 17) + 1]) == 1, goto if1_iB
       j         exit_if1_iB            #else goto this label
	
	if1_iB:                             #a label
      
       beq       $t2, 1, if2_iB         #if(check[(i * 17) + 4]) == 1, goto if2_iB
       j         exit_if1_iB            #else goto this label

	if2_iB:                             # a label
       
       beq       $t3, 1, if3_iB         #if(check[(i * 17) + 21]) == 1, goto if3_iB
       j         exit_if1_iB            #else goto this label

	if3_iB:                             # a label
            
       beq       $t4, 1, if4_iB         #if(check[(i * 17) + 69]) == 1, goto if4_iB
       j         exit_if1_iB            #else goto this label

	if4_iB:                             #a label 
       
       mul       $t1, $t0, 2            #i * 2   
       addi      $t1, $t1, 1            #i * 2 + 1
       lb        $t9, row1($t1)         #load row1[(i * 2) + 1]
       lb        $t7, space             #load space
       beq       $t9, $t7, if5_iB       #if(row1[(i * 2) + 1] == ' ')goto if5_iB
       j         exit_if1_iB            #else goto this label

	if5_iB:                             #a label
            
       sb        $a0, row1($t1)         #store the argument in row1[(i * 2) + 1]
       beq       $a0, 'P', if6_iB	    #if ch == 'P', pcWin++      
       addi      $s1, $s1, 1            # else playerWin++
       j         exit_if1_iB            #exit this label

	if6_iB:                             #a label
                                  
       addi      $s0, $s0, 1            #pcWin++

	exit_if1_iB:                        # a label
        
       addi      $t0, $t0, 1  		    #i++
       j         for1_iB                #continue the loop    

	exit_for1_iB:                       # a label
            
       jal       emptyStack             #goto emptyStack
       lw        $ra, 0($sp)            #load return address
       addi      $sp, $sp, 4            #adjust stack pointer
            
       jr        $ra                    #return
       
       #this function checks if after a move a new box has been created or not
       #if it is created then it also assigns points to either player or pc

	max:                                # a function
      
       bgt       $a0, $a1, if1_max      #if($a0 > $a1)                                        
       move      $v0, $a1               #else $a1 is the max
       jr        $ra                    #return

	if1_max:                            #a label
       move      $v0, $a0               #$a0 is the max
       jr        $ra                    #return
             # the above function calculates the max between two arguments
             
	min:
	   blt       $a0, $a1, if1_min      #if($a0 < $a1)
       move      $v0, $a1               #else $a1 is the min
       jr        $ra                    #return

	if1_min:                            #a label
       move      $v0, $a0               #$a0 is the min
       jr        $ra                    #return
       
              # the above function calculates the max between two arguments
  	
  	get_random:                         #a function
       addi      $sp, $sp, -4           #adjust stack pointer
       sw        $ra,  0($sp)           #store the return address
            
       jal       putInStack             #goto putInStack
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
       srl       $t0, $s3, 16           #m_w >> 16
       andi      $t1, $s3, 65535        #m_w & 65535
       mul       $t1, $t1, 18000        #18000 * (m_w & 65535)
       add       $t2, $t1, $t0          #18000 * (m_w & 65535) + (m_w >> 16)
       move      $s3, $t2               #m_w = 18000 * (m_w & 65535) + (m_w >> 16)
        
       srl       $t0, $s4, 16           #m_z >> 16
       andi      $t1, $s4, 65535        #m_z & 65535
       mul       $t1, $t1, 36969        #36969 * (m_z & 65535)
       add       $t3, $t1, $t0          #36969 * (m_z & 65535) + (m_z >> 16)
       move      $s4, $t3               #m_z = 36969 * (m_z & 65535) + (m_z >> 16)
            
       sll       $t3, $t3,  16          #m_z << 16
       addu      $v0,  $t3, $t2         #(m_z << 16) + m_w
     
       jal       emptyStack             #goto emptyStack
            
       lw        $ra, 0($sp)            #load return address
       addi      $sp, $sp, 4            #adjust stack pointer
            
       jr        $ra                   	#return        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	            	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	        

                    #this above function will generate a random number

	checkValid:                          #a function
       addi      $sp, $sp, -4            #adjust stack pointer
       sw        $ra,  0($sp)            #store return address  
            
       jal       putInStack              #goto putInStack
       move      $t0, $a0                #move the argument in the temporary register
       move      $t1, $a1                #move the argument in the temporary register
       sub       $t2, $t1,$t0 			 #dif = $t2 = $t1 - $t0
           
       rem       $t3, $t0,4   			 #rem = $t3 = $t0 % 4 = val1 % 4
       beq       $t3, 3,if1_cV           #if($t3 == 3) goto if1_cV
       j         exit_if1_cV             #else goto this label
    
    if1_cV:                              #a label
       bne       $t2, 4, if2_cV          #if($t2 != 4)goto if2_cV
       j         exit_if1_cV             #else goto this label
      
	if2_cV:                              #a label
       li        $v0, 0                  #to return 0
       jal       emptyStack              #goto emptyStack
            
       lw        $ra, 0($sp)             #load return address
       addi      $sp, $sp, 4             #adjust stack pointer
      
       jr        $ra                     #return
                      
	exit_if1_cV:                         #a label
       mul       $t4, $t0, 16 			 #16 * val1
       add       $t4, $t4, $t1           #16 * val1 + val2
       mul       $t4, $t4, 4             #as words are 4 bytes
       lw        $t4, check($t4)         #load check[(16 * val1 + val2) * 4]
       beq       $t4, 0, if3_cV          #if (check[(16 * val1 + val2) * 4] == 0)goto if3_cV
       j         if2_cV                  #else goto this label
           
	if3_cV:                              #a label
       beq       $t2, 1,if4_cV           #if(dif == 1)
       beq       $t2, 4,if5_cV           #or if(dif == 4)
       j         if2_cV                  #else goto this label
           
	if4_cV:                              #a label, comes here when dif = 1
       move      $a0, $t0                #move it to an argument register
       move      $a1, $t1                #move it to an argument register
       jal       doCheck                 #goto doCheck function
       mul       $t0, $t0, 2             #val1 * 2
       addi      $t0, $t0, 1             #val1 * 2 + 1
       lb        $t6, underscore         #load '_'
       sb        $t6, row($t0)           #row[val1 * 2 + 1] = '_' 
       b         cV_exit                 #goto this label
	
	if5_cV:                              #a label, comes here when dif = 4
       move      $a0, $t0                #move it to an argument register 
       move      $a1, $t1                #move it to an argument register
       jal       doCheck                 #goto doCheck function
       mul       $t0, $t0, 2             #val1 * 2
       lb        $t6, line               #load '|'
       sb        $t6, row1($t0)          #row1[val1 * 2] = '|'
       b         cV_exit                 #goto this label
           
	cV_exit:                             #a label
       jal       emptyStack              #goto emptyStack
            
       lw        $ra, 0($sp)             #load return address
       addi      $sp, $sp, 4             #adjust stack pointer
       li        $v0, 1                  #to return 1
       jr        $ra                     #return
           
         #this function checks whether is input is valid or not and if it is 
                      #valid then puts either '|' or '_' in the board
	
	pc:                                  #a function 
       
       addi      $sp, $sp,-4             #adjust stack pointer
       sw        $ra,  0($sp)            #store return address
            
       jal       putInStack              #goto putInStack

	for1_pc:                             #1st for loop in pc
       
       jal       get_random              #call the random function  
       move      $t0, $v0                #move the return address
       jal       get_random              #call the random function again
       move      $t1, $v0                #move the return address
           
       rem       $t0, $t0, 16            #find $t0 % 16
       rem       $t1, $t1, 16            #find $t1 % 16  
           
       blt       $t0, 0, abs1            #if $t0 is neg, goto abs1
       j         okay1                   #else goto this label

	abs1:                                #a label
       mul       $t0, $t0, -1            #to make $to positive

	okay1:                               #a label
       blt       $t1, 0, abs2            #if $t1 is neg, goto abs2
       j         okay2                   #else goto this label

	abs2:                                #a label
       mul       $t1, $t1, -1            #to make $t1 positive

	okay2:                               #a label
       move      $a0, $t0                #move it to an argument register
       move      $a1, $t1                #move it to an argument register
       jal       min                     #call min
       move      $t2, $v0                #move the return address
       
       move      $a0, $t0                #move it to an argument register
       move      $a1, $t1                #move it to an argument register
      
       jal       max                     #call max
      
       move      $t3, $v0                #move the return address
       
       move      $t0, $t2                #move it to another temporary register
       move      $t1, $t3                #move it to another temporary register
       move      $a0, $t0                #move it to an argument register 
       move      $a1, $t1                #move it to an argument register
     
       jal       checkValid              #call checkValid
           
       move      $t2, $v0                #move the return address
       beq       $t2, 1,if1_pc           #if returned 1, goto if1_pc
       j         for1_pc                 #else continue the loop
           
	if1_pc: 
	   div       $t2, $t0,4 			 #(pc's move)row1 = val1 / 4
       div       $t3, $t1,4 			 #(pc's move)row2 = val2 / 4
          
       rem       $t4, $t0,4 			 #col1 = val1 % 4
       rem       $t5, $t1,4 			 #col2 = val2 % 4
       add       $t2, $t2,97 			 #ch1
       add       $t3, $t3,97 			 #ch2
       add       $t4, $t4, 1 			 #col1++
       add       $t5, $t5, 1 			 #col2++
          
       la        $a0, pcPrintf1 		 #load address
       li        $v0, 4                  #to print a string
       syscall                           #print it
          
       move      $a0, $t2 			     #move it to an argument register
       li        $v0, 11                 #to print char
       syscall                           #print char
          
       move      $a0, $t4  				 #move it to an argument register
       li        $v0, 1                  #to print int
       syscall                           #print int
          
       la        $a0, printAnd           #load " and "
       li        $v0, 4                  #to print string
       syscall                           #print " and "
           
       move      $a0, $t3 				 #move it to an argument register
       li        $v0, 11                 #to print char
       syscall                           #print char
          
       move      $a0, $t5  				 #move it to an argument register
       li        $v0, 1                  #to print int
       syscall                           #print int
          
       la        $a0, newLine            #load '\n'
       li        $v0, 4                  #to print char
       syscall                           #print char
                                       
	 exit_for1_pc:                       #a label
	   jal       emptyStack              #goto emptyStack
            
       lw        $ra, 0($sp)             #load return address
       addi      $sp, $sp, 4             #adjust stack pointer
            
       jr        $ra                     #return
        
           #this function generates a valid pc move using get_random function

              
    intro:                               #a function
       la        $a0, introPrint         #load this label
       li        $v0, 4                  #to print string
       syscall                           #print string
       
       jr        $ra
       
    credits:                             #a function
       la        $a0, creditPrint        #load this label
       li        $v0, 4                  #to print string
       syscall                           #print string
       la        $a0, Tahmid             #load this label
       syscall                           #print string
       la        $a0, Shammy             #load this label
       syscall                           #print string
       
       jr        $ra                     #return
                                                                                          
	turn:                                #a function
       addi      $sp, $sp, -4            #adjust stack pointer
       sw        $ra,  0($sp)            #store return address
            
       jal       putInStack              #goto putInStack
    
   while1_turn:                          #a loop
	   la        $a0, firstSeed          #to prompt
       li        $v0, 4                  #to print string
       syscall                           #print string
            
       li        $v0, 5                  #to take int input
       syscall                           #take int input
       
       bne       $v0, 0, exit_while1_turn #if input != 0 exit the loop
            
       la        $a0, cantBeZero         #else load this label
       li        $v0, 4                  #to print the label
       syscall                           #print it
            
       j         while1_turn             #continue the loop


	exit_while1_turn:                    #a label
       move      $s3, $v0                #move it to a saved register
            
	while2_turn:                         #a loop
	   la        $a0, secondSeed         #to prompt
       li        $v0, 4                  #to print string
       syscall                           #print string
             
       li        $v0, 5                  #to take int input
       syscall                           #take int input
       bne       $v0, 0,exit_while2_turn #if input != 0 exit the loop
            
       la        $a0, cantBeZero         #else load this label    
       li        $v0, 4                  #to print string 
       syscall                           #print string
            
       j         while2_turn             #continue the loop


	exit_while2_turn:                    #a label
       move      $s4, $v0                #move it to a saved register
            
       jal       get_random              #call get_random
            
       rem       $s2, $v0, 2             #find return value % 2
            
       beq       $s2, 0,if1_turn 		 #$s2 = playerTurn, 0 = your turn
       la        $a0, firstTurnPc        #else pcTurn and show the message
       li        $v0, 4                  #to print string
       syscall                           #print string
       j         exit_if1_turn           #goto this label

	if1_turn:                            #a label                                                                
       la        $a0, firstTurnPlayer    #to show user that it is his turn
       li        $v0, 4                  #to print string
       syscall                           #print string

	exit_if1_turn:                       #a label
       jal       emptyStack              #goto emptyStack
            
       lw        $ra, 0($sp)             #load return address
       addi      $sp, $sp, 4             #adjust stack pointer
            
       jr        $ra                     #return
       
       #this function prompts user for two seeds and also tells who will go first    
                                                                                                                                                                    
	playGame:                            #a function
	   addi      $sp, $sp, -4            #adjust stack pointer
       sw        $ra,  0($sp)            #store return address
            
       jal       putInStack              #call putInStack
            
       li        $t0, 0 			     #int i = 0
       jal       turn                    #call turn
            
	while1_pG:                           #a loop
       add       $t1, $s0, $s1           #add pcWin and playerWin
       beq       $t1, 9, exit_while1_pG  #if the sum == 9 exit the loop
            
       rem       $t1, $t0, 2             #find i % 2
       bne       $t1, $s2, if1_pG 		 #pcTurn

                                         #else player Turn
	while2_pG:                           # a nested loop   
	   jal       result                  #call result
	   jal       showBoard               #call showBoard
	       
	   la        $a0, yourTurn           #load the label
	   li        $v0, 4                  #to print string
	   syscall                           #print string
	        
	   la        $a0, firstCordinate     #load the label
	   syscall                           #print the string
	        
	   li        $v0, 12				 #to get ch
	   syscall                           #get ch
	   move      $s6, $v0                #move it to a save register
	        
	   li        $v0, 5					 #to get x
	   syscall                           #get x
	   move      $t1, $v0 				 #t1 = y
	        
	   sub       $t6, $s6,97             #convert it to decimal from ascii
	   sub       $t1, $t1, 1             #y--
	        
	   blt       $s6, 97,invalid         #if($s6 < 97) goto invalid
	   bgt       $s6, 100,invalid        #else if($s6 > 100) goto invalid
	   blt       $t1, 0,invalid          #else if($t1 < 0) goto invalid
	   bgt       $t1, 3,invalid          #else if($t1 > 3) goto invalid
	   j         notInvalid              #else goto notInvalid
	        
	invalid:                             #a label
	   la        $a0, invalidMove        #load the label
	   li        $v0, 4                  #to print string
	   syscall                           #print string
	   j         while2_pG               #continue loop

	notInvalid:                          #label
       mul       $t8, $t6, 4             #convertion
       add       $t8, $t8, $t1           #convert it to decimal (0 - 15)
           
       la        $a0, secondCordinate    #load the label
       li        $v0, 4                  #to print string
       syscall						     #print string		 		
			
	   li        $v0, 12                 #to read char
	   syscall                           #read char
	   move      $t2, $v0 				 #t2 = ch1
		   
	   li        $v0, 5                  #to read int
	   syscall                           #read int
	   move      $t3, $v0  				 #t3 = y
		  
	   sub       $t7, $t2,97             #convert it to int
	   sub       $t3, $t3,1              #y--
		   
	   blt       $t2, 97,invalid         #if($t2 < 97) goto invalid
	   bgt       $t2, 100, invalid       #else if($t2 > 100) goto invalid
	   blt       $t3, 0, invalid         #else if($t3 < 0) goto invalid
	   bgt       $t3, 3, invalid         #else if($t3 > 3) goto invalid
		  
	   mul       $t9, $t7,4              #convertion
	   add       $t9, $t9, $t3           #convert it to decimal
		  
	   move      $a0, $t8                #move it to an argument register
	   move      $a1, $t9                #move it to an argument register
	   jal       min                     #call min
		   
	   move      $t4, $v0    			 #t4 = min
	   move      $a0, $t8                #move it to an argument register
	   move      $a1, $t9                #move it to an argument register
	   jal       max                     #call max
		   
	   move      $t5, $v0    			 #t5 = max
	   move      $t8, $t4                #move it to another temporary register
	   move      $t9, $t5                #move it to another temporary register
		           
	   beq       $s6, $t2,if2_pG         #if two rows (a-d) are equal
	   beq       $t1, $t3,if2_pG         #or if two columns(1-4)are equals 
		   
	   la        $a0, mustBeAdjacent     #load the label     
	   li        $v0, 4                  #to print string
	   syscall                           #print string
		   
	   j         while2_pG               #continue the loop and take input again
	   
	if2_pG:                              #a label
       move      $a0, $t8                #move it to an argument register
       move      $a1, $t9                #move it to an argument register
           
       jal       checkValid              #call checkValid
       move      $t4, $v0                #move the return value
       beq       $t4, 1, if3_pG          #if return value == 1 goto if3_pG
       j         invalid                 #else goto invalid

	if3_pG:                              #a label
       la        $a0, playGamePrintf1    #load the label
       li        $v0, 4                  #to print string
       syscall                           #print the string
           
       move      $a0, $s6                #move it to an argument register
       li        $v0, 11                 #to print char
       syscall                           #print char
           
       addi      $t1, $t1,1              #col1++
       li        $v0, 1                  #to print int
       move      $a0, $t1                #move it to an argument register
       syscall                           #print int
           
       la        $a0, printAnd           #load the label
       li        $v0, 4                  #to print string
       syscall                           #print string
          
       move      $a0, $t2                #move it to an argument register
       li        $v0, 11                 #to print char
       syscall                           #print char
           
       addi      $t3, $t3, 1             #col2++
       li        $v0, 1                  #to print int
       move      $a0, $t3                #move it to an argument register
       syscall                           #print int
           
       la        $a0, newLine            #load the level
       li        $v0, 4                  #to print string
       syscall                           #print the string
       syscall
           
       j         exit_while2_pG          #goto this label                                                                                                                                                               		    		           	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	                	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	        	     	        	        
       j         while2_pG               #goto this label
                       
        
	if1_pG:                              #pcTurn 
       la        $a0, myTurn             #load this label
       li        $v0, 4                  #to print string
       syscall                           #print string
            
       jal       pc                      #call pc
       addi      $t0, $t0,1              #i++
       lb        $a0, P                  #load 'P'
       jal       isBox					 #call isBox
       
       j         while1_pG               #continue loop
	
	exit_while2_pG:                      #a label
       lb        $a0, I                  #load 'I'
       jal       isBox                   #call isBox
       jal       showBoard               #call showBoard
       addi      $t0, $t0, 1             #i++
       j         while1_pG               #continue loop
            
	exit_while1_pG:                      #a label
       jal      emptyStack               #goto emptyStack
            
       lw       $ra, 0($sp)              #load return address      
       addi     $sp, $sp, 4              #adjust stack pointer
            
       jr       $ra                      #return
       
     #this function is what controls the game and the whole program

	result:                              # a function
       addi     $sp, $sp,-4              #adjust stack pointer
       sw       $ra, 0($sp)              #store return address
            
       jal      putInStack               #call putInStack
            
       la       $a0, yourScore           #load this label
       li       $v0, 4                   #to print string
       syscall                           #print string
            
       move     $a0, $s1                 #to show player's score     
       li       $v0, 1                   #to print int
       syscall                           #print int
            
       la       $a0, newLine             #load newline
       li       $v0, 4                   #to print string
       syscall                           #print string
            
       la       $a0, pcScore             #load this label
       li       $v0, 4                   #to print string
       syscall                           #print string
            
       move     $a0, $s0                 #to print pc's score
       li       $v0, 1                   #to print int
       syscall                           #print int
            
       la       $a0, newLine             #load newLine  
       li       $v0, 4                   #to print string
       syscall                           #print string
       
       jal      emptyStack               #call emptyStack 
            
       lw       $ra, 0($sp)              #load return address
       addi     $sp, $sp, 4              #adjust stack pointer
            
       jr       $ra                      #return
                                        	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                                	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	        
                                        	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                                	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                                	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                                       	        	        	        	        	               	        	        	        	        	                        	        	        	        	        	        
	putInStack:                          #function
	######################################
       addi     $sp, $sp,-4              #
	   sw       $t0, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t1, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t2, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t3, 0($sp)			     #
		                                 #
	   addi     $sp, $sp,-4              #
	   sw       $t4, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t5, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t6, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t7, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t8, 0($sp)              #
			                             #
	   addi     $sp, $sp,-4              #
	   sw       $t9, 0($sp)              #
			                             #
	   jr       $ra		                 #
##########################################

			#the above function is to put all the temporary registers in the stack			
	
	emptyStack:                          #function
	
	   lw        $t9, 0($sp)
       addi      $sp, $sp,4
            
	   lw        $t8, 0($sp)
       addi      $sp, $sp,4
             
       lw        $t7, 0($sp)
       addi      $sp, $sp,4
            
       lw        $t6, 0($sp)
       addi      $sp, $sp,4
            
       lw        $t5, 0($sp)
       addi      $sp, $sp,4
            
       lw        $t4, 0($sp)
       addi      $sp, $sp,4
            
       lw        $t3, 0($sp)
       addi      $sp, $sp, 4
            
       lw        $t2, 0($sp)
       addi      $sp, $sp, 4
            
       lw        $t1, 0($sp)
       addi      $sp, $sp, 4
            
       lw        $t0, 0($sp)
       addi      $sp, $sp, 4
            
       jr         $ra
       
       #The above function is to load all temporary registers from the stack 

# All memory structures are placed after the
# .data assembler directive

.data
	row:	      		.space	    	32
	row1:         		.space        	32
	check: 	      		.word         	0:500
	rowBoard:     		.asciiz       	"  1 2 3 4\n"
	ch:           		.byte         	'a'
	space:        		.byte         	' '
	dot:          		.byte         	'.'
	newLine:      		.byte         	'\n'
	newLine2:     		.asciiz       	"\n "
	underscore:    		.byte        	'_'
	line:          		.byte        	'|'
	I:            		.byte         	'I'
	P:             		.byte         	'P'
	pcPrintf1:     		.asciiz         "I draw a line between "
	playGamePrintf1: 	.asciiz      	"You drew a line between "
	printAnd:      		.asciiz        	" and "
	firstSeed:      	.asciiz        	"Enter the first seed (Range any valid integer number but not zero): "
	secondSeed:     	.asciiz       	"Enter the second seed (Range any valid integer number but not zero): "
	cantBeZero:     	.asciiz       	"Number can't be zero. Try again\n"
	firstTurnPlayer: 	.asciiz       	"\n\nFirst turn is yours.\n\n"
	firstTurnPc:     	.asciiz       	"\n\nFirst turn goes to me. :) \n\n"
	myTurn:          	.asciiz       	"\n\nMy Turn.\n\n\n"
	yourTurn:        	.asciiz         "\n\nYour Turn\n"
	firstCordinate:  	.asciiz         "\nEnter the first coordinate: "
	secondCordinate: 	.asciiz         "\nEnter the second coordinate: "
	invalidMove:     	.asciiz         "Invalid move. Try Again\n"
	mustBeAdjacent:  	.asciiz         "The points must be adjacent. Try Again!!! \n"
	yourScore:       	.asciiz         "Your Score: "
	pcScore:         	.asciiz         "PC Score: "
	youWon:          	.asciiz         "You win\n"
	pcWon:           	.asciiz         "I win =D\n" 
	introPrint:         .asciiz         "\t\t\tWelcome\n\t\t\t  To \n\t\t    Tahmid and Shammy's \n\t\t     DOTS AND BOXES\n\t\t       Version 1.0\n\n"
	creditPrint:        .asciiz         "\t\t    Tahmid and Shammy's \n\t\t     DOTS AND BOXES\n\t\t       Version 1.0\n\n\nCREDITS\n\n"
	Tahmid:             .asciiz         "1. Tahmid Khan, Roll: BSSE0801, 2nd Year, IIT, DU\n"  
	Shammy:             .asciiz         "2. Sumaya Shammy, Roll: BSSE0821, 2nd Year, IIT, DU\n"
	done:            	.asciiz         "done\n"    
			
		
