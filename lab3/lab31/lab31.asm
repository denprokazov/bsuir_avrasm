.include "m2560def.inc"
.def portMask = r16
.def operand = r17

init:
	ldi portMask, 0b00101000
	out DDRB, portMask ; set up pins for out
	ldi operand, 0x0f ; set checked operand

trickWithEars: ; we must load operand from data memory
	sts 0x259, operand
	clr operand
	lds operand, 0x259
main:
	and operand, portMask ; mark valuable bits
	out PORTB, operand ; SUNLIGHT!
end: rjmp end


