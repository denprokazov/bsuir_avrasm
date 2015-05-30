.include "m2560def.inc"
.def leftPartMask = r16
.def rightPartMask =  r17
.def halfSecondDelay = r18
.def oneSecondDelay = r19
.def counter = r21
.def initializer = r22
.def mask = r23
.def offMask = r24
.def interruptionsCounter = r25
.def temp = r26

.cseg
.org $0000 rjmp init  ; initiilize
.org $0002 reti 	  ; (INT0) External Interrupt Request 0
.org $0004 reti 	  ; (INT1) External Interrupt Request 1
.org $0006 reti 	  ; (INT2) External Interrupt Request 2
.org $0008 reti 	  ; (INT3) External Interrupt Request 3
.org $000A reti       ; (INT4) External Interrupt Request 4
.org $000C reti       ; (INT5) External Interrupt Request 5
.org $000E reti       ; (INT6) External Interrupt Request 6
.org $0010 reti       ; (INT7) External Interrupt Request 7
.org $0012 reti       ; (PCINT0) Pin Change Interrupt Request 0
.org $0014 reti       ; (PCINT1) Pin Change Interrupt Request 1
.org $0016 reti       ; (PCINT2) Pin Change Interrupt Request 2
.org $0018 reti       ; (WDT) Watchdog Time-out Interrupt
.org $001A reti       ; (TIMER2_COMPA) Timer/Counter2 Compare Match A
.org $001C reti       ; (TIMER2_COMPB) Timer/Counter2 Compare Match B
.org $001E reti       ; (TIMER2_OVF) Timer/Counter2 Overflow
.org $0020 reti       ; (TIMER1_CAPT) Timer/Counter1 Capture Event
.org $0022 reti       ; (TIMER1_COMPA) Timer/Counter1 Compare Match A
.org $0024 reti       ; (TIMER1_COMPB) Timer/Counter1 Compare Match B
.org $0026 reti       ; (TIMER1_COMPC) Timer/Counter1 Compare Match C
.org $0028 reti       ; (TIMER1_OVF) Timer/Counter1 Overflow
.org $002A reti       ; (TIMER0_COMPA) Timer/Counter0 Compare Match A
.org $002C reti       ; (TIMER0_COMPB) Timer/Counter0 Compare Match B
.org $002E rjmp handleTimer      ; (TIMER0_OVF) Timer/Counter0 Overflow
.org $0030 reti       ; (SPI_STC) Serial Transfer Complete
.org $0032 reti       ; (USART0_RX) USART0 Rx Complete
.org $0034 reti       ; (USART0_UDRE) USART0 Data Register Empty
.org $0036 reti       ; (USART0_TX) USART0 Tx Complete
.org $0038 reti       ; (ANALOG_COMP) Analog Comparator
.org $003A reti       ; (ADC) ADC Conversion Complete
.org $003C reti       ; (EE_READY) EEPROM Ready
.org $003E reti       ; (TIMER3_CAPT) Timer/Counter3 Capture Event
.org $0040 reti       ; (TIMER3_COMPA) Timer/Counter3 Compare Match A
.org $0042 reti       ; (TIMER3_COMPB) Timer/Counter3 Compare Match B
.org $0044 reti       ; (TIMER3_COMPC) Timer/Counter3 Compare Match C
.org $0046 reti       ; (TIMER3_OVF) Timer/Counter3 Overflow
.org $0048 reti       ; (USART1_RX) USART1 Rx Complete
.org $004A reti       ; (USART1_UDRE) USART1 Data Register Empty
.org $004C reti       ; (USART1_TX) USART1 Tx Complete
.org $004E reti       ; (TWI) 2-wire Serial Interface
.org $0050 reti       ; (SPM_RDY) Store Program Memory Ready
.org $0052 reti       ; (TIMER4_CAPT) Timer/Counter4 Capture Event
.org $0054 reti       ; (TIMER4_COMPA) Timer/Counter4 Compare Match A
.org $0056 reti       ; (TIMER4_COMPB) Timer/Counter4 Compare Match B
.org $0058 reti       ; (TIMER4_COMPC) Timer/Counter4 Compare Match C
.org $005A reti       ; (TIMER4_OVF) Timer/Counter4 Overflow
.org $005C reti       ; (TIMER5_CAPT) Timer/Counter5 Capture Event
.org $005E reti       ; (TIMER5_COMPA) Timer/Counter5 Compare Match A
.org $0060 reti       ; (TIMER5_COMPB) Timer/Counter5 Compare Match B
.org $0062 reti       ; (TIMER5_COMPC) Timer/Counter5 Compare Match C
.org $0064 reti       ; (TIMER5_OVF) Timer/Counter5 Overflow
.org $0066 reti       ; (USART2_RX) USART2 Rx Complete
.org $0068 reti       ; (USART2_UDRE) USART2 Data Register Empty
.org $006A reti       ; (USART2_TX) USART2 Tx Complete
.org $006C reti       ; (USART3_RX) USART3 Rx Complete
.org $006E reti       ; (USART3_UDRE) USART3 Data Register Empty
.org $0070 reti       ; (USART3_TX) USART3 Tx Complete
.org INT_VECTORS_SIZE ; end of interrupt vectors



OFF:
	bclr 6 ; clear t flag for next ON-state
	cpi counter, 0x04 ; compare to 4 times shift
	breq init ; if shifts = 4 then init again
	out PORTD, offMask ; lights off
	lsl leftPartMask ;  left shift left quatter
	lsr rightPartMask ; same for the right quatter
	mov mask, offMask ; reset mask for next ON-state
	inc counter ; number of shifts ++
initHalfSecondDelay:  ; init off delay
	out TCNT0, offMask ; set timer to 0 for better count
	mov interruptionsCounter, halfSecondDelay ; load halfsecondDelay to interruptions counter
	rjmp endHandleTimer ; end interruption

ON:
	add mask, leftPartMask ; make final mask
	add mask, rightPartMask ; same here ^^^
	out PORTD, mask ; LIGHT!
initOneSecondDelay: ; delay ON-state
	bclr 6 ; clear user flag for better heil satan
	out TCNT0, offMask ; set timer to 0 for better count
	mov interruptionsCounter, oneSecondDelay ; load one second delay for on-state
	bset 6 ; set user flag for next off-state of led
rjmp endHandleTimer ; end interruption



handleTimer: ; tim0 overflow handler
	dec interruptionsCounter ; decrement interrupt counter every time where timr overflows(255*oneSecondDelay(128)/62500=1s at 4MHz with 64 prdev)
	breq timerHandlerResult ; when time is off go deside next state of led
endHandleTimer:	reti ; interruption end

timerHandlerResult:
	out TCNT0, offMask ; set timer to 0 for better count
	brts OFF ; if previous state(t-flag) was ON then OFF
	rjmp ON ; else ON

init:
	ldi halfSecondDelay, 128 ; init half second delay
	ldi oneSecondDelay, 255 ; init one second delay
	mov interruptionsCounter, halfSecondDelay ; first state is off
;==============STACK====================;
	ldi temp ,Low(RAMEND) ; program start load low byte of ram end adress
	out SPL, temp         ; init custom stack
	ldi temp,High(RAMEND); load high byte of ram end adress
	out SPH,temp ; init custom stack finally
;==============LED INIT=================;
	bclr 6 ; clear t flag for no reason
	ldi leftPartMask,  0b00010000 ; left quatter mask
	ldi rightPartMask, 0b00001000 ;right quatter mask
	ldi initializer, 0b11111111 ;
	ldi offMask, 0b00000000
	ldi counter, 0 ; counter for count number of shifts
	mov mask, offMask ; init mask
	out DDRD, initializer ; set portD for outpput
	out PORTD, offMask ;
;==============TIMER INIT===============;
	ldi temp,(1<<TOIE0) ; allow timer interrupions
	sts TIMSK0, temp ; sts because of mega2560:\
	ldi temp, 0b000000010 ; start timer0 with 64 predevider
  	out TCCR0B, temp ; TCCR0B is because mega2560
  	ldi temp, 0 ; clear timer for better count
  	out TCNT0, temp ; ^^^
	sei ; ALLOW INTERRUPTIONS GLOBALLY!!!1FUUUUUUUUUUUUUU

mainLoop: ;
	out PORTD, mask
	rjmp mainLoop

