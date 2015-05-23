.include "m2560def.inc"

def:
	.def fSummand = r26
	.def sSummand = r27	
	.def LQuattrCorr = r17
	.def HQuattrCorr = r18
	.def correctionRequest = r19
	.def temp = r16
init:
	ldi LQuattrCorr, 0x06; correction for the half transfer
	ldi HQuattrCorr, 0x60 ; correction for the full transfer
	ldi correctionRequest, 0x66 ; for checking digit to be corrected
	lds sSummand, 0x259

checkCorrectionPossibility:
	neg LQuattrCorr ; change LQuattrCorr to the additive code
	neg HQuattrCorr	; change HQuattrCorr to the additive code

	add fSummand, correctionRequest ; checking if first summand need correction	
	add fSummand, sSummand ; checking if second summand need correction
	brhc correctHalfByte ; if flag H=0 then correct high byte
	brcc correctIfCFlag ; if flag C=0 then correct low byte
	adc r2, r3
end: rjmp end
	
correctHalfByte:
	adc r2, r3
	add fSummand, LQuattrCorr ; correction
	cpse r2, r3 ; check C flag
	rjmp end
	clc ;clear C flag
	rjmp correctIfCFlag; jump to the high byte correction
	

correctIfCFlag: 
	adc r2, r3	
	add fSummand, HQuattrCorr ; correct high byte
	rjmp end
	


	
	
