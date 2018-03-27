

            ###############################################
            #                                             #
            #                Data Segment                 #
            #                                             #
            ###############################################


                .data

str:            .space            256
address:        .space            34
address2:       .space            34
newline:        .asciiz           "\n"
msg1:           .asciiz           "First match at address "
msg2:           .asciiz           "No match found\n"
result:         .word             0             
null:           .byte             '\0'


            ###############################################
            #                                             #
            #                Text Segment                 #
            #                                             #
            ###############################################

                .text
                .globl           main


main:                                             #the label main represents the starting point
	            
	            li               $v0, 8           #Take input as string           
	            la               $a0, str         #load the address of str
	            li               $a1, 255         #put the size of str
	            syscall
	            #this segment invokes the user
	            #to give a string as input
	            #whose size must be less than 256 characters
	          
                li               $t0, 0           #$t0 = i, initialize i
                la               $s0, str         #load the address of str in $s0
    
loop:
    	        lb               $t2, ($s0)       #load a character of $s0
    	        beq              $t2, 0, notFound #if $t2 == 0 or '\0' goto notFound label
    	        beq              $t2, 'm', Found  # if $t2 == 'm' goto Found 
    	        addiu            $s0, $s0, 1      #i++
    	        j                loop             #continue loop
                #this is a loop that iterates
                #till it finds 'm' or a null character
 
Found:
    	        la               $a0, msg1       #load the address of msg1
    	        li               $v0, 4          #print msg1
    	        syscall
    	        #this segment prints msg1
    	        
    	        move             $a0, $s0        #move the value in $s0 to $a0
    	        sw               $s0, result     #store the value in memory
    	        li               $v0, 1          #print 'm' s address in integer
    	        syscall
    	
    	        move             $t0, $s0        #move 'm' s address to $t0
    	        
    	        la               $a0, newline    #load the address of newLine
    	        li               $v0, 4          #print newLine
    	        syscall
  
    	        j                convertToHex    #now to convert the integer to hexadecimal
    	        j                exit            #after convertion goto exit
                #the above segment will occur when 'm' is found in the input
    
    
notFound:
    	        la               $a0, msg2     #load the address of msg2
    	        li               $v0, 4        #print msg2
    	        syscall
                #the above segment will occur when 'm' isn't found
     
exit:
    	        li               $v0, 10      #terminate program
    	        syscall
                #the above segment is for terminating the program
    
convertToHex:
    	        li               $t2, 48             #initialize $t2 = 0
    	        sb               $t2, address($t2)   #store the value of $t2 in address
    	        li               $t1, 0              #initialize $t1
branch:
    		    beq              $t0, 0, hexValue    #if $t0 = 0, goto hexvalue, 
    		                                         #$t0 has the address of 'm' in decimal
    		    ##################################
    		    divu             $t1, $t0, 16    #
    		    mul              $t1, $t1, 16    #find $t1 = $t0 mod 16
    		    subu             $t1, $t0, $t1   #
    		    ##################################
    		    
    		    ble              $t1, 9, digit      #t1 <= 9 then a digit (0-9) has to be put in the array
    		    addi             $t1, $t1, 55       #else it is 10-15 and it needs to be converted into 'A'-'F'
    		    sb               $t1, address($t2)  #store either 'A' to 'F' in the address array

                #This branch loop converts the decimal to hexadecimal and put the answer in a reverse format in
                #the address array 

go:
    			addi             $t2, $t2, 1      #increment $t2
    			divu             $t0, $t0, 16     #divide the decimal by 16
    			j                branch           #continue the "branch" loop 
    		
digit:
    		   addi              $t1, $t1, 48      #if $t1 is a digit then convert it to in ascii character
    		   sb                $t1, address($t2) #store it in the address
    		   j                 go                #goto go and continue the "branch" loop
    		
hexValue:
    		   li                $t3, 0            #initialize $t3
    		
while: 
    		   blt               $t2, 0, printString   #if $t2 < 0, then exit while and goto printString
    		   sub               $t2, $t2, 1           #decrement $t2 
    		   lb                $t4, address($t2)     #load byte from address
    		   sb                $t4, address2($t3)    #store the loaded byte in address2
    		   addi              $t3, $t3, 1           #increment $t3
    		   j                 while                 #continue the loop
               #this above segment is to reverse the string and put it in another array 
    
printString:
    		   lb                $t0, null               #load null
    		   sb                $t0, address2($t3)      #store null at the end
    		   la                $a0, address2           #load the address of address2
    		   li                $v0, 4                  #print the string
    		   syscall
    		   j                 exit		             #goto exit
  			   #this above segment is to print the hexadecimal value   	 	
