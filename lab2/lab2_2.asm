.include "m2560def.inc"
.def operand = r26
.def mask = r16
.def vValue = r17
.def ifValue = r18
.def oneMask = r19

init: 
	ldi mask, 0b00001000 ; init main mask
	ldi oneMask, 0b01010101 ; init mask for 1-case
	ldi ifValue, 0b00001000 ; init transition value
	ldi vValue, 0x13 ; init variant value

checkEquality:
	and operand, mask 
	cp operand, ifValue ; check if third operand digit = 1
	brne setAnswer; go to setAnswer if false	
	eor vValue, oneMask ; invert even digits if true
		
setAnswer:
	sts 0x200, vValue ; set 0x200 with variant number

end: rjmp end
	
	
	
	
