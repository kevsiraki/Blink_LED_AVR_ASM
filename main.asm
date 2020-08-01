; Pin Constant Values
; PD0 - 0
; PD1 - 1
; PD2 - 2
; PD3 - 3
; PD4 - 4
; PD5 - 5
; PD6 - 6
; PD7 - 7

; PB0 - 8
; PB1 - 9
; PB2 - 10
; PB3 - 11
; PB4 - 12
; PB5 - 13 - System LED

.DEF PTD = r16			;portd
.DEF PTB = r17			;portb

.MACRO delay			;macro for calling delay subroutine.. takes a parameter of ms
dloop:					;delaying loop
	rcall d				;call delay subroutine
	sbiw XL,1			;decrement lower byte
	brne dloop			;continue dloop until XL == 0
.ENDMACRO				;end of macro

start:					;begin()
	rcall	init		;initialize all pins as output	
loop:					;loop()
	ldi	XH,HIGH(1000)	;upper byte ;1000 here is 1 s delay
	ldi XL,LOW(1000)	;lower byte
	delay				;call subroutine delay(1000)
	rcall setpinhigh	;call setpinhigh subroutine
	ldi XH,HIGH(1000)	;upper byte ;1000 here is 1 s delay
	ldi XL,LOW(1000)	;lower byte
	delay				;call subroutine delay(1000)
	rcall	setpinlow	;call setpinlow subroutine
	rjmp	loop		;continue loop()

init:					;subroutine that initializes all pins
	;set pins 0-7 to low
	ldi		r16,(0<<PD7)|(0<<PD6)|(0<<PD5)|(0<<PD4)|(0<<PD3)|(0<<PD2)|(0<<PD1)|(0<<PD0) 
	out		PORTD,PTD

	;set pins 8-13 to low
    ldi		r17,(0<<PB5)|(0<<PB4)|(0<<PB3)|(0<<PB2)|(0<<PB1)|(0<<PB0) 
	out		PORTB,PTB

	;set pins 0-7 to output mode
	ldi		r18,(1<<DDD7)|(1<<DDD6)|(1<<DDD5)|(1<<DDD4)|(1<<DDD3)|(1<<DDD2)|(1<<DDD1)|(1<<DDD0) 
	out		DDRD,r18

	;set pins 8-13 to output mode
	ldi		r19,(1<<DDB5)|(1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0) 
	out		DDRB,r19

	nop					;nop for settling down after pins set
	ret					;return from subroutine

setpinhigh:				;subroutine for setting a pin high
	ldi		PTB,1<<PB0	;in this case I use PB0, or pin 8 on the UNO. set the bit to 1
	out		PORTB, PTB	;output the bit value on port b (r17)
	ret					;return from subroutine

setpinlow:				;subroutine for setting a pin high
	ldi		PTB,0<<PB0	;in this case I use PB0, or pin 8 on the UNO. set the bit to 0
	out		PORTB, PTB	;output the bit value on port b (r17)
	ret					;return from subroutine

d:						;delay subroutine.. takes a parameter of ms
	ldi ZH,HIGH(2000)	;upper byte
    ldi ZL,LOW(2000)	;lower byte
count:
    sbiw ZL,1			;decrement lower byte
    brne count 
	ret					;return from subroutine		