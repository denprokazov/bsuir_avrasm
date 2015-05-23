.include "m2560def.inc"

.def counter = R17
.def lowTetrad = R18
.def temp = r16
.def buttonsMask = r20
.def segmentDisplayMask = r21
.def six = r23
.def initializer = r24
.def toOutput = r25
.def operationSummand = r19

.cseg
.org $0000 rjmp init  ; initiilize
.org $0002 reti 	  ; (INT0) External Interrupt Request 0
.org $0004 reti 	  ; (INT1) External Interrupt Request 1
.org $0006 reti 	  ; (INT2) External Interrupt Request 2
.org $0008 rjmp rightRotateInterrupt      ; (INT3) External Interrupt Request 3
.org $000A reti       ; (INT4) External Interrupt Request 4
.org $000C rjmp leftRotateInterrupt      ; (INT5) External Interrupt Request 5
.org $000E reti       ; (INT6) External Interrupt Request 6
.org $0010 rjmp resetButtonInterrupt       ; (INT7) External Interrupt Request 7
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
.org $002E reti       ; (TIMER0_OVF) Timer/Counter0 Overflow
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

rightRotateInterrupt:
	sbis PINE, 5; if A falled and B=1 then clockwise, uncrement
	rjmp rightRotateInterruptDone
	cpi counter, 0x99 ; compare with 99
	breq rightRotateInterrupt ; if counter = 99 then done
	ldi operationSummand, 0x01 ; else operation plus
	bset 6 ; operation flag for counter event
rightRotateInterruptDone: reti

leftRotateInterrupt:
	sbis PIND, 3 ; if B falled and A=1 then counterclockwise, decrement
	rjmp leftRotateInterruptDone
	cpi counter, 0x00 ; compare counter to 0
	breq leftRotateInterruptDone ; if counter = 0 then act like a dead
	ldi operationSummand, 0xFF ; set decrement operation(in addictive code)
	bset 6
leftRotateInterruptDone: reti

resetButtonInterrupt:
	bclr 6 ; clear event flag
	clr counter ; clear counter
resetButtonInterruptDone: reti


init:
	ldi initializer, 0x00
	ldi toOutput, 0x00
	ldi six, 0x06
	ldi segmentDisplayMask, 0b11111111

	ldi temp, Low(RAMEND) ; load stack pointer
	out SPL, temp
	ldi temp, High(RAMEND) ; load stack pointer
	out SPH, temp
	ldi temp, 0b10101000 ; allow intterruptions on int3 and int5 and int 7 locally
	out EIMSK, temp
	ldi temp, 0b10000000 ; set up the falling edge mode on int3
	sts EICRA, temp
	ldi temp, 0b10001000 ; set up the falling edge on port E at int 7 and int 5
	sts EICRB, temp

	sei	; allow interruptions globally
	ldi temp, 0b00000000
	out DDRD, temp ; set up d-port for input
	out DDRE, temp ; set up e-port for input
	out DDRB, segmentDisplayMask
	out PORTB, initializer
	clr counter


main:
	brbs 6, counterEvent ; if event happend then do operation with counter
	out PORTB, counter ; feed the displays
	rjmp main ; check new events

counterEvent:
	bclr 6 ; clear t flag for new events
	add counter, operationSummand ; add 0x01 or 0xff for summ or subtraction
	brcs correctSubstraction ; correct substraction if full transfer happend
	add counter, six ; check for 2-10 correction
	brhs main ; if half transfer happend, then go home check for a new events
	sub counter, six ; if half transfer flag didn't rised then goes to it's first state
	rjmp main ; display this shit

	correctSubstraction: ; correction for substraction
	brhs main ; if halftransfer happend then it's all okay
	sub counter, six ; else substract six for 2-10 god RISE!
	rjmp main