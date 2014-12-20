;========================================================================================================
;Program to experiment with clearing and setting bits using assembly
;This program will  print an 8 bit value in hex then in binary
;========================================================================================================
; Standard Buffalo Functions
; It’s a good idea to use these often and in future designs
;
UCASE	EQU	$FFA0
WCHEK	EQU	$FFA3
DCHEK	EQU	$FFA6
INIT	EQU	$FFA9
INPUT	EQU	$FFAC
OUTPUT	EQU	$FFAF
OUTLHLF	EQU	$FFB2
OUTRHLF	EQU	$FFB5
OUTA	EQU	$FFB8
OUT1BYT	EQU	$FFBB
OUT1BSP	EQU	$FFBE
OUT2BSP	EQU	$FFC1
OUTCRLF	EQU	$FFC4
OUTSTRG	EQU	$FFC7
OUTSTRGO	EQU	$FFCA
INCHAR	EQU	$FFCD
VECINIT	EQU	$FFD0
	ORG	$9200
	LDX	#ABOUTME
	JSR	OUT1BYT
	JSR	RAND
	JSR	PRBINARY
	SWI
**************************************************************
BIT4	EQU	%00010000	; THIS EQUATE MAKES THE CODE MORE READABLE
	ORG	$92FF
	JSR	OUTCRLF	* NEED THIS FOR OUTPUTS TO LINE UP!
	JSR	RAND
	STAA	$00
	JSR	PRBINARY	* PRINT BEFORE
	LDAA	$00
	ANDA	#BIT4
	BEQ	NOPE
	LDX	#YESSTR
	JSR	OUTSTRG
	SWI
NOPE	LDX	#NOSTR
	JSR	OUTSTRG
	SWI
**************************************************************
	ORG	$92CF
	JSR	OUTCRLF	* NEED THIS FOR OUTPUTS TO LINE UP!
	JSR	RAND
	STAA	$00
	JSR	PRBINARY	* PRINT BEFORE
	JSR	TGLBIT4
	LDAA	$00
	JSR	PRBINARY	* PRINT AFTER 1 TOGGLE
	JSR	TGLBIT4
	LDAA	$00
	JSR	PRBINARY	* PRINT AFTER 2 TOGGLE
	JSR	TGLBIT4
	LDAA	$00
	JSR	PRBINARY	* PRINT AFTER 3 TOGGLES
	SWI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function: TGLBIT4
; Purpose: toggles bit #4 in memory location $00
; Registers modified none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TGLBIT4	PSHA
	LDAA	$00
	EORA	#%00010000
	STAA	$00
	PULA
	RTS
**************************************************************
	ORG	$927F
	JSR	OUTCRLF	* NEED THIS FOR OUTPUTS TO LINE UP!
	JSR	RAND
	STAA	$00
	JSR	PRBINARY	* PRINT BEFORE
	JSR	SETBIT4
	LDAA	$00
	JSR	PRBINARY	* PRINT AFTER SET
	JSR	CLRBIT4
	LDAA	$00
	JSR	PRBINARY	* PRINT AFTER CLEAR
	SWI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function: CLRBIT4
; Purpose: Clears bit #4 in memory location $00
; Registers modified none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;
CLRBIT4	PSHA
	LDAA	$00
	ANDA	#%11101111
	STAA	$00
	PULA
	RTS
**************************************************************
	ORG	$925F
	JSR	OUTCRLF	* NEED THIS FOR OUTPUTS TO LINE UP!
	JSR	RAND
	STAA	$00
	JSR	PRBINARY	* PRINT BEFORE
	JSR	SETBIT4
	LDAA	$00
	JSR	PRBINARY	* PRINT AFTER
	SWI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function: SETBIT4
; Purpose: SETS bit #4 in memory location $00
; Registers modified none
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SETBIT4	PSHA
	LDAA	$00
	ORAA 	#%00010000
	STAA	$00
	PULA
	RTS
; program section: set origin to $9100
	ORG $9100	
	LDX	#ABOUTME * Starting address of the string
	JSR	OUTSTRG
	SWI
*the string with fcc command should end with 4
	FCB	4	; Do NOT forget this
************************************************************
	ORG	$911F
	JSR	RAND
	SWI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function: RAND
; Purpose: Generate a random number
; Inputs: None
; Outputs: A random value returned in A registers
; Registers modified: A register (which has a random value)
; Memory usage
; The most recently generated random number is
; stored in memory with label LSTRAND
; This value is used to generate the next value
; Notes: Not the best random number generator around but does a
; halfway decent job.
; Implementation Notes
; shift the
; last random value left and add 20 with carry
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RAND	LDAA	LASTRND
	LSLA
	ADCA	#20
	STAA	LASTRND	; don’t forget to save it back
	RTS
**********************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function: PRBINARY
; Purpose: To print a value in binary
; Inputs: Value to be printed is passed in the A register
; Returns: None;
; Registers affected: None. The values in the registers are stored
; first and these values are restored at the end.
; Notes: The output consists of two parts. The value in A is first
; printed in HEX, and then in binary;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRBINARY
; first save the registers we will be using: A, B and X
	PSHA
	PSHB
	PSHX
; copy A to be for later use
	TAB
; print A as hex number (2 digits)
; print the left digit
	JSR	OUTLHLF
; the function destroys the value in A,
; so reload it! then print second digit
	TBA
	JSR	OUTRHLF
; now print a colon and some spaces
	LDAA	#':'
	JSR	OUTA
	LDAA	#' '
	JSR	OUTA
	JSR	OUTA
	JSR	OUTA
;--> B has the value to be printed (recall the old TAB)
;--> Shift B to the left by one bit and print ’0’ or ’1’ depending
; on what is in the carry flag and repeat 8 times.
;--> Use X register as a counter
; to print what is in carry flag, and load A
; with the code for ’0’ ; then, add the carry to the code
; prior to calling OUTA
	LDX	#8	* COUNTER
PRBLOOP	CPX	#0
	BEQ	PRBDONE
	LDAA	#'0'
	LSLB
	ADCA	#0
	JSR	OUTA
	DEX
	BRA	PRBLOOP
PRBDONE	JSR	OUTCRLF
; restore the registers
	PULX
	PULB
	PULA
	RTS
****************************************************************
	ORG $9000
ABOUTME FCC '/INFORMATION ABOUT YOU/'
	FCB	4
LASTRND	FCB	0
YESSTR	FCC	'YES'
	FCB	4
NOSTR	FCC	'NO'
	FCB	4
***************************************************************