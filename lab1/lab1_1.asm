
.include "m2560def.inc"

init:
	lds r16, 0x0259
	sub r16,r26
	sts 0x0359, r16
rjmp init

	
