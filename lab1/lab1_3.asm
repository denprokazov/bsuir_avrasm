.include "m2560def.inc"

def:
	.def dataL = r4 ; low byte
	.def dataH = r5 ; high byte
	.def regWordL  = r26 ; low byte of register word
	.def tempLSD = r16 ; temp register of low byte
	.def tempL = r17; temp register high byte
	.def tempH = r18

init:
	lds dataL, 0x0259 ; write low word to r1 from 0x0259
	lds dataH, 0x025a ; write high word to r2 from 0x025a
	clr tempL 		  ;clear temp High temp register
main:
	mul dataL, regWordL ; multiply low words
	mov tempLSD, r0 		; move result of multiply to tempL register
	mov tempL, r1		; r1 to tempH register

	mul dataH, regWordL ; multiply high with low word
	add tempL, r0 		; add low result to temp low
	add tempH, r1			

save_result:
	sts 0x0359, tempLSD 
	sts 0x035a, tempL
	sts 0x035b, tempH
end: rjmp end





	
