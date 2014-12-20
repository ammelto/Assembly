;===================================================================
;Program that adds 4 numbers
;===================================================================
OUTLHLF	EQU	$FFB2
OUTRHLF	EQU	$FFB5

	ORG	$8000
MAIN
	; V1 = 11;
	LDAA	#11
	STAA	V1
	; V2 = 0X2F;
	LDAA	#$2F
	STAA	V2
	; V3 = 'A';
	LDAA	#'A'
	STAA	V3
	; V4 =	044;
	LDAA	#@44
	STAA	V4
	; TOTAL=V1+V2+V3+V4;
	LDAA	V1
	ADDA	V2
	ADDA	V3
	ADDA	V4
	STAA	TOTAL
; PRINT	TOTAL AS 2 DIGIT HEX NUMBER
	LDAA	TOTAL
	JSR	OUTLHLF
	LDAA	TOTAL
	JSR	OUTRHLF
	SWI
	ORG	$9000
V1	RMB	1
V2	RMB	1
V3	RMB	1
V4	RMB	1
TOTAL	RMB	1
	OPT	S