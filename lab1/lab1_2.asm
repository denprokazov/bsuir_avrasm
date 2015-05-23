.include "m2560def.inc"
init:
	lds r17, 0x0259		; write data to r17 from 0x0259
	lds r19, 0x025A		; write data to r19 from 0x025A 

	add r15, r17 
	adc r18, r19

	sts 0x0359, r15
	sts 0x035A, r18
end: rjmp end
