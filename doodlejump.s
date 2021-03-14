#####################################################################
#
#
# Student: Yu Xue, Student Number: 1006057357
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
 
# Bitmap Display Configuration:
 # - Unit width in pixels: 8
 # - Unit height in pixels: 8
 # - Display width in pixels: 256
 # - Display height in pixels: 512
 # - Base Address for Display: 0x10008000 ($gp)
 #
# Which milestone is reached in this submission 
 # (See the assignment handout for descriptions of the milestones)
 # - Milestone 5 (Finished Everything) 
#
# Which approved additional features have been implemented?
 # (See the assignment handout for the list of additional features)
 # 1. Game Over / Retry (Milestone 4)
 # 2. Dynamic Increase in Difficuly for shapes, width of platforms (Milestone 4)
 # 3. Realistic Physics (Milestone 5)
 # 4. More Platform Types (Milestone 5)
 # 5. Fancier Graphics (Milestone 5)
#
# Any additional information that the TA needs to know:
# - For Milestone 4, dynamic increase in difficulty, I have three different levels right now. As doodler jump higher, the score 
#   will increase and result in change in the space (width) of platforms, so the difficulty will increase 
# - More platform types, I have the purple one that is moving platform, brown one for the fragile blocks but it allows the doolder
#   to jump upon it and then disappear, white one when doolder jumps on it, it will change its position horizontally, and last one (green)
#   is just the normal platform
# - Fancier Graphics, I include a lot of details in character and platforms, but the background is not too detailed, it just with a sky and
# 	fixed stars. I don't want to do a very detailed background otherwise I might need to draw the background over and over agian
# - Realistic Physics, My doodler jumps on a parabola function, so it will jump up, the velocity from postivie numbers will reach to 0 (max
#   height) to negative (due to the force of gravity)
# - Start and restart, I have two separate pages for that, so also count towards fancier graphics, enter s to start/restart and enter 
#   e to end the game at any time !
# - Enter j to move left and k to move right 
# - For Milestone 3, infinite wrapping around screen boundaaries, according to the piazza, I am allowed to make an invisible wall to
#   prevent the doodler go off the screen.
# - All the best, thanks for your patience.
#
#####################################################################


.data
	displayAddress: .word 0x10008000
	# backgroundColour: .word 0xEFDBC7 # Background colour, light yellow
	backgroundColour: .word 0x4A2A71 # 0x93E4FD
	colourPink: .word 0xD77BB8
	colourOrganze: .word 0xDF712B
	colourRed: .word 0xE42402
	colourGreenForest: .word 0x369470
	colourGreenDark: .word 0x6ABE34
	colourGreenLight: .word 0x99E55B
	colourYellow: .word 0xFFFC51
	colourYellowLight: .word 0xFFF874
	colourYellowMedium: .word 0xF6EC2E
	colourYellowDark: .word 0xC4BC23
	colourBlueDark: .word 0x00C7FB
	colourBlack: .word 0x000000
	colourBlue: .word 0x5ECDE3
	colourPlatformNormal: .word 0x369470
	colourWhite: .word 0xFFFFFF
	colourGray: .word 0xEBEBEB
	colourGrayLight: .word 0xD7D7D7
	colourBrownLight: .word 0xD9A069
	colourBrown: .word 0xAB7945
	colourBrownDark: .word 0x8F563C
	colourPurpleLight: .word 0xBE38F1
	colourPurpleMedium: .word 0xD357FB
	colourPurpleDark: .word 0xE392FC
	colourPinkDark: .word 0xEE719D
	velocity: .word -640, -512, -256, -128, 0, 128, 128, 128, 512, 640, 1280, 1280, 8064 # The speed 
	charAddress: .word 0x10009A28 # 0x10009A28 # Character stands at the bottom 
	platformAddress: .word 0x10009F20 # At the bottom 
	# I did this because I want to fix number of platforms and avoid using array (easier)
	# platformAddress1: .space 4
	# platformAddress2: .space 4
	# platformAddress3: .space 4
	# platformAddress4: .space 4
	# platformAddress5: .space 4
	# platformAddress6: .space 4
	platformOthers: .space 24 # 24 / 4 = 6 platforms, lst[0] is the topmost platform
	platformWidths: .space 28 # Include the bottom
	platformTypes: .space 28 # 0 for normal type, 1 for break type, 2 for move type, 3 for 
	platformSpeed: .space 28 # 0 for any type, 4 for move platform type
	platformWidth: .word 0x11 # The wdith of the platform, by default 10 
	separateLine: .word 0x100094FC
	platformFragiles: .space 24
	score: .word 0x0
	platformAddressBottom: .word 0x10009F00
	platformAddressSecondLast: .word 0x10009A00
	platformAddressThirdLast: .word 0x10009500
	
.text
	main:
		jal drawGameStart
		main_menu:
			lw $t8, 0xffff0000
			beq $t8, 1, preExitLoop
			j main_menu
			
		game_start:
	
		jal initGame
		# Move the character and normal platform 
		# addi $a1, $a1, 6696
		# add $s0, $zero, $zero # Loop variable
		# addi $s1, $zero, 10 # Max loop
		la $s3, velocity # Load the velocity
		lw $a1, charAddress # Set $a1 to be the character address
		# jal drawBackground
		jal drawCharacter
		MAINLOOP:
			jal drawCharacter
			jal sleepProgram
			# Draw background
			# Draw platforms	
			# Draw characters
			
			# Update Screen

			# jal randomPlatform
			# lw $a2, platformAddress
			# jal drawPlatformNormal
			lw $t8, 0xffff0000
			beq $t8, 1, keyboard_input # Check if we press a key or not 
			# bne $s0, $s1, MAINLOOP_update
			# add $s0, $zero, $zero # Reinitialize $s0 again
			# la $s3, velocity # Reach to the end
		MAINLOOP_update:
			# Update current position
			lw $t9, 0($s3) # Update velocity[i], = num of units
			add $a3, $zero, $t9
			# Check character's position:
				# 0 == nothing
				# 1 == game end
				# 2 == reset velocity
			######
			# lw $a0, backgroundColour
			# jal drawPlatforms
			jal checkOnPlatform
			add $t0, $zero, $zero # Check if t0 == 0
			checkOnPlatformResult:
				bne $v0, $t0, somethingChange
				# If not, then equal to 0, jump to the end
				j nothingChange
			somethingChange:
				addi $t0, $t0, 1
				beq $v0, $t0, preExit # Exit only if user input e, in this stage user can input s to restart
				# Then it will equal to 2, we will reset velocity
				addi $t0, $t0, 1
				#############
				# add $s0, $zero, $zero # Reinitialize $s0 again
				la $s3, velocity
				# lw $t9, 0($s3)
				#############
			nothingChange:
			######
			jal drawBackground
			jal drawPlatforms
			
			
			# Set a1 to character position
			lw $a1, charAddress
			lw $t9, 0($s3)
		 	add $a1, $a1, $t9 # Update character's position 
		 	sw $a1, charAddress
		 	addi $s3, $s3, 4
		 	# addi $s0, $s0, 1
		 	
		 	

			j MAINLOOP
		keyboard_input:
			jal sleepProgram2
			lw $t2, 0xffff0004
			beq $t2, 0x65, Exit # Input 'e' to exit the program
			
			beq $t2, 0x73, game_start
			
			beq $t2, 0x6A, move_left # Move the character to the left
			beq $t2, 0x6B, move_right # Move the character to the right
			j MAINLOOP
			
			move_left:
				jal drawBackground
				jal moveCharacterLeft
				jal drawPlatforms

				j MAINLOOP_update
				
			move_right:
				jal drawBackground
				jal moveCharacterRight
				jal drawPlatforms
				j MAINLOOP_update
				
			# move_right:
			
			
			j MAINLOOP # If not then jump back to main loop
		
		preExit:
		jal drawRestartMenu
		preExitLoop:
			# Draw the game start window
			lw $t2, 0xffff0004
			beq $t2, 0x65, Exit # End program
			beq $t2, 0x73, game_start # Restart
			j preExitLoop # Stay here forever if user didn't input anything
			
	
	# Initialize game (for start and restart)
	initGame:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		# Initialize the game (all the default value that may change in laterrr)
		addi $t1, $zero, 268474920 # 0x10009A28
		sw $t1, charAddress
		addi $t1, $zero, 268476192 # 0x10009F20
		sw $t1, platformAddress
		jal drawGameBoard
		jal initializePlatforms
		
		addi $t1, $zero, 0
		sw $t1, score
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	
	# Creating a function for main character
	drawCharacter:
		
		# Store the colour value
		# add $t0, $zero, $a1
		
		lw $t0, charAddress
		lw $t1, colourPink
		
		lw $t2, colourOrganze
		lw $t3, colourRed
		lw $t4, colourGreenForest
		lw $t5, colourGreenLight
		lw $t6, colourYellow
		lw $t7, colourBlack
		lw $t8, colourBlue
		
		# Draw the characters
		sw $t1, 8($t0) # First Line
		sw $t1, 132($t0) # Second Line
		sw $t2, 136($t0)
		sw $t6, 140($t0)
		sw $t6, 144($t0)
		sw $t6, 148($t0)		
		sw $t1, 256($t0) # Third Line
		sw $t3, 264($t0)
		sw $t8, 268($t0)
		sw $t5, 272($t0)
		sw $t2, 276($t0)
		sw $t2, 280($t0)
		sw $t4, 388($t0) # 4th Line
		sw $t8, 392($t0)
		sw $t6, 396($t0)
		sw $t6, 400($t0)
		sw $t6, 404($t0)
		sw $t6, 408($t0)
		sw $t6, 412($t0)
		sw $t6, 516($t0) # 5th Line
		sw $t6, 520($t0)
		sw $t6, 524($t0)
		sw $t7, 528($t0)
		sw $t6, 532($t0)
		sw $t7, 536($t0)
		sw $t6, 540($t0)
		sw $t6, 548($t0)
		sw $t6, 644($t0) # 6th Line
		sw $t6, 648($t0)
		sw $t6, 652($t0)
		sw $t6, 656($t0)
		sw $t6, 660($t0)
		sw $t6, 664($t0)
		sw $t6, 668($t0)
		sw $t6, 672($t0)
		sw $t6, 676($t0)
		sw $t6, 772($t0) # 7th Line
		sw $t6, 776($t0)
		sw $t6, 780($t0)
		sw $t6, 784($t0)
		sw $t6, 788($t0)
		sw $t6, 792($t0)
		sw $t6, 796($t0)
		sw $t6, 804($t0)
		sw $t5, 900($t0) # 8th Line
		sw $t5, 904($t0)
		sw $t5, 908($t0)
		sw $t5, 912($t0)
		sw $t5, 916($t0)
		sw $t5, 920($t0)
		sw $t5, 924($t0)
		sw $t4, 1028($t0) # 9th Line
		sw $t4, 1032($t0)
		sw $t4, 1036($t0)
		sw $t4, 1040($t0)
		sw $t4, 1044($t0)
		sw $t4, 1048($t0)
		sw $t4, 1052($t0)
		sw $t4, 1156($t0) # 10th Line
		sw $t4, 1164($t0)
		sw $t4, 1172($t0)
		sw $t4, 1180($t0)
		jr $ra

	# Creating a function for platform
	drawPlatformNormal:
		lw $t4, platformWidth # Loop counter ends 
		add $t1, $zero, $a0 # Platform colour
		lw $t2 backgroundColour
		add $t3, $zero, $zero
		add $t5, $zero, $zero # Set t5 to be zero

		addi $t6, $zero, 2 # Set t3 to be 2
		addi $t8, $zero, 128 # Store the width
		LOOPA:
			add $t0, $zero, $a2
			mult $t5, $t8 # Product of $t5 and $t8
			mflo $t7
			add $t0, $t0, $t7
			beq $t5, $t6, ENDA
			LOOPB:
				beq $t3, $t4, ENDB
				sw $t1, 0($t0) # Draw the square 
			UPDATEB:
				addi $t3, $t3, 1 # Increment by 1
				addi $t0, $t0, 4 # Increment the current address by 4
				j LOOPB
			ENDB:
				add $t3, $zero, $zero # Reset $t3 back to 0
				
			UPDATEA:
				addi $t5, $t5, 1
				j LOOPA
		ENDA:
			add $t0, $zero, $a2
			sw $t2, 0($t0)
			addi $t0, $t0, 128
			add $t4, $t4 $t4 # Add two 
			add $t4, $t4 $t4 
			addi $t4, $t4, -4
			add $t0, $t0, $t4
			
			sw $t2, 0($t0) # For mismatch, colour two units background colour
			jr $ra
			
			
	

	# Creating a function for background
	drawBackground:
	lw $t0, charAddress
	lw $t1, backgroundColour
	# Draw the characters
		sw $t1, 8($t0) # First Line
		sw $t1, 132($t0) # Second Line
		sw $t1, 136($t0)
		sw $t1, 140($t0)
		sw $t1, 144($t0)
		sw $t1, 148($t0)		
		sw $t1, 256($t0) # Third Line
		sw $t1, 264($t0)
		sw $t1, 268($t0)
		sw $t1, 272($t0)
		sw $t1, 276($t0)
		sw $t1, 280($t0)
		sw $t1, 388($t0) # 4th Line
		sw $t1, 392($t0)
		sw $t1, 396($t0)
		sw $t1, 400($t0)
		sw $t1, 404($t0)
		sw $t1, 408($t0)
		sw $t1, 412($t0)
		sw $t1, 516($t0) # 5th Line
		sw $t1, 520($t0)
		sw $t1, 524($t0)
		sw $t1, 528($t0)
		sw $t1, 532($t0)
		sw $t1, 536($t0)
		sw $t1, 540($t0)
		sw $t1, 548($t0)
		sw $t1, 644($t0) # 6th Line
		sw $t1, 648($t0)
		sw $t1, 652($t0)
		sw $t1, 656($t0)
		sw $t1, 660($t0)
		sw $t1, 664($t0)
		sw $t1, 668($t0)
		sw $t1, 672($t0)
		sw $t1, 676($t0)
		sw $t1, 772($t0) # 7th Line
		sw $t1, 776($t0)
		sw $t1, 780($t0)
		sw $t1, 784($t0)
		sw $t1, 788($t0)
		sw $t1, 792($t0)
		sw $t1, 796($t0)
		sw $t1, 804($t0)
		sw $t1, 900($t0) # 8th Line
		sw $t1, 904($t0)
		sw $t1, 908($t0)
		sw $t1, 912($t0)
		sw $t1, 916($t0)
		sw $t1, 920($t0)
		sw $t1, 924($t0)
		sw $t1, 1028($t0) # 9th Line
		sw $t1, 1032($t0)
		sw $t1, 1036($t0)
		sw $t1, 1040($t0)
		sw $t1, 1044($t0)
		sw $t1, 1048($t0)
		sw $t1, 1052($t0)
		sw $t1, 1156($t0) # 10th Line
		sw $t1, 1164($t0)
		sw $t1, 1172($t0)
		sw $t1, 1180($t0)
		
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal drawStars
	# lw $a0, backgroundColour
	# jal drawPlatforms
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	jr $t0
	
		
	
		
			
	# A function to sleep the program
	sleepProgram:
		li $v0, 32
		li $a0, 100
		syscall
		jr $ra
		
	sleepProgram2:
		li $v0, 32
		li $a0, 50
		syscall
		jr $ra
		
	# A function that generate a platform at top
	randomPlatform:
		li $v0, 42
		li $a0, 0
		li $a1 18
		syscall # Randomized a horizontal position for a platform
		# To align the word
		add $a0, $a0, $a0 # So 2 $a1
		add $a0, $a0, $a0 # Since 2 * $a1 + 2 * $a1 = 4 * $a1
		addi $a0, $a0, 256 # Update ot the vertical position 
		lw $t2, displayAddress
		add $a0, $a0, $t2
		add $v0, $zero, $a0
		jr $ra
		
	# A function that will check if character stands on a platform or not 
	checkOnPlatform:
		# Push value into stack 
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		lw $t0, charAddress
		# 0 == game not end, no change to the velocity
		# 1 == game end
		# 2 == on a platform and reset velocity 
		
		lw $t1, colourGreenDark # Colour of platform
		lw $t2, colourBrownDark # Colour of fragile platform 
		lw $t9, colourPurpleMedium # Colour of move platform
		
		addi $t3, $t0, 1280 # Character bottom left position
		addi $t3, $t3, 4 # For left leg
		addi $t4, $t3, 24 # Character right leg
		lw $t5, 0($t3) # Colour at bottom left position
		lw $t6, 0($t4) # Colour at bottom right position
		
		add $t7, $zero, $t0
		addi $t7, $t7, -268468224 # Get real character position
		addi $t7, $t7, 1280 # Character bottom left position
		addi $t7, $t7, -8063 # -1 because we want to use <= so game not end 
		
		add $t8, $zero, $a3 # Current velocity
		add $v0, $zero, $zero # Clear the register
		checkPlatform:
			blez $t7 gameNotEnd
			# If not, then game ends, set return variable to 1
			addi $v0, $zero, 1
			j exitCheck
		gameNotEnd:
			lw $t2, colourBrownDark # Colour of fragile platform 
			beq $t5, $t1, onPlatform # Normal
			beq $t6, $t1, onPlatform 
			beq $t5, $t2, onBreakPlatform # Break
			beq $t6, $t2, onBreakPlatform
			beq $t5, $t9, onPlatform # Move
			beq $t6, $t9, onPlatform # Move
			lw $t2, colourWhite # Colour of shifting platform 
			beq $t5, $t2, onShiftingPlatform # Shifting
			beq $t6, $t2, onShiftingPlatform # Shifting 
			
			
			# Check for two other legs 
			addi $t3, $t3, 8
			lw $t5, 0($t3)
			beq $t5, $t1, onPlatform
			lw $t2, colourBrownDark # Colour of fragile platform 
			beq $t5, $t2, onBreakPlatform
			beq $t5, $t9, onPlatform # Move
			lw $t2, colourWhite # Colour of shifting platform 
			beq $t5, $t2, onShiftingPlatform # Shifting 

			addi $t3, $t3, 8
			lw $t5, 0($t3)
			beq $t5, $t1, onPlatform
			lw $t2, colourBrownDark # Colour of shifting platform 
			beq $t5, $t2, onBreakPlatform
			beq $t5, $t9, onPlatform # Move
			lw $t2, colourWhite # Colour of shifting platform 
			beq $t5, $t2, onShiftingPlatform # Shifting 
			
			# If not, then not on platform, dont change return variable with initial value 0
			j exitCheck
			
		onBreakPlatform:
			addi $a3, $zero, 0
			bgtz $t8, greaterThanZeroBreak
			j exitCheck
		onShiftingPlatform:
			addi $a3, $zero, 1
			bgtz $t8, greaterThanZeroBreak
			j exitCheck
		greaterThanZeroBreak:
			jal updateBreakPlatform
			j greaterThanZero
			
		onPlatform:
			# add $t7, $zero, $zero
			# Check if we have > 0 velocity
			bgtz $t8, greaterThanZero
			# If not, then velocity <= 0, dont change anything 
			j exitCheck
		greaterThanZero:
			# Set variable to 2, we will use this fact to reset velocity
			addi $v0, $zero, 2
			lw $t0, charAddress
			lw $t1, separateLine
			blt $t1, $t0, exitCheck # Check for the sepearate line
			# Store ra into $t8
##################################################################
			# update the score, since moving up by 1
			lw $t0, score
			addi $t0, $t0, 1
			sw $t0, score
			
			jal updatePlatforms
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			jr $t0
		exitCheck:
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			jr $t0
		
	drawGameBoard:
		addi $sp, $sp, -4
 		sw $ra, 0($sp)
		lw $t9, backgroundColour # Set $t9 to the background colour
		add $t1, $zero, $zero		# Set $t1 to 0, variable increment
		addi $t2, $zero, 2048  # Since 64 * 128 units
		lw $t0, displayAddress # Set $t0 to be the address
		LOOP:
			beq $t1, $t2, END
			sw $t9, 0($t0) # Draw the colour
			addi $t0, $t0, 4 # Increment $t0 by 4
		UPDATE:
			addi $t1, $t1, 1
			j LOOP
		END:
			jal drawStars
			lw $t0, 0($sp)
   			addi $sp, $sp, 4
   			jr $t0
			
			
	updateBreakPlatform:
		# A3 == 0 then it's break platform 1 if it is shifting platform
		# Push into stack 
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		# Only need to compare last three because we only jump on these three
		lw $t0, charAddress
		addi $t0, $t0, 1152 # To get the bottom left corner
		
		# Check if character at the bottom 
		lw $t1, platformAddress
		bleu $t0, $t1, numberSmallerPlatform0 # on the top of platform
		j endUpdateBreakPlatform0
		
		numberSmallerPlatform0:
			addi $t3, $t0, 252 # Next line
			bge $t3, $t1, numberBiggerPlatform0 # Add one line, > platform address
			j endUpdateBreakPlatform0
			
		numberBiggerPlatform0:
			# Clean the platform 
			la $a1, platformWidths
			addi, $a1, $a1, 24
			lw $a1, 0($a1)
			lw $a0, platformAddress
			jal cleanFancierNormalPlatform
			
			lw $t1, platformAddress
			
			# Check if it was shifting platform
			bgtz $a3, updatingShiftingPlatform0
			j updatingBreakPlatform0
	
		updatingBreakPlatform0:
			# Update the platform and exit\
			addi $t1, $t1, 5120
			sw $t1, platformAddress
			j endFinalUpdate
			
		updatingShiftingPlatform0:
			# Now we need to consider the width, so 32 - width is the will be the range
			la $t4, platformWidths
			lw $t4, 24($t4) # The width
			addi $t1, $zero, 32
			sub $t1, $t1, $t4 # 32 - width
			# Random Generate the number with max $t1
			li $v0, 42
			li $a0, 0
			add $a1, $zero, $t1
			syscall
			# multiply by 4
			add $a0, $a0, $a0
			add $a0, $a0, $a0
			lw $t1, platformAddressBottom
			add $t1, $t1, $a0
			sw $t1, platformAddress
			j endFinalUpdate
			
			
		
		endUpdateBreakPlatform0:
		
		lw $t0, charAddress
		addi $t0, $t0, 1152 # To get the bottom left corner
  		# Check if character at the second last platform 
  		la $t4, platformOthers
  		lw $t1, 20($t4)
  		ble $t0, $t1, numberSmallerPlatform1
  		j endUpdateBreakPlatform1
  
  		numberSmallerPlatform1:
   			addi $t3, $t0, 252 # Next line
   			bge $t3, $t1, numberBiggerPlatform1
   			j endUpdateBreakPlatform1
   
  		numberBiggerPlatform1:
   			# Clean the platform
   			la $a1, platformWidths
    		addi, $a1, $a1, 20
     		lw $a1, 0($a1)
     		la $a0, platformOthers
    		addi, $a0, $a0, 20
     		lw $a0, 0($a0)
     		jal cleanFancierNormalPlatform
     		
     		# Check if it was shifting platform
			bgtz $a3, updatingShiftingPlatform1
			j updatingBreakPlatform1

     		updatingShiftingPlatform1:
     			# Now we need to consider the width, so 32 - width is the will be the range
				la $t4, platformWidths
				lw $t4, 20($t4) # The width
				addi $t1, $zero, 32
				sub $t1, $t1, $t4 # 32 - width
				# Random Generate the number with max $t1
				li $v0, 42
				li $a0, 0
				add $a1, $zero, $t1
				syscall
				# multiply by 4
				add $a0, $a0, $a0
				add $a0, $a0, $a0
				lw $t1, platformAddressSecondLast
				add $t1, $t1, $a0
				la $t4, platformOthers
				sw $t1, 20($t4)
				j endFinalUpdate
     		
     		updatingBreakPlatform1:
  				# Update the platform and exit
   				la $t4, platformOthers
   				lw $t1, 20($t4)
   				addi $t1, $t1, 5120
   				sw $t1, 20($t4)
   				j endFinalUpdate
  			
  			endUpdateBreakPlatform1:

		
		lw $t0, charAddress
		addi $t0, $t0, 1152 # To get the bottom left corner
  		# Check if character at the third last platform 
  		la $t4, platformOthers
  		lw $t1, 16($t4)
  		ble $t0, $t1, numberSmallerPlatform2
 	    j endUpdateBreakPlatform2
  
  		numberSmallerPlatform2:
   			addi $t3, $t0, 252 # Next line
   			bge $t3, $t1, numberBiggerPlatform2
   			j endUpdateBreakPlatform2
   
  		numberBiggerPlatform2:
   			# Clean the platform
   			la $a1, platformWidths
     		addi, $a1, $a1, 16
     		lw $a1, 0($a1)
     		la $a0, platformOthers
     		addi, $a0, $a0, 16
   			lw $a0, 0($a0)
     		jal cleanFancierNormalPlatform
     		
     		# Check if it was shifting platform
			bgtz $a3, updatingShiftingPlatform2
			j updatingBreakPlatform2
     		
     		updatingShiftingPlatform2:
				
				# Now we need to consider the width, so 32 - width is the will be the range
				la $t4, platformWidths
				lw $t4, 16($t4) # The width
				addi $t1, $zero, 32
				sub $t1, $t1, $t4 # 32 - width
				# Random Generate the number with max $t1
				li $v0, 42
				li $a0, 0
				add $a1, $zero, $t1
				syscall
				# multiply by 4
				add $a0, $a0, $a0
				add $a0, $a0, $a0
				lw $t1, platformAddressThirdLast
				add $t1, $t1, $a0
			
				la $t4, platformOthers
				sw $t1, 16($t4)
				j endFinalUpdate
     		
     		updatingBreakPlatform2:
  				# Update the platform and exit
   				la $t4, platformOthers
   				lw $t1, 16($t4)
   				addi $t1, $t1, 5120
   				sw $t1, 16($t4)
   				j endFinalUpdate
  
  		endUpdateBreakPlatform2:
		
		
		endFinalUpdate:
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			jr $t0
		
			
	initializePlatforms:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		la $t1, platformOthers
		la $t6, platformWidths # Width for all platforms
		la $t8, platformTypes 
		la $t0, platformSpeed
		# RandomPlatform will use t2
		add $t3, $zero, $zero
		addi $t4, $zero, 6
		add $t5, $zero, $zero
		lw $t7, platformWidth # Default width
		init_platform_loop:
			beq $t3, $t4, init_platform_end # Exit the loop	
			jal randomPlatform # Generate the random platform, will store in v0
			add $v0, $v0, $t5 # Add v0 to 1280 or not for different levels 
			addi $t5, $t5, 1280 # Update levels 
			sw $v0, 0($t1) # Save into the register 
			addi $t1, $t1, 4 # Update for next address 
			addi $t3, $t3, 1
			
			# Update width
			sw $t7, 0($t6)
			addi $t6, $t6, 4
			
			# Update type
			li $v0, 42
			li $a0, 0
			li $a1, 20
			syscall
			addi $a0, $a0, -15
			
			bgtz $a0, add_move_type
		
			addi $a0, $a0, 5
			bgtz $a0, add_break_type
			
			# Normal type
			add $t9, $zero, $zero # Type
			sw $t9, 0($t8)
			addi $t8, $t8, 4
			add $t9, $zero, $zero # Speed 
			sw $t9, 0($t0)
			addi $t0, $t0, 4 # Continue the loop
			j init_platform_loop
			
			add_break_type:
				addi $t9, $zero, 1 # Type 
				sw $t9, 0($t8)
				addi $t8, $t8, 4
				add $t9, $zero, $zero # Speed
				sw $t9, 0($t0)
				addi $t0, $t0, 4
				j init_platform_loop
				
			add_move_type:
				addi $t9, $zero, 1 # Type
				sw $t9, 0($t8)
				addi $t8, $t8, 4
				add $t9, $zero, $zero # Speed
				sw $t9, 0($t0)
				addi $t0, $t0, 4
				j init_platform_loop
				
			# Update platform 
			j init_platform_loop
		init_platform_end:
			# We need to update the last width for bottom one
			sw $t7, 0($t6)
			
			# The bottom platform must be normal
			add $t9, $zero, $zero
			sw $t9, 0($t8)
			
			# Update its speed
			lw $t0, 0($sp)
			addi $sp, $sp, 4
			jr $t0
			
			
	updatePlatforms:		
		# Push $ra into stack 
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		jal sleepProgram2
		
	    jal drawBackground
		
		lw $t1, charAddress
		addi $t1, $t1, 1280
		sw $t1, charAddress 
		
		la $t1, platformOthers
		
		# lw $a0, backgroundColour
		# lw $a2, platformAddress
		# jal drawPlatformNormal
		jal cleanPlatforms
		
		la $t1, platformOthers
		# update bottom platform
		lw $t3, 20($t1)
		addi $t3, $t3, 1280
		sw $t3, platformAddress # 0 to bottom
		
		# 1 to 0
		lw $t3, 16($t1)
		addi, $t3, $t3, 1280
		sw $t3, 20($t1)
		
		# 2 to 1
		lw $t3, 12($t1)
		addi, $t3, $t3, 1280
		sw $t3, 16($t1)
		
		# 3 to 2
		lw $t3, 8($t1)
		addi, $t3, $t3, 1280
		sw $t3, 12($t1)
		
		# 4 to 5
	 	lw $t3, 4($t1)
		addi, $t3, $t3, 1280
		sw $t3, 8($t1)
		
		# 5 to 6
		lw $t3, 0($t1)
		addi, $t3, $t3, 1280
		sw $t3, 4($t1)
		
		# RandomPlatform will use t2
		jal randomPlatform # For the top, will store in v0
		# 6 to new
		sw $v0, 0($t1)
		
		# Also update width
		jal updateWidth
		jal updateTypes
		
		# Pull from stack
		lw $t9, 0($sp)
		addi $sp, $sp, 4
		jr $t9
		
		
	updateWidth:
		# we should update all width
	
		la $t1, platformWidths
		# update bottom platform width
		lw $t3, 20($t1)
		sw $t3, 24($t1)
	
		lw $t3, 16($t1)
		sw $t3, 20($t1)
		
		lw $t3, 12($t1)
		sw $t3, 16($t1)
		
		lw $t3, 8($t1)
		sw $t3, 12($t1)
		
		lw $t3, 4($t1)
		sw $t3, 8($t1)
		
		lw $t3, 0($t1)
		sw $t3, 4($t1)
		
		# Update the top most 
	
		lw $t0, score
		addi $t0, $t0, -20
		# Second level, width to 5
		bgtz $t0, update_to_5
		
		# First level, width to 7
		addi $t0, $t0, 10
		bgtz $t0, update_to_7
		
		# else:
		addi $t4, $zero 11 
		sw $t4, 0($t1)
		j end_update_width
		
		update_to_5:
			addi $t4, $zero, 5
			sw $t4, 0($t1)
			j end_update_width
			
		update_to_7:
			addi $t4, $zero, 7
			sw $t4, 0($t1)
			j end_update_width
			
		end_update_width:
			jr $ra
			
	updateTypes:
		# we should update all width
		
		# We will update speed over here too since they are similar stuff
	
		la $t1, platformTypes
		la $t4, platformSpeed 
		# update bottom platform width
		lw $t3, 20($t1)
		sw $t3, 24($t1)
		lw $t3, 20($t4)
		sw $t3, 24($t4)
	
		lw $t3, 16($t1)
		sw $t3, 20($t1)
		lw $t3, 16($t4)
		sw $t3, 20($t4)
		
		lw $t3, 12($t1)
		sw $t3, 16($t1)
		lw $t3, 12($t4)
		sw $t3, 16($t4)
		
		lw $t3, 8($t1)
		sw $t3, 12($t1)
		lw $t3, 8($t4)
		sw $t3, 12($t4)
	
		lw $t3, 4($t1)
		sw $t3, 8($t1)
		lw $t3, 4($t4)
		sw $t3, 8($t4)
		
		lw $t3, 0($t1)
		sw $t3, 4($t1)
		lw $t3, 0($t4)
		sw $t3, 4($t4)
		
		# Update the top most 
		# Update type
		li $v0, 42
		li $a0, 0
		li $a1, 20
		syscall
		addi $a0, $a0, -17
		bgtz $a0, add_update_type_shifting
		
		addi $a0, $a0, 3
		bgtz $a0, add_update_type_move
		
		addi $a0, $a0, 3
		bgtz $a0, add_update_type_break
		# t9 is been used
		# Normal type
		add $t8, $zero, $zero
		sw $t8, 0($t1)
		la $t0, platformSpeed
		add $t9, $zero, $zero
		sw $t9, 0($t0)
		addi $t0, $t0, 4
		j end_update_type
			
		add_update_type_break:
			addi $t8, $zero, 1
			sw $t8, 0($t1)
			la $t0, platformSpeed
			add $t9, $zero, $zero
			sw $t9, 0($t0)
			addi $t0, $t0, 4
			j end_update_type
			
		add_update_type_move:
			addi $t8, $zero, 2
			sw $t8, 0($t1) # Type 
			la $t0, platformSpeed
			addi $t9, $zero, 4 # Speed
			sw $t9, 0($t0)
			addi $t0, $t0, 4
			j end_update_type
			
		add_update_type_shifting:
			addi $t8, $zero, 3
			sw $t8, 0($t1) # Type
			la $t0, platformSpeed
			add $t9, $zero, $zero # Speed
			sw $t9, 0($t0)
			addi $t0, $t0, 4
			j end_update_type
		
		end_update_type:
			jr $ra
			
		
	drawPlatforms:
		addi $sp, $sp, -4
  		sw $ra, 0($sp)
  
		
		la $a1, platformWidths
		addi, $a1, $a1, 24
		lw $a1, 0($a1)
		lw $a0, platformAddress
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 24($t0)
		bgtz $t0, if_not_normal_0
		jal drawFancierNormalPlatform
		j end_normal_0
		
		if_not_normal_0:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_0
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_0
			jal drawFancierBreakPlatform
			j end_normal_0
			
		draw_shifting_platform_0:
			jal drawFancierShiftingPlatform
			j end_normal_0
		
		draw_move_platform_0:
			lw $t3, platformAddress # The address
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_0 
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 24($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128 
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_0
			# Then jump to not changing the speed 
			j not_change_speed_0
			
			change_speed_positive_0:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 24($t6) # The speed 
				j not_change_speed_0
				
			change_speed_negative_0:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 24($t6) # The speed 
				j not_change_speed_0
			
			
		not_change_speed_0:
			la $t6, platformSpeed
			lw $t6, 24($t6)
			
			# Before update address, we need to clear the previous address
			lw $a0, platformAddress
			jal cleanFancierNormalPlatform
			
			lw $t3, platformAddress
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, platformAddress
			lw $a0, platformAddress
			jal drawFancierMovePlatform
			j end_normal_0
			
		end_normal_0:
############################################################		
		# Draw the platforms 
		la $a1, platformWidths
		addi, $a1, $a1, 0
		lw $a1, 0($a1)
		lw $a0, platformOthers
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 0($t0)
		bgtz $t0, if_not_normal_1
		jal drawFancierNormalPlatform
		j end_normal_1
		
		if_not_normal_1:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_1
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_1
			jal drawFancierBreakPlatform
			j end_normal_1
			
		draw_shifting_platform_1:
			jal drawFancierShiftingPlatform
			j end_normal_1
			
		draw_move_platform_1: # Top most 
			la $t3, platformOthers 
			lw $t3, 0($t3)
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_1 
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 0($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128, 8 because additional 4 for offset
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_1
			# Then jump to not changing the speed 
			j not_change_speed_1
		
			change_speed_positive_1:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 0($t6) # The speed 
				j not_change_speed_1
				
			change_speed_negative_1:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 0($t6) # The speed 
				j not_change_speed_1
			
			
		not_change_speed_1:
			la $t6, platformSpeed
			lw $t6, 0($t6)
			
			la $t3, platformOthers
			lw $t3, 0($t3)
			# Before update address, we need to clear the previous address
			add $a0, $zero, $t3
			jal cleanFancierNormalPlatform
			
			la $t4, platformOthers
			lw $t3, 0($t4)
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, 0($t4)
			la $t4, platformOthers
			lw $a0, 0($t4)
			jal drawFancierMovePlatform
			
		end_normal_1:
############################################################
		la $a1, platformWidths
		addi, $a1, $a1, 4
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 4
		lw $a0, 0($a0)
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 4($t0)
		bgtz $t0, if_not_normal_2
		jal drawFancierNormalPlatform
		j end_normal_2
		if_not_normal_2:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_2
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_2
			jal drawFancierBreakPlatform
			j end_normal_2
			
		draw_shifting_platform_2:
			jal drawFancierShiftingPlatform
			j end_normal_2
		
		draw_move_platform_2:
			la $t3, platformOthers 
			lw $t3, 4($t3)
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_2
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 4($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128, 8 because additional 4 for offset
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_2
			# Then jump to not changing the speed 
			j not_change_speed_2
		
			change_speed_positive_2:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 4($t6) # The speed 
				j not_change_speed_2
				
			change_speed_negative_2:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 4($t6) # The speed 
				j not_change_speed_2
			
			
		not_change_speed_2:
			la $t6, platformSpeed
			lw $t6, 4($t6)
			
			la $t3, platformOthers
			lw $t3, 4($t3)
			# Before update address, we need to clear the previous address
			add $a0, $zero, $t3
			jal cleanFancierNormalPlatform
			
			la $t4, platformOthers
			lw $t3, 4($t4)
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, 4($t4)
			la $t4, platformOthers
			lw $a0, 4($t4)
			jal drawFancierMovePlatform
			
		end_normal_2:
############################################################	
		la $a1, platformWidths
		addi, $a1, $a1, 8
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 8
		lw $a0, 0($a0)
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 8($t0)
		bgtz $t0, if_not_normal_3
		jal drawFancierNormalPlatform
		j end_normal_3
		if_not_normal_3:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_3
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_3
			jal drawFancierBreakPlatform
			j end_normal_3
			
		draw_shifting_platform_3:
			jal drawFancierShiftingPlatform
			j end_normal_3
			
		draw_move_platform_3:
			jal drawFancierMovePlatform
			la $t3, platformOthers 
			lw $t3, 8($t3)
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_3
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 8($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128, 8 because additional 4 for offset
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_3
			# Then jump to not changing the speed 
			j not_change_speed_3
		
			change_speed_positive_3:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 8($t6) # The speed 
				j not_change_speed_3
				
			change_speed_negative_3:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 8($t6) # The speed 
				j not_change_speed_3
			
			
		not_change_speed_3:
			la $t6, platformSpeed
			lw $t6, 8($t6)
			
			la $t3, platformOthers
			lw $t3, 8($t3)
			# Before update address, we need to clear the previous address
			add $a0, $zero, $t3
			jal cleanFancierNormalPlatform
			
			la $t4, platformOthers
			lw $t3, 8($t4)
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, 8($t4)
			la $t4, platformOthers
			lw $a0, 8($t4)
			jal drawFancierMovePlatform

		end_normal_3:
############################################################	
		la $a1, platformWidths
		addi, $a1, $a1, 12
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 12
		lw $a0, 0($a0)
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 12($t0)
		bgtz $t0, if_not_normal_4
		jal drawFancierNormalPlatform
		j end_normal_4
		if_not_normal_4:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_4
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_4
			jal drawFancierBreakPlatform
			j end_normal_4
			
		draw_shifting_platform_4:
			jal drawFancierShiftingPlatform
			j end_normal_4
			
		draw_move_platform_4:
			jal drawFancierMovePlatform
			la $t3, platformOthers 
			lw $t3, 12($t3)
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_4
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 12($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128, 8 because additional 4 for offset
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_4
			# Then jump to not changing the speed 
			j not_change_speed_4
		
			change_speed_positive_4:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 12($t6) # The speed 
				j not_change_speed_4
				
			change_speed_negative_4:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 12($t6) # The speed 
				j not_change_speed_4
			
			
		not_change_speed_4:
			la $t6, platformSpeed
			lw $t6, 12($t6)
			
			la $t3, platformOthers
			lw $t3, 12($t3)
			# Before update address, we need to clear the previous address
			add $a0, $zero, $t3
			jal cleanFancierNormalPlatform
			
			la $t4, platformOthers
			lw $t3, 12($t4)
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, 12($t4)
			la $t4, platformOthers
			lw $a0, 12($t4)
			jal drawFancierMovePlatform
			
		end_normal_4:
############################################################
		la $a1, platformWidths
		addi, $a1, $a1, 16
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 16
		lw $a0, 0($a0)
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 16($t0)
		bgtz $t0, if_not_normal_5
		jal drawFancierNormalPlatform
		j end_normal_5
		if_not_normal_5:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_5
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_5
			jal drawFancierBreakPlatform
			j end_normal_5
			
		draw_shifting_platform_5:
			jal drawFancierShiftingPlatform
			j end_normal_5
			
		draw_move_platform_5:
			jal drawFancierMovePlatform
			la $t3, platformOthers 
			lw $t3, 16($t3)
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_5
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 16($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128, 8 because additional 4 for offset
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_5
			# Then jump to not changing the speed 
			j not_change_speed_5
		
			change_speed_positive_5:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 16($t6) # The speed 
				j not_change_speed_5
				
			change_speed_negative_5:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 16($t6) # The speed 
				j not_change_speed_5
			
			
		not_change_speed_5:
			la $t6, platformSpeed
			lw $t6, 16($t6)
			
			la $t3, platformOthers
			lw $t3, 16($t3)
			# Before update address, we need to clear the previous address
			add $a0, $zero, $t3
			jal cleanFancierNormalPlatform
			
			la $t4, platformOthers
			lw $t3, 16($t4)
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, 16($t4)
			la $t4, platformOthers
			lw $a0, 16($t4)
			jal drawFancierMovePlatform
		end_normal_5:
############################################################		
		la $a1, platformWidths
		addi, $a1, $a1, 20
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 20
		lw $a0, 0($a0)
		# Check for type so which function to call
		la $t0, platformTypes
		lw $t0, 20($t0)
		bgtz $t0, if_not_normal_6
		jal drawFancierNormalPlatform
		j end_normal_6
		if_not_normal_6:
			addi $t0, $t0, -2
			bgtz $t0, draw_shifting_platform_6
			addi $t0, $t0, 1
			bgtz $t0, draw_move_platform_6
			jal drawFancierBreakPlatform
			j end_normal_6
			
		draw_shifting_platform_6:
			jal drawFancierShiftingPlatform
			j end_normal_6
			
		draw_move_platform_6:
			jal drawFancierMovePlatform
			la $t3, platformOthers 
			lw $t3, 20($t3)
			addi $t4, $zero, 128 # Check for if the platform is on the left side 
			div $t3, $t4
			mfhi $t5
			beq $t5, $zero, change_speed_positive_6
			# Check for right side
			# If we add platform by its width + 4 and then divide by 128, then set velocity to -4
			
			la $t4, platformWidths
			lw $t4, 20($t4)
			add $t4, $t4, $t4
			add $t4, $t4, $t4 # So it will be multiplied by 4
			add $t5, $t3, $t4
			addi $t5, $t5, 4 # Then check for divisible by 128, 8 because additional 4 for offset
			addi $t6, $zero, 128
			div $t5, $t6 # Divide by 128
			mfhi $t6 # Check for the remainder
			
			beq $t6, $zero, change_speed_negative_6
			# Then jump to not changing the speed 
			j not_change_speed_6
		
			change_speed_positive_6:
				la $t6, platformSpeed
				addi $t7, $zero, 4
				sw $t7, 20($t6) # The speed 
				j not_change_speed_6
				
			change_speed_negative_6:
				la $t6, platformSpeed
				addi $t7, $zero, -4
				sw $t7, 20($t6) # The speed 
				j not_change_speed_6
			
			
		not_change_speed_6:
			la $t6, platformSpeed
			lw $t6, 20($t6)
			
			la $t3, platformOthers
			lw $t3, 20($t3)
			# Before update address, we need to clear the previous address
			add $a0, $zero, $t3
			jal cleanFancierNormalPlatform
			
			la $t4, platformOthers
			lw $t3, 20($t4)
			add $t3, $t3, $t6 # Update the address
			# Save the address
			sw $t3, 20($t4)
			la $t4, platformOthers
			lw $a0, 20($t4)
			jal drawFancierMovePlatform
		end_normal_6:
		
		lw $t9, 0($sp)
  		addi $sp, $sp, 4
		jr $t9
############################################################	
	moveCharacterLeft:
		lw $t0, charAddress
		add $t2, $zero, 128
		checkCharacterLeft:
			add $t4, $zero, $t0
			addi $t4, $t4, -268468224
			divu $t1, $t4, $t2 # Divide by character address / 128 to see if it besides the left side wall
			mfhi $t3 # Remainder
			beq $t3, $zero, endCheckCharacterLeft
			# If not then move the character to the left
			addi $t0, $t0, -8
			sw $t0, charAddress
		endCheckCharacterLeft:
			jr $ra
			
	moveCharacterRight:
		lw $t0, charAddress
		add $t2, $zero, 128
		checkCharacterRight:
			add $t4, $zero, $t0
			addi $t4, $t4, 40 # Add 4 to move to the left side
			addi $t4, $t4, -268468224
			divu $t1, $t4, $t2 # Divide by character address / 128 to see if it besides the left side wall
			mfhi $t3 # Remainder
			beq $t3, $zero, endCheckCharacterRight
			# If not then move the character to the left
			addi $t0, $t0, 8
			sw $t0, charAddress
		endCheckCharacterRight:
			jr $ra
			
			
	drawFancierNormalPlatform:
		lw $t0, colourGreenDark
		lw $t1, colourBrown
		# A0 will be address
		add $t2, $zero, $a0
		# A1 will be width
		add $t4, $zero, $a1
		
		# Width == 11
		addi $t3, $zero, 11
		beq $t3, $t4, draw_fancier_normal_platform_11
		addi $t3, $zero, 7
		beq $t3, $t4, draw_fancier_normal_platform_7
		addi $t3, $zero, 5
		beq $t3, $t4, draw_fancier_normal_platform_5
		# j exit_draw_fancier_normal
		
		draw_fancier_normal_platform_11:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t0, 0($t2)
			sw $t1, 4($t2)
			sw $t0, 8($t2)
			sw $t1, 12($t2) 
			sw $t0, 16($t2)
			sw $t1, 20($t2)
			sw $t0, 24($t2)
			sw $t1, 28($t2)
			sw $t0, 32($t2)
			sw $t1, 36($t2)
			sw $t0, 40($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2)
			sw $t1, 16($t2)
			sw $t1, 20($t2)
			sw $t1, 24($t2)
			sw $t1, 28($t2)
			sw $t1, 32($t2)
			sw $t1, 36($t2)
			j exit_draw_fancier_normal
			
		draw_fancier_normal_platform_7:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t0, 0($t2)
			sw $t1, 4($t2)
			sw $t0, 8($t2)
			sw $t1, 12($t2) 
			sw $t0, 16($t2)
			sw $t1, 20($t2)
			sw $t0, 24($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2)
			sw $t1, 16($t2)
			sw $t1, 20($t2)
			j exit_draw_fancier_normal
			
		draw_fancier_normal_platform_5:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t0, 0($t2)
			sw $t1, 4($t2)
			sw $t0, 8($t2)
			sw $t1, 12($t2) 
			sw $t0, 16($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2)
			
		exit_draw_fancier_normal:
			jr $ra
			
	cleanFancierNormalPlatform:
		addi $sp, $sp, -4
  		sw $ra, 0($sp)
		lw $t0, backgroundColour
		# A0 will be address
		add $t2, $zero, $a0
		# A1 will be width
		
		# Width == 11
		addi $t3, $zero, 11
		beq $t3, $a1, clean_fancier_normal_platform_11
		addi $t3, $zero, 7
		beq $t3, $a1, clean_fancier_normal_platform_7
		addi $t3, $zero, 5
		beq $t3, $a1, clean_fancier_normal_platform_5
		# j exit_clean_fancier_normal
		
		clean_fancier_normal_platform_11:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			j exit_clean_fancier_normal
			
		clean_fancier_normal_platform_7:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2)
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			j exit_clean_fancier_normal
			
		clean_fancier_normal_platform_5:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2)
			
		exit_clean_fancier_normal:
		
		jal drawStars
		lw $t0, 0($sp)
   		addi $sp, $sp, 4
   		jr $t0
		
	
			
			
	cleanPlatforms:
		la $a1, platformWidths
		addi, $a1, $a1, 24
		lw $a1, 0($a1)
		add $t9, $zero, $ra
		
		lw $a0, platformAddress
		jal cleanFancierNormalPlatform
		
		la $a1, platformWidths
		addi, $a1, $a1, 0
		lw $a1, 0($a1)
		# Draw the platforms 
		lw $a0, platformOthers
		jal cleanFancierNormalPlatform
		
		la $a1, platformWidths
		addi, $a1, $a1, 4
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 4
		lw $a0, 0($a0)
		jal cleanFancierNormalPlatform
		
		la $a1, platformWidths
		addi, $a1, $a1, 8
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 8
		lw $a0, 0($a0)
		jal cleanFancierNormalPlatform
		
		la $a1, platformWidths
		addi, $a1, $a1, 12
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 12
		lw $a0, 0($a0)
		jal cleanFancierNormalPlatform
	
		la $a1, platformWidths
		addi, $a1, $a1, 16
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 16
		lw $a0, 0($a0)
		jal cleanFancierNormalPlatform
		
		la $a1, platformWidths
		addi, $a1, $a1, 20
		lw $a1, 0($a1)
		la $a0, platformOthers
		addi, $a0, $a0, 20
		lw $a0, 0($a0)
		jal cleanFancierNormalPlatform
		
		jr $t9
	
	drawFancierShiftingPlatform:
		lw $t0, colourWhite
		lw $t1, colourGray
		# A0 will be address
		add $t2, $zero, $a0
		# A1 will be width
		add $t4, $zero, $a1
		
		# Width == 11
		addi $t3, $zero, 11
		beq $t3, $t4, draw_fancier_shifting_platform_11
		addi $t3, $zero, 7
		beq $t3, $t4, draw_fancier_shifting_platform_7
		addi $t3, $zero, 5
		beq $t3, $t4, draw_fancier_shifting_platform_5
		# j exit_draw_fancier_normal
		
		draw_fancier_shifting_platform_11:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2) 
			sw $t1, 16($t2)
			sw $t1, 20($t2)
			sw $t1, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2)
			sw $t1, 16($t2)
			sw $t1, 20($t2)
			sw $t1, 24($t2)
			sw $t1, 28($t2)
			sw $t1, 32($t2)
			sw $t1, 36($t2)
			j exit_draw_fancier_shifting
			
		draw_fancier_shifting_platform_7:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2)
			sw $t1, 16($t2)
			sw $t1, 20($t2)
			j exit_draw_fancier_shifting
			
		draw_fancier_shifting_platform_5:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t1, 8($t2)
			sw $t1, 12($t2)
			
		exit_draw_fancier_shifting:
			jr $ra
############################################
	drawFancierMovePlatform:
		lw $t1, colourPurpleLight
		lw $t0, colourPurpleMedium
		lw $t5, colourPurpleDark
		lw $t6, colourBlack
		# A0 will be address
		add $t2, $zero, $a0
		# A1 will be width
		add $t4, $zero, $a1
		
		# Width == 11
		addi $t3, $zero, 11
		beq $t3, $t4, draw_fancier_move_platform_11
		addi $t3, $zero, 7
		beq $t3, $t4, draw_fancier_move_platform_7
		addi $t3, $zero, 5
		beq $t3, $t4, draw_fancier_move_platform_5
		# j exit_draw_fancier_normal
		
		draw_fancier_move_platform_11:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t5, 4($t2)
			sw $t5, 8($t2)
			sw $t5, 12($t2) 
			sw $t5, 16($t2)
			sw $t5, 20($t2)
			sw $t5, 24($t2)
			sw $t1, 28($t2)
			sw $t1, 32($t2)
			sw $t6, 36($t2)
			sw $t1, 40($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t5, 8($t2)
			sw $t5, 12($t2)
			sw $t5, 16($t2)
			sw $t0, 20($t2)
			sw $t1, 24($t2)
			sw $t1, 28($t2)
			sw $t1, 32($t2)
			sw $t1, 36($t2)
			j exit_draw_fancier_move
			
		draw_fancier_move_platform_7:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t5, 4($t2)
			sw $t5, 8($t2)
			sw $t5, 12($t2) 
			sw $t5, 16($t2)
			sw $t6, 20($t2)
			sw $t1, 24($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t5, 8($t2)
			sw $t5, 12($t2)
			sw $t0, 16($t2)
			sw $t1, 20($t2)
			j exit_draw_fancier_move
			
		draw_fancier_move_platform_5:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t5, 4($t2)
			sw $t5, 8($t2)
			sw $t6, 12($t2) 
			sw $t1, 16($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t5, 8($t2)
			sw $t1, 12($t2)
			
		exit_draw_fancier_move:
			jr $ra
	
#############################################		
	drawFancierBreakPlatform:
		lw $t1, colourBrownLight
		lw $t0, colourBrownDark
		lw $t5, colourBrown
		lw $t6, backgroundColour
		# A0 will be address
		add $t2, $zero, $a0
		# A1 will be width
		add $t4, $zero, $a1
		
		# Width == 11
		addi $t3, $zero, 11
		beq $t3, $t4, draw_fancier_break_platform_11
		addi $t3, $zero, 7
		beq $t3, $t4, draw_fancier_break_platform_7
		addi $t3, $zero, 5
		beq $t3, $t4, draw_fancier_break_platform_5
		# j exit_draw_fancier_normal
		
		draw_fancier_break_platform_11:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			sw $t0, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			sw $t0, 40($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t5, 4($t2)
			sw $t5, 8($t2)
			sw $t1, 12($t2) 
			sw $t5, 16($t2)
			sw $t6, 20($t2)
			sw $t6, 24($t2)
			sw $t5, 28($t2)
			sw $t5, 32($t2)
			sw $t1, 36($t2)
			sw $t5, 40($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2)
			sw $t6, 16($t2)
			sw $t6, 20($t2)
			sw $t0, 24($t2)
			sw $t1, 28($t2)
			sw $t0, 32($t2)
			sw $t0, 36($t2)
			j exit_draw_fancier_break
			
		draw_fancier_break_platform_7:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			sw $t0, 20($t2)
			sw $t0, 24($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t5, 4($t2)
			sw $t1, 8($t2)
			sw $t6, 12($t2) 
			sw $t5, 16($t2)
			sw $t1, 20($t2)
			sw $t5, 24($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t1, 4($t2)
			sw $t6, 8($t2)
			sw $t0, 12($t2)
			sw $t1, 16($t2)
			sw $t0, 20($t2)
			j exit_draw_fancier_break
			
		draw_fancier_break_platform_5:
			sw $t0, 0($t2)
			sw $t0, 4($t2)
			sw $t0, 8($t2)
			sw $t0, 12($t2) 
			sw $t0, 16($t2)
			# Second Line
			addi $t2, $t2, 128
			sw $t1, 0($t2)
			sw $t1, 4($t2)
			sw $t5, 8($t2)
			sw $t6, 12($t2) 
			sw $t5, 16($t2)
			# Third Line
			addi $t2, $t2, 128
			sw $t5, 4($t2)
			sw $t6, 8($t2)
			sw $t1, 12($t2)
			
		exit_draw_fancier_break:
			jr $ra
			
############################
	drawTitle:	
		lw $t0, displayAddress
  		lw $t1, colourYellowLight
  		lw $t2, colourYellowMedium
  		lw $t3, colourYellowDark
  		
  		addi $t0, $t0, 128 # To line 2
  		sw $t2, 28($t0)
  		sw $t2, 32($t0)
  		sw $t2, 48($t0)
  		sw $t2, 52($t0)
  		sw $t2, 64($t0)
  		sw $t2, 68($t0)
  		sw $t3, 72($t0)
  		sw $t3, 84($t0)
  		sw $t2, 100($t0)
  		sw $t2, 104($t0)
  		sw $t3, 108($t0) # End line 2 
  		
  		addi $t0, $t0, 128
  		sw $t2, 24($t0)
  		sw $t2, 36($t0)
  		sw $t3, 44($t0)
  		sw $t2, 56($t0)
  		sw $t2, 64($t0)
  		sw $t3, 76($t0)
  		sw $t2, 84($t0)
  		sw $t2, 100($t0) # End Line 3
  		
  		addi $t0, $t0, 128
  		sw $t2, 24($t0)
  		sw $t2, 36($t0)
  		sw $t2, 44($t0)
  		sw $t2, 56($t0)
  		sw $t2, 64($t0)
  		sw $t3, 76($t0)
  		sw $t2, 84($t0)
  		sw $t2, 100($t0) 
  		sw $t2, 104($t0)
  		sw $t3, 108($t0) # End line 4
  		
  		addi $t0, $t0, 128
  		sw $t3, 24($t0)
  		sw $t2, 36($t0)
  		sw $t2, 44($t0)
  		sw $t2, 56($t0)
  		sw $t1, 64($t0)
  		sw $t2, 76($t0)
  		sw $t2, 84($t0)
  		sw $t2, 100($t0) # End line 5
  		
  		addi $t0, $t0, 128
  		sw $t1, 28($t0)
  		sw $t2, 32($t0)
  		sw $t1, 48($t0)
  		sw $t2, 52($t0)
  		sw $t2, 64($t0)
  		sw $t3, 68($t0)
  		sw $t2, 72($t0)
  		sw $t1, 84($t0)
  		sw $t2, 88($t0)
  		sw $t3, 92($t0)
  		sw $t2, 100($t0)
  		sw $t2, 104($t0) 
  		sw $t3, 108($t0) # End line 6
  		
  		lw $t4, colourWhite
  		lw $t5, colourGray
  		# Draw the cloud
  		addi $t0, $t0, 128
  		sw $t4, 16($t0)
  		sw $t4, 20($t0)
  		sw $t4, 24($t0)
  		sw $t4, 28($t0)
  		sw $t4, 32($t0)
  		sw $t4, 36($t0)
  		sw $t4, 40($t0)
  		sw $t4, 44($t0)
  		sw $t4, 48($t0)
  		sw $t4, 52($t0)
  		sw $t4, 56($t0)
  		sw $t4, 60($t0)
  		sw $t4, 64($t0)
  		sw $t4, 68($t0)
  		sw $t4, 72($t0)
  		sw $t4, 76($t0)
  		sw $t4, 80($t0)
  		sw $t4, 84($t0)
  		sw $t4, 88($t0)
  		sw $t4, 92($t0)
  		sw $t4, 96($t0)
  		sw $t4, 100($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t5, 16($t0) 
  		sw $t5, 20($t0)
  		sw $t5, 24($t0)
  		sw $t5, 28($t0)
  		sw $t5, 32($t0)
  		sw $t5, 36($t0)
  		sw $t5, 40($t0)
  		sw $t5, 44($t0)
  		sw $t5, 48($t0)
  		sw $t5, 52($t0)
  		sw $t5, 56($t0)
  		sw $t5, 60($t0)
  		sw $t4, 64($t0)
  		sw $t4, 68($t0)
  		sw $t4, 72($t0)
  		sw $t4, 76($t0)
  		sw $t4, 80($t0)
  		sw $t4, 84($t0)
  		sw $t4, 88($t0)
  		sw $t4, 92($t0)
  		sw $t4, 96($t0)
  		sw $t4, 100($t0)
  		addi $t0, $t0, 128
  		sw $t5, 20($t0)
  		sw $t5, 24($t0)
  		sw $t5, 28($t0)
  		sw $t5, 32($t0)
  		sw $t5, 36($t0)
  		sw $t5, 40($t0)
  		sw $t5, 44($t0)
  		sw $t5, 48($t0)
  		sw $t5, 52($t0)
  		sw $t5, 56($t0)
  		sw $t5, 60($t0)
  		sw $t5, 64($t0)
  		sw $t5, 68($t0)
  		sw $t5, 72($t0)
  		sw $t5, 76($t0)
  		sw $t5, 80($t0)
  		sw $t5, 84($t0)
  		sw $t5, 88($t0)
  		sw $t5, 92($t0)
  		sw $t5, 96($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t3, 4($t0)
  		sw $t2, 8($t0)
  		sw $t2, 12($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t2, 4($t0)
  		sw $t2, 16($t0)
  		sw $t2, 108($t0)
  		sw $t3, 112($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t1, 4($t0)
  		sw $t2, 16($t0)
  		sw $t1, 104($t0)
  		sw $t2, 116($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t2, 4($t0)
  		sw $t3, 16($t0)
  		sw $t3, 40($t0)
  		sw $t1, 44($t0)
  		sw $t2, 48($t0)
  		sw $t1, 56($t0)
  		sw $t2, 60($t0)
  		sw $t1, 68($t0)
  		sw $t2, 72($t0)
  		sw $t2, 84($t0)
  		sw $t2, 92($t0)
  		sw $t2, 104($t0)
  		sw $t2, 116($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t2, 4($t0)
  		sw $t2, 8($t0)
  		sw $t1, 12($t0)
  		sw $t2, 44($t0)
  		sw $t1, 60($t0)
  		sw $t2, 68($t0)
  		sw $t3, 80($t0)
  		sw $t1, 88($t0)
  		sw $t2, 96($t0)
  		sw $t2, 104($t0)
  		sw $t2, 108($t0)
  		sw $t1, 112($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t1, 44($t0)
  		sw $t3, 60($t0)
  		sw $t2, 68($t0)
  		sw $t1, 80($t0)
  		sw $t2, 96($t0)
  		sw $t2, 104($t0)
		addi $t0, $t0, 128 # Next line
  		sw $t2, 44($t0)
  		sw $t2, 60($t0)
  		sw $t1, 68($t0)
  		sw $t2, 80($t0)
  		sw $t2, 96($t0)
  		addi $t0, $t0, 128 # Next line
  		sw $t1, 36($t0)
  		sw $t3, 40($t0)
  		sw $t2, 44($t0)
  		sw $t1, 60($t0)
  		sw $t2, 64($t0)
  		sw $t2, 68($t0)
  		sw $t2, 80($t0)
  		sw $t3, 96($t0)
  		addi $t0, $t0, 128 # Draw the grass
  		lw $t4, colourGreenDark
  		lw $t5, colourBrown
  		sw $t4, 36($t0)
  		sw $t4, 40($t0)
  		sw $t4, 44($t0)
  		sw $t4, 48($t0)
  		sw $t4, 52($t0)
  		sw $t4, 56($t0)
  		sw $t4, 60($t0)
  		sw $t4, 64($t0)
  		sw $t4, 68($t0)
  		sw $t4, 72($t0)
  		sw $t4, 76($t0)
  		sw $t4, 80($t0)
  		sw $t4, 84($t0)
  		sw $t4, 88($t0)
  		sw $t4, 92($t0)
  		sw $t4, 96($t0)
  		sw $t4, 100($t0)
  		sw $t4, 104($t0)
  		sw $t4, 108($t0)
  		sw $t4, 112($t0)
  		sw $t4, 116($t0)
  		addi $t0, $t0, 128 # Nextline
  		sw $t4, 36($t0)
  		sw $t5, 40($t0)
  		sw $t4, 44($t0)
  		sw $t5, 48($t0)
  		sw $t4, 52($t0)
  		sw $t5, 56($t0)
  		sw $t4, 60($t0)
  		sw $t5, 64($t0)
  		sw $t4, 68($t0)
  		sw $t5, 72($t0)
  		sw $t4, 76($t0)
  		sw $t5, 80($t0)
  		sw $t4, 84($t0)
  		sw $t5, 88($t0)
  		sw $t4, 92($t0)
  		sw $t5, 96($t0)
  		sw $t4, 100($t0)
  		sw $t5, 104($t0)
  		sw $t4, 108($t0)
  		sw $t5, 112($t0)
  		sw $t4, 116($t0)
  		addi $t0, $t0, 128 # Nextline
  		sw $t5, 40($t0)
  		sw $t5, 44($t0)
  		sw $t5, 48($t0)
  		sw $t5, 52($t0)
  		sw $t5, 56($t0)
  		sw $t5, 60($t0)
  		sw $t5, 64($t0)
  		sw $t5, 68($t0)
  		sw $t5, 72($t0)
  		sw $t5, 76($t0)
  		sw $t5, 80($t0)
  		sw $t5, 84($t0)
  		sw $t5, 88($t0)
  		sw $t5, 92($t0)
  		sw $t5, 96($t0)
  		sw $t5, 100($t0)
  		sw $t5, 104($t0)
  		sw $t5, 108($t0)
  		sw $t5, 112($t0)
  		
  		jr $ra
  		
 	drawStartText:
 		
 		lw $t0, displayAddress
 		lw $t1, colourBlueDark
 		addi $t0, $t0, 3072
 		# J : LEFT
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 92($t0)
 		sw $t1, 96($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 16($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 72($t0)
 		sw $t1, 92($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 16($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 92($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 16($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 72($t0)
 		sw $t1, 92($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 92($t0)
 		# K : RIGHT
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 104($t0)
 		sw $t1, 108($t0)
 		sw $t1, 112($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 20($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 88($t0)
 		sw $t1, 92($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 20($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		# S : START
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t1, 88($t0)
 		sw $t1, 92($t0)
 		sw $t1, 104($t0)
 		sw $t1, 108($t0)
 		sw $t1, 112($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 92($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 20($t0)
 		sw $t1, 28($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 72($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 108($t0)
 		# E : EXIT
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 88($t0)
 		sw $t1, 92($t0)
 		sw $t1, 96($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t1, 92($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 76($t0)
 		sw $t1, 92($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t1, 92($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 20($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 92($t0)
 		jr $ra 
 		
 	drawCharacterAndBottomPart:
 		addi $sp, $sp, -4
  		sw $ra, 0($sp)
  		
 		lw $t0, displayAddress

 		addi $t0, $t0, 6912
 		addi $t0, $t0, 12
 		sw $t0, charAddress # Temporaary change its position 
 		jal drawCharacter # Draw the character on the bottom 
 		
 		addi $t1, $zero, 268474920 # charAddress default value
 		sw $t1, charAddress # Save it back 
 		
 		lw $t0, displayAddress
		
		# Name and heart 
		lw $t1, colourPinkDark
 		lw $t2, colourBlueDark
 		addi $t0, $t0, 6912
 		addi $t0, $t0, 128 # New line
 		sw $t1, 64($t0)
 		sw $t1, 80($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 68($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 84($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 68($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 84($t0)
 		sw $t2, 92($t0)
 		sw $t2, 108($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 64($t0)
 		sw $t1, 68($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t2, 92($t0)
 		sw $t2, 108($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 68($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t2, 96($t0)
 		sw $t2, 104($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 72($t0)
 		sw $t2, 100($t0)
 		sw $t2, 112($t0)
 		sw $t2, 124($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t2, 100($t0)
 		sw $t2, 112($t0)
 		sw $t2, 124($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t2, 100($t0)
 		sw $t2, 112($t0)
 		sw $t2, 124($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t2, 100($t0)
 		sw $t2, 116($t0)
 		sw $t2, 120($t0)
 		
 		
 		
 		# Pull from stack
		lw $t9, 0($sp)
		addi $sp, $sp, 4
		jr $t9
		
###########################
	drawRestartText:
	lw $t0, displayAddress
 		lw $t1, colourBlueDark
 		addi $t0, $t0, 3072
 		# Game Over
 		sw $t1, 8($t0)
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 28($t0)
 		sw $t1, 44($t0)
 		sw $t1, 52($t0)
 		sw $t1, 64($t0)
 		sw $t1, 68($t0)
 		sw $t1, 72($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 28($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		sw $t1, 68($t0)
 		sw $t1, 72($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 8($t0)
 		sw $t1, 16($t0)
 		sw $t1, 24($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 8($t0)
 		sw $t1, 12($t0)
 		sw $t1, 16($t0)
 		sw $t1, 24($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 64($t0)
 		sw $t1, 68($t0)
 		sw $t1, 72($t0)
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
		sw $t1, 76($t0)
		sw $t1, 84($t0)
		sw $t1, 92($t0)
		sw $t1, 96($t0)
		sw $t1, 100($t0)
		sw $t1, 108($t0)
		sw $t1, 112($t0)
		addi $t0, $t0, 128 # Next Line
 		sw $t1, 56($t0)
 		sw $t1, 68($t0)
		sw $t1, 76($t0)
		sw $t1, 84($t0)
		sw $t1, 92($t0)
		sw $t1, 108($t0)
		sw $t1, 116($t0)
		addi $t0, $t0, 128 # Next Line
 		sw $t1, 56($t0)
 		sw $t1, 68($t0)
		sw $t1, 76($t0)
		sw $t1, 84($t0)
		sw $t1, 92($t0)
		sw $t1, 96($t0)
		sw $t1, 100($t0)
		sw $t1, 108($t0)
		sw $t1, 112($t0)
		addi $t0, $t0, 128 # Next Line
 		sw $t1, 56($t0)
 		sw $t1, 68($t0)
		sw $t1, 76($t0)
		sw $t1, 84($t0)
		sw $t1, 92($t0)
		sw $t1, 108($t0)
		sw $t1, 116($t0)
		addi $t0, $t0, 128 # Next Line
		sw $t1, 60($t0)
 		sw $t1, 64($t0)
		sw $t1, 80($t0)
		sw $t1, 92($t0)
		sw $t1, 96($t0)
		sw $t1, 100($t0)
		sw $t1, 108($t0)
		sw $t1, 116($t0)
		# S : RESTART
		addi $t0, $t0, 128 # Next Line
		addi $t0, $t0, 128 # Next Line
		addi $t0, $t0, 128 # Next Line
		sw $t1, 0($t0)
 		sw $t1, 4($t0)
 		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 92($t0)
 		sw $t1, 104($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
		sw $t1, 0($t0)
		sw $t1, 16($t0)
 		sw $t1, 24($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 56($t0)
 		sw $t1, 76($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 104($t0)
 		sw $t1, 112($t0)
 		addi $t0, $t0, 128 # Next Line
		sw $t1, 0($t0)
		sw $t1, 4($t0)
		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 28($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t1, 88($t0)
 		sw $t1, 92($t0)
 		sw $t1, 96($t0)
 		sw $t1, 104($t0)
 		sw $t1, 108($t0)
 		addi $t0, $t0, 128 # Next Line
		sw $t1, 8($t0)
		sw $t1, 16($t0)
 		sw $t1, 24($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 104($t0)
 		sw $t1, 112($t0)
 		addi $t0, $t0, 128 # Next Line
		sw $t1, 0($t0)
		sw $t1, 4($t0)
		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 44($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t1, 88($t0)
 		sw $t1, 96($t0)
 		sw $t1, 104($t0)
 		sw $t1, 112($t0)
 		
 		lw $t2, colourGreenDark
 		lw $t3, colourBrown
 		# E : EXIT 
 		addi $t0, $t0, 128 # Next Line
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 124($t0)
 		sw $t1, 120($t0)
 		sw $t1, 116($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 0($t0)
 		sw $t1, 4($t0)
 		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 28($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		sw $t1, 80($t0)
 		sw $t1, 120($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 0($t0)
 		sw $t1, 16($t0)
 		sw $t1, 24($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 76($t0)
 		sw $t1, 120($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 0($t0)
 		sw $t1, 4($t0)
 		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 28($t0)
 		sw $t1, 32($t0)
 		sw $t1, 44($t0)
 		sw $t1, 60($t0)
 		sw $t1, 76($t0)
 		sw $t1, 120($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 0($t0)
 		sw $t1, 16($t0)
 		sw $t1, 24($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 60($t0)
 		sw $t1, 76($t0)
 		sw $t2, 108($t0)
 		sw $t2, 112($t0)
 		sw $t2, 116($t0)
 		sw $t2, 120($t0)
 		sw $t2, 124($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t1, 0($t0)
 		sw $t1, 4($t0)
 		sw $t1, 8($t0)
 		sw $t1, 24($t0)
 		sw $t1, 28($t0)
 		sw $t1, 32($t0)
 		sw $t1, 40($t0)
 		sw $t1, 48($t0)
 		sw $t1, 56($t0)
 		sw $t1, 60($t0)
 		sw $t1, 64($t0)
 		sw $t1, 76($t0)
 		sw $t2, 108($t0)
 		sw $t3, 112($t0)
 		sw $t2, 116($t0)
 		sw $t3, 120($t0)
 		sw $t2, 124($t0)
 		addi $t0, $t0, 128 # Next Line
 		sw $t3, 112($t0)
 		sw $t3, 116($t0)
 		sw $t3, 120($t0)
 		sw $t3, 124($t0)
 		
 		jr $ra
 		
 		
drawCharacterAndBottomPartRestart:
 		addi $sp, $sp, -4
  		sw $ra, 0($sp)
  		
  		lw $t2, colourYellow
  		lw $t3, colourWhite
  		lw $t4 colourGray
  
  		# Update Character
  		lw $t0, displayAddress
  		addi $t0, $t0, 6528
  		sw $t2, 24($t0)
  		sw $t2, 28($t0)
  		sw $t2, 32($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t2, 16($t0)
  		sw $t2, 20($t0)
  		sw $t2, 36($t0)
  		sw $t2, 40($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t2, 12($t0)
  		sw $t2, 44($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t2, 16($t0)
  		sw $t2, 36($t0)
  		sw $t2, 40($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t3, 0($t0)
  		sw $t3, 4($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t4, 0($t0)
  		sw $t4, 4($t0)
  		sw $t3, 8($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t4, 0($t0)
  		sw $t4, 4($t0)
  		sw $t4, 8($t0)
  		sw $t3, 12($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t3, 0($t0)
  		sw $t3, 4($t0)
  		sw $t4, 8($t0)
  		sw $t3, 12($t0)
  		sw $t3, 28($t0)
  		sw $t3, 36($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t4, 0($t0)
  		sw $t4, 4($t0)
  		sw $t3, 8($t0)
  		sw $t3, 12($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t4, 0($t0)
  		sw $t4, 4($t0)
  		sw $t4, 8($t0)
  		sw $t3, 12($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t4, 8($t0)
  		sw $t3, 12($t0)
  		addi $t0, $t0, 128 # Next Line
  		sw $t3, 12($t0)
  		
  		
		# Broken heart 
		lw $t0, displayAddress
		lw $t1, backgroundColour

 		addi $t0, $t0, 6912
 		addi $t0, $t0, 128 # New line
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 68($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 72($t0)
 		sw $t1, 76($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 68($t0)
 		
 		addi $t0, $t0, 128 # New line
 		sw $t1, 72($t0)
 		
 		
 		
 		
 		# Pull from stack
		lw $t9, 0($sp)
		addi $sp, $sp, 4
		jr $t9
		
	# Details for background 
	drawStars:
		lw $t0, displayAddress
		lw $t1, colourGrayLight
		addi $t0, $t0, 128
		sw $t1, 72($t0)
		addi $t0, $t0, 384
		sw $t1, 16($t0)
		addi $t0, $t0, 896
		sw $t1, 108($t0)
		addi $t0, $t0, 768
		sw $t1, 16($t0)
		addi $t0, $t0, 256
		sw $t1, 64($t0)
		addi $t0, $t0, 256
		sw $t1, 52($t0)
		addi $t0, $t0, 896
		sw $t1, 92($t0)
		addi $t0, $t0, 1024
		sw $t1, 20($t0)
		addi $t0, $t0, 128
		sw $t1, 116($t0)
		addi $t0, $t0, 384
		sw $t1, 68($t0)
		addi $t0, $t0, 1408
		sw $t1, 8($t0)
		addi $t0, $t0, 128
		sw $t1, 112($t0)
		addi $t0, $t0, 896
		sw $t1, 88($t0)
		
		jr $ra
		


############################
	drawGameStart:
		addi $sp, $sp, -4
  		sw $ra, 0($sp)
  		
  		jal drawGameBoard
  		jal drawTitle
  		jal drawStartText
  		jal drawCharacterAndBottomPart
  		
		lw $t9, 0($sp)
		addi $sp, $sp, 4
		jr $t9
		
###########################
	drawRestartMenu:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		jal drawGameBoard
		jal drawTitle
		jal drawRestartText
		jal drawCharacterAndBottomPart
		jal drawCharacterAndBottomPartRestart
		
		lw $t9, 0($sp)
		addi $sp, $sp, 4
		jr $t9
		
			
	
	Exit:
	li $v0, 10 # terminate the program gracefully
	syscall # Call the functions
