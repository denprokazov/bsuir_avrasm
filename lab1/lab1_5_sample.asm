.include "m2560def.inc"
.def temp =r18
.def six  =r19
.def sixty = r20
summa:
	ldi r16, 0x25  ;�������� �������
	ldi r17, 0x40  ;�������� �������
	mov temp, r17

	ldi r28, 0b01100110   ;r28=66
	ldi six, 0b00000110   ;six=06
	ldi sixty, 0b01100000 ;sixty=60
	neg six        ;���. ��� 06
	neg sixty      ;���. ��� 60
	add r16, r28   ;�������� �� ������������� ���������
	add r16, temp
	brhc correcth
	brcc correctc
	adc r2,r3      ;��������� � r2 �������� �����
end: rjmp end       ;��������� ���������

correcth:           ;���������, ���� ��� �����������
	adc r2, r3     ;��������� � r2 �������� ����� C
	add r16, six   ;��������� ������� �������
	cpse r2,r3     ;���� �������
	rjmp end
	clc
	rjmp correctc
correctc:           ;���������, ���� ��� �������
	adc r2,r3      ;��������� � r2 �������� ����� C
	add r16, sixty ;��������� ������� �������
	rjmp end
