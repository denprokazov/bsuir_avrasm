.include "m2560def.inc"

.def tmp=r0
.def result = r15
.def resultO = r16
.def pointer = r18
.def check = r19
.def temp = r20

.cseg
array: .db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

init:  
      ldi zl, LOW(array)
	  ldi zh, HIGH(array)
	  ldi check, 0xFF
	  clr pointer
	  clr result
	  clr resultO
load:
	  lpm tmp, z+ ; load data from code segment  

main:  
	  lsl tmp ; shift temp left	
	  brcc nextElement ; if c=0 then
	  cp check, result ; check if need new register
	  breq setT
	  brts incrementIfOverflow 
	  inc result ; increment result
nextElement:
	  brne main ; temp!=0 then shift to overflow 
	  inc pointer ; increment pointer
	  cpi pointer, 0x28 ; compare pointer to array length
	  brcs load ; if c=1 then load new digit from array
	  rjmp finalResult
setT:
	set
incrementIfOverflow:
	inc resultO
	rjmp nextElement

finalResult:
	adc result, resultO
	brcc incrementHighByte
	
incrementHighByte:
	clr resultO
	inc resultO

end:rjmp end

