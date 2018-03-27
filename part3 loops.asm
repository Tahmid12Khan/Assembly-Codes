

            ###############################################
            #                                             #
            #                Data Segment                 #
            #                                             #
            ###############################################


                .data
Z:              .word            4               # declare Z and initialize with 4
i:              .word            0               # declare i and initialize it with 0
	

            ###############################################
            #                                             #
            #                Text Segment                 #
            #                                             #
            ###############################################

                .text
                .globl           main


main:                                            #the label main represents the starting point

	           lw               $t0, Z           # load the value of Z in $t0
	           lw               $t1, i           #load the value of i in $t1
	           
	           li               $t1, 0           #initialize $t1 with 0
	           sw               $t1, i           #store the value in $t1           

for:	                                         # a loop  
	           bgt              $t1, 21, do      #loop till $t1 <= 21 and then goto do
	           addi             $t0, $t0, 1      #increment $t0 by 1
	           sw               $t0, Z           #store the value of $t0 in Z
	           
	           addi             $t1, $t1, 3      #increment the value of $t1 by 3
	           sw               $t1, i           #store the value of $t1 in i
	           j                for              #continue the loop

do:                                              #a do while loop
               addi             $t0, $t0, 1      #increment $t0 by 1
               sw               $t0, Z           #store it in Z
               blt              $t0, 100, do     # loop till $t0 < 100 or Z < 100
               
while:                                           #a while loop
               ble              $t1, 0, exit     #if $t1 or i == 0 then exit the loop
               
               addi             $t0, $t0, -1     #decrement the value of $t0 by 1
               sw               $t0, Z           #store it in Z
               
               addi             $t1, $t1, -1     #decrement the value of $t1 by 1
               sw               $t1, i           #store it in i
               j                while            #continue loop
          
exit:                                            #after finishing the loop
               li               $v0, 10          #terminate the program
               syscall                    
               #end of code        	           	           	           	                   	           	           	           	           
