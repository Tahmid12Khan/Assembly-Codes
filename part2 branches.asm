

            ###############################################
            #                                             #
            #                Data Segment                 #
            #                                             #
            ###############################################


                .data

A:               .word          10                    #declare A and initialize it with 10
B:               .word          15                    #declare B and initialize it with 15         
C:               .word          6                     #declare C and initialize it with 6
Z:               .word          0                     #declare Z and initialize it with 0


            ###############################################
            #                                             #
            #                Text Segment                 #
            #                                             #
            ###############################################

                .text
                .globl           main


main:                                             #the label main represents the starting point
                lw               $t0, A           #load the value of A in $t0
                lw               $t1, B           #load the value of B in $t1
                lw               $t2, C           #load the value of C in $t2
                lw               $t3, Z           #load the value of Z in $t3
                
                bgt              $t0, $t1, if     #if(A > B)goto if
                beq              $t2, 6, if       #or ((C+1) == 7) or (C == 6) goto if
                
                blt              $t0, $t1, elseif #if( A < B) goto elseif
                j                else             #if not (A < B) goto else
elseif:
                bgt              $t2, 5, elseif2  #if(C > 5) goto elseif2
                j                else             #if not(C > 5) goto else
elseif2:        
                li               $t3, 2           #if( A > B && C > 5) $t3 = 2
                sw               $t3, Z           #store $t3 in Z
                j                switch           #goto switch
                
else:                  
                li               $t3, 3           #if neither condition fulfils, $t3 = 3
                sw               $t3, Z           #store $t3 in Z
                j                switch           #goto switch           
                
if:
                li                $t3, 1          #if(A > B || C == 6)$t3 = 1
                sw                $t3, Z          #store $t3 in Z

switch:
                beq               $t3, 1, one     #if(Z == 1) goto one
                beq               $t3, 2, two     #if(Z == 2) goto two
                beq               $t3, 3, three   #if(Z == 3) goto three
                li                $t3, 0          #default case, Z = 0
                
                j exit                            #goto exit

one:
                li                $t3, -1         #if(Z == 1) Z = -1
                j exit                            #goto exit

two:
                li                $t3, -2         #if(Z == 2) Z = -2
                j exit                            #goto exit
                
three:
                li                $t3, -3         #if(Z == 3) Z = -3
                j exit                            #goto exit    
                
exit:
                sw                $t3, Z          #store the value of $t3 in Z
                li                $v0, 10         #terminate the program
                syscall                
                
                #end of code
                
     
                                      
                
                
                
                                            
                
                    
                        
                            
                                
                                    
                                        
                                                