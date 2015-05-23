.include "m2560def.inc"

def:
	.def fSummand = r26
	.def sSummand = r27	
	.def LQuattrCorr = r17
	.def HQuattrCorr = r18
	.def correctionRequest = r19
	.def temp = r16
	.def tempNeg = r28
	.def tempOne = r29
init:
	ldi LQuattrCorr, 0x06; correction for the half transfer
	ldi HQuattrCorr, 0x60 ; correction for the full transfer
	ldi correctionRequest, 0x66 ; for checking digit to be corrected
	ldi tempNeg, 0x99 ; 99 for additive converting
	ldi tempOne, 0x01 ; 1 for additive converting	
	lds sSummand, 0x259 ; get second summand


checkCorrectionPossibility:
	neg LQuattrCorr ; change LQuattrCorr to the additive code
	neg HQuattrCorr	; change HQuattrCorr to the additive code

	
	
additiveCode:
	sub tempNeg, sSummand ; sub 99 with straightCode
	add tempNeg, tempOne  ; result + 1
	mov sSummand, tempNeg ; move to sSummand's register
	clc ; clear cFlag


	add fSummand, correctionRequest ; checking if first summand need correction	
	add fSummand, sSummand ; sub first Summand with second Summand
	brhc correctHalfByte ; if flag H=0 then correct high byte
	brcc correctIfCFlag ; if flag C=0 then correct high tetr
	adc r2, r3 ;save c flag
end: rjmp end
	
correctHalfByte:
	adc r2, r3 ; save cFlag value
	add fSummand, LQuattrCorr ; correction
	cpse r2, r3 ; check C flag
	rjmp end
	clc ;clear C flag
	rjmp correctIfCFlag; jump to the high byte correction
	

correctIfCFlag: 
	adc r2, r3 ; save cFlag value
	add fSummand, HQuattrCorr ; correct high byte
	rjmp end
	

