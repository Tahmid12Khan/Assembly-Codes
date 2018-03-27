

            ###############################################
            #                                             #
            #                Data Segment                 #
            #                                             #
            ###############################################


                 .data

Z:               .word 0                          #declare Z and initialize it with 0


            ###############################################
            #                                             #
            #                Text Segment                 #
            #                                             #
            ###############################################

                .text
                .globl           main


main:                                             #the label main represents the starting point
	 
	             li              $t0, 15          #$t0 = A = 15
	             li              $t1, 10          #$t1 = B = 10
	             li              $t2, 5           #$t2 = C = 5
	             li              $t3, 2           #$t3 = D = 2
	             li              $t4, 18          #$t4 = E = 18
	             li              $t5, -3          #$t5 = F =-3
	             
	             sub             $t6, $t0, $t1    #(A - B)
	             add             $t7, $t2, $t3    #(C + D)
	             sub             $t8, $t4, $t5    #(E - F)
 	             div             $t9, $t0, $t2    #(A / C)
 	             
 	             mul             $s0, $t6, $t7    #(A - B) * (C + D)
 	             add             $s0, $s0, $t8    #(A - B) * (C + D) + (E - F)
 	             sub             $s0, $s0, $t9    #(A - B) * (C + D) + (E - F) - (A / C)
 	             
 	             sw              $s0, Z           #Store $s0 in Z
 	             
 	             li              $v0, 10          #terminate the program
 	             syscall
 	             
 	             #end of code
 	             
 	               
 	                 
 	                   
 	                     
 	                       
 	                           
