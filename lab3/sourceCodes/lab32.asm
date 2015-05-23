.include "m2560def.inc"
.def buttonPortMask = r16
.def ledPortMask = r17
.def buttonState = r18
.def OFF = r19
.def ON = r20

init:
	ldi OFF, 0b00000000 ; OFF led mask
	ldi ON, 0b00100000 ; on led mask
	ldi buttonPortMask, 0b11110111 ; button mask for input
	out DDRB, buttonPortMask  ; setting up button mask
	ldi ledPortMask, 0b00100000 ;
	out DDRD, ledPortMask ; setting up led mask


buttonLoop: ; checking button state like infinity times per second
	sbic PINB, 3 ; if pin3=0 then turn on the led(inverse logic of button)
	rjmp buttonOFF
	rjmp buttonON

buttonOFF: ; button of
	out PORTD, OFF
	rjmp buttonLoop

buttonON: ; button on
	out PORTD, ON
	rjmp buttonLoop




