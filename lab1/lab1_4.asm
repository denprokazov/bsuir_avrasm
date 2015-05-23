.include "m2560def.inc"

def:
	.def devident = r4
	.def devider = r26
	.def resultInt = r6
	.def resultComma = r7
	
init:
	lds devident, 0x0259
	;ldi resultInt, 0
	
main:
	cp devident, devider ; compare devident with devider
	brlo end ; if result of compare = 0, then go to end
	sub devident, devider ; substitute devident vs devider
	inc resultInt ; increment int result
	cp devident, devider ; compare devident vs devider once more
	brsh main ; if result 
save_results:
	sts 0x0359, resultInt ; save int result of devide
	sts 0x035a, devident ; save not int result of devide

end: rjmp end
	
