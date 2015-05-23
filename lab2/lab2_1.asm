.include "m2560def.inc"
.def mask = r16
.def operand = r26
.def sett = r18
.def reset = r19
.def invert = r20

init:
	mov sett, operand
	mov reset, operand
	mov invert, operand
	ldi mask, 0b00101000 ; mask with 3 and 5

operations:
	or sett, mask
	eor invert, mask

	com mask
	and reset, mask
end: rjmp end

