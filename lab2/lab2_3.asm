.include "m2560def.inc"
.def operand = r26
.def x1mask = r16
.def x1 = r21
.def x3mask = r17
.def x3 = r22
.def x5mask = r18
.def x5 = r23
.def x7mask = r19
.def x7 = r24
.def answer = r20
.def operand = r26
.def checkValue = r27
.def setAnswer = r28

init:
	ldi x1mask, 0b00000010
	ldi x3mask, 0b00001000
	ldi x5mask, 0b00100000
	ldi x7mask, 0b10000000
	ldi checkValue, 0b00000000
	ldi setAnswer, 0xff


	mov x1, operand
	mov x3, operand
	mov x5, operand
	mov x7, operand

	and x1, x1mask
	and x3, x3mask
	and x5, x5mask
	and x7, x7mask
	
	
setx1:
	cp x1, checkValue
	breq setx3
	com x1mask
	eor x1, x1mask	
setx3:
	cp x3, checkValue
	breq setx5
	com x3mask
	eor x3, x3mask
setx5:
	cp x5, checkValue
	breq setx7
	com x5mask
	eor x5, x5mask	
setx7:
	cp x7, checkValue
	breq main
	com x7mask
	eor x7, x7mask
	rjmp main

main:
	and x3, x5
	com x1
	and x7, x1
	or x3, x7
	cp x3, setAnswer
	brne return
	ldi x3, 0x01

return:
	sts 0x259, x3

end: rjmp end
	
	
