.include "m2560def.inc"
.def leftPartMask = r16
.def rightPartMask =  r17
.def lowDelayRegister = r18
.def midDelayRegister = r19
.def highDelayRegister = r20
.def counter = r21
.def initializer = r22
.def mask = r23
.def offMask = r24

init:
	clt ; clear t flag for no reason
	ldi leftPartMask,  0b00001000 ; left quatter mask (before first shift)
	ldi rightPartMask, 0b00010000 ;right quatter mask
	ldi initializer, 0b11111111 ;
	ldi offMask, 0b00000000
	ldi counter, 0 ; counter for coun number of shifts
	mov mask, offMask ; init mask
	out DDRD, initializer ; set portD for outpput
	out PORTD, offMask ;

OFF:
	clt ; clear t flag for next ON-state
	cpi counter, 0x04 ; compare to 4 times shift
	breq init ; if shifts = 4 then init again
	out PORTD, offMask ; lights off
	lsl leftPartMask ;  left shift left quatter
	lsr rightPartMask ; same for the right quatter
	mov mask, offMask ; reset mask for next ON-state
	inc counter ; number of shifts ++
	rjmp initHalfSecondDelay ; init off delay

ON:
	add mask, leftPartMask ; make final mask
	add mask, rightPartMask ; same here ^^^
	out PORTD, mask ; LIGHT!
	rjmp initOneSecondDelay ; delay ON-state


initHalfSecondDelay:
	ldi highDelayRegister,  $03 ; init three registers
	ldi midDelayRegister, $0d ; for decrement in 2MHz clock rate
	ldi lowDelayRegister, $40 ; because of default 1/8 predevider
	rjmp delayLoop ; delay


initOneSecondDelay:
	clt
	ldi highDelayRegister, $06
	ldi midDelayRegister, $1a
	ldi lowDelayRegister, $80
	set ; for next off-state of led
	rjmp delayLoop


delayLoop: ;delay
	subi lowDelayRegister,1 ; substract from low 1
 	sbci midDelayRegister,0 ; if low is overflow, then substract c flag from mid, if not substract nothing
 	sbci highDelayRegister,0 ; if mid is overflow, then substract c flag from high
  	brcc delayLoop ; if c is not rised go dec again
  	brts OFF ; if previous was ON then Off
  	rjmp ON ; else - ON
