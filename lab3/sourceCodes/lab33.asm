.include "m2560def.inc"
.def buttonPortMask = r16
.def decryptorMaskLB = r17
.def decryptorMaskHB = r20
.def decryptorMask = r21
.def lowCounter = r18
.def initializer = r22
.def highCounter = r19
.def temp = r23
.def toOutput = r24

init:
	ldi buttonPortMask, 0b11010111
	ldi decryptorMask, 0b11111111
	ldi lowCounter, 0x00
	ldi highCounter, 0x00
	ldi initializer, 0x00
	out DDRB, buttonPortMask ; set up button port for in
	out DDRD, decryptorMask ; set up decryptors port for out
	out PORTD, initializer ; initialize counters
	clc  ; clear cflag for compare

checkButton:
	sbis PINB, 5 ; check resetButton
	rjmp resetButton
	mov temp, highCounter ; cancel left shift for increment
	clr toOutput ; clr outputValue for normal adding
	sbic PINB, 3 ; if button not pressed then check again
	rjmp checkButton
	rjmp checkOverflow ; else check overflow

resetButton:
	ldi lowCounter, 0x00 ; reset low counter
	ldi highCounter, 0x00 ;reset high counter
	ldi temp, 0x00 ; reset temp(because of shift)
	rjmp indicate ; indicate

checkOverflow:
	clc ; clear c flag for clear compare
	cpi lowCounter, 0x09
	brne incrementLowCounter ; if low counter < 9 then increment
	breq incrementHighCounter ; if low counter = 9  then increment high

incrementLowCounter:
	inc lowCounter ; increment counter
close1: ; wait untill button unpressed, because processor is much faster than your reaction
	sbis PINB, 3
	rjmp close1
	rjmp indicate ; when unpressed then go to indicate

incrementHighCounter:
	clc ; clear c flag for better compare
	cpi highCounter, 0x09
	breq end ; if high counter = 9 then act like a dead
	inc highCounter ; else increment high counter
	mov temp, highCounter ; high counter to temp for left shift in future(high counter - high bytes in port)
	ldi lowCounter, 0x00 ; reset lowCounter
close2: ; check again for unpressed button(deprecate or not?)
	sbis PINB, 3
	rjmp close2
	rjmp indicate

indicate:
	lsl temp ; shift high counter left for second indicator
	lsl temp
	lsl temp
	lsl temp
	add toOutput, temp ; add high byte to result
	add toOutput, lowCounter ; add low byte to result
	out PORTD, toOutput ; indicate result
	rjmp checkButton ; check button again

end: rjmp end


