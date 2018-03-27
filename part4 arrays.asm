

            ###############################################
            #                                             #
            #                Data Segment                 #
            #                                             #
            ###############################################


                .data
A:              .word            0:5               # declare A with size 5 and initialize with 0
B:              .word            1, 2, 4, 8, 16    #declare B with size 5 and initialize
	

            ###############################################
            #                                             #
            #                Text Segment                 #
            #                                             #
            ###############################################

                .text
                .globl           main


main:                                            #the label main represents the starting point

	           li               $t0, 0           # i = $t0 and initialize it with 0
	
for:                                             #a loop to iterate the array
		       beq              $t0, 20, end_for #if $t0 = 5 * 4 (size of word) = 20, end loop
		       lw               $t1, B($t0)      #load a certain word from the B array
		       sub              $t1, $t1, 1      #decrement the value by 1
		       sw               $t1, A($t0)      #store the value in a certain index in A
		       add              $t0, $t0, 4      #i++, as the arrays are of words, increment the loop variable by 4
		       j                for              #continue the loop
		       
		       #the above segment is to iterate through the whole array
	
end_for:                                         #exit the loop 
		      add               $t0, $t0, -4     #decrement $t0 by 4 and so $t0 = 16 or i = 4
	
while:                                           # a loop to iterate the array
		      bltz              $t0, exit        #if i = 0 or $t0 = 0, exit the loop
		      
		      lw                $t1, A($t0)      #load a certain word from A
		      lw                $t2, B($t0)      #load a certain word from B
		      add               $t1, $t1, $t2    #add those two words
		      sll               $t1, $t1, 1      #make it double or or twice the value or shift left by one digit
		      sw                $t1, A($t0)      #store it in A
		      sub               $t0, $t0, 4      #decrement $t0 by 4 (size of word) or i--
		      j                 while
		      #the above segment is to iterate through the whole array
	
exit:
		      li               $v0, 10          #terminate the program
		      syscall
		      #the above segment is to terminate the program
