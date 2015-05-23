.include "m2560def.inc"
.def temp =r18
.def six  =r19
.def sixty = r20
summa:
	ldi r16, 0x25  ;исходный операнд
	ldi r17, 0x40  ;исходный операнд
	mov temp, r17

	ldi r28, 0b01100110   ;r28=66
	ldi six, 0b00000110   ;six=06
	ldi sixty, 0b01100000 ;sixty=60
	neg six        ;доп. код 06
	neg sixty      ;доп. код 60
	add r16, r28   ;проверка на необходимость коррекции
	add r16, temp
	brhc correcth
	brcc correctc
	adc r2,r3      ;сохранить в r2 значение сотни
end: rjmp end       ;остановка программы

correcth:           ;коррекция, если был полуперенос
	adc r2, r3     ;сохранить в r2 значение флага C
	add r16, six   ;коррекция младшей тетрады
	cpse r2,r3     ;учёт единицы
	rjmp end
	clc
	rjmp correctc
correctc:           ;коррекция, если был перенос
	adc r2,r3      ;сохранить в r2 значение флага C
	add r16, sixty ;коррекция старшей тетрады
	rjmp end
