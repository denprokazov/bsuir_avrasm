.include "m2560def.inc"

init:

	ldi r16,0xFF
	out DDRB,r16
	out PORTB, r16


main:
 		rjmp main




