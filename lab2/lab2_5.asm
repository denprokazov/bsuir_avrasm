
.include "m2560def.inc"
.def operand = r26
/*multiply*\
init:
	lds operand, 0x0259; load operand
main:
	lsl operand ; left shift operand
	brcs setT ; if c=1 setting user flag
	clt ; clear user flag
	rjmp part2 ; jump to multiply

setT:	
	set ; set user flag
part2:
	lsl operand ; left shift 
	brts modif ; if t is set modify operand
	rjmp save
modif:
	ori operand, 0b10000000
save:
	sts 0x0359, operand 
end:
	rjmp end*/


/*devide*/
	lds operand, 0x0259
	asr operand
	asr operand
	rjmp return
return:
	sts 0x0359, operand

end: rjmp end
