;revichSample
;Программа счета нажатий в двоичном коде
.device AT90S2313
.include "2313def.inc"
;частота 4 МГц
.def temp = r16 ;рабочая переменная
.def Count_time = r17 ;счетчик задержки
.def Counter = r18 ;счетчик нажатий
.def Flag = r19 ;регистр флагов: если бит 0 установлен,
;то обнаружили нажатие и переходим к обнаружению отпускания
;============ прерывания ============
rjmp RESET ;Reset Handle
rjmp INT0 ;External Interrupt0 Vector Address
reti ;External Interrupt1 Vector Address
reti ;Timer1 capture Interrupt Vector Address
reti ;Timer1 сompare Interrupt Vector Address
reti ;Timer1 Overflow Interrupt Vector Address
rjmp TIM0 ;Timer0 Overflow Interrupt Vector Address
reti ;UART Receive Complete Interrupt Vector Address
reti ;UART Data Register Empty Interrupt Vector Address
reti ;UART Transmit Complete Interrupt Vector Address
reti ;Analog Comparator Interrupt Vector Address

;========== программа ============
INT0: ;внешнее прерывание по кнопке
  ;первым делом запрещаем прерывания от кнопки
  clr temp
  out GIMSK,temp
  ;на всякий случай очищаем регистр флагов прерываний
  ldi temp,$FF
  out GIFR,temp ;GIFR очищается записью единиц
  sbrs Flag,0 ;проверяем бит 0 нашего регистра флагов
  rjmp Push_pin ;если 0, то было нажатие
  cbr Flag,1 ;иначе было отпускание, очищаем бит 0

  inc Counter ;кн. была отпущена, увеличиваем счетчик
  out PORTB,Counter ;выводим счетчик в порт B
  ldi Count_time,50 ;интервал 0,2 с
  rjmp ent_int;на выход
Push_pin: ;было нажатие
  sbr Flag,1 ;устанавливаем бит 0
  ldi Count_time,128 ;интервал 0,5 с
ent_int:
  ldi temp,0b00000011; запуск Timer0 входная частота 1:64
  out TCCR0,temp
reti ;конец обработки прерывания кнопки

TIM0: ;обработчик прерывания Timer0
  dec Count_time ;в каждом прерывании уменьшаем на 1
  breq end_timer ;если ноль, то на конец отсчета
  reti ;иначе выход из прерывания
end_timer:
  clr  temp ;останавливаем таймер
  out TCCR0,temp
  sbrc Flag,0 ;проверяем бит 0 нашего регистра флагов
  rjmp Push_tim ;если 1, то было нажатие
  ldi temp,(1<<ISC01) ;иначе устанавливаем прер. INT0 по спаду
  out MCUCR,temp
  rjmp end_tim ;на выход
Push_tim: ;если было нажатие
  ldi temp,(1<<ISC01|1<<ISC11) ;устанавливаем прер. INT0 по фронту
  out MCUCR,temp
end_tim:
  ldi temp,(1<<INT0) ;разрешаем прерывание INT0
  out GIMSK,temp
reti ;конец обработки прерывания таймера

RESET: ;начальная инициализация
ldi temp,low(RAMEND) ;загрузка указателя стека
out SPL,temp
ldi temp,0b00000100 ;для второго разряда порта D
out PORTD,temp ;подтягивающий резистор на всякий случай
ldi temp,0b11111111 ;порт В все контакты на выход
out DDRB,temp
clr Counter ;очищаем счетчик
clr Flag ;очищаем наш флаг
ldi temp,(1<<TOIE0) ;разр. прерывания Timer0
out TIMSK,temp
ldi temp,(1<<ISC01) ;устанавливаем прер. INT0 по спаду
out MCUCR,temp
ldi temp,(1<<INT0) ;разрешаем прерывание INT0
out GIMSK,temp
sei ;разрешаем прерывания

Gcykle: ;основной пустой цикл
rjmp Gcykle