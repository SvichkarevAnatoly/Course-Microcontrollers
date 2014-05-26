; частотомер и генератор в 5 раз чаще
;(вешаем медленное событие - частотомер на вектор прерывани€)

;--------------------------------------------------
;«аведение констант
;--------------------------------------------------
.WARMST equ $FF7C

; регистр входного канала IC1
;сюда происходит запись времени событи€
TIC1 equ $1010

; адрес компаратора
TOC2 equ $1018

; значение подн€того флажка(дл€ замера)
ALARM_TRIGGERED equ %01000000

; регистр определени€ фронта сигнала
TCTL2 equ $1021
; значение фронта дл€ IC1
FRONT_IC1 equ %00010000

; регистр определени€ фронта сигнала
TCTL1 equ $1020
; значение фронта дл€ OC2
FRONT_OC2 equ %01000000

; адрес регистра флажков срабатывани€
TFLG1 equ $1023
; значение дл€ IC1F
EVENT_TRIGGERED equ %00000100

; адрес регистра ...
TMSK1 equ $1022
; значение дл€ IC1I
REGISTER_EVENT_TRIGGERED equ %00000100

; дл€ прерываний
; адрес псевдовектора на IC1
INTERRUPT_IC1 equ $00E8
INTERRUPT_IC1_PLUS_ONE equ $00E9
JMP equ $7E

DEFAULT_FREQ equ 2000

NUM_TEN equ 10 ; дл€ увеличени€ частоты

FLAG_ON equ 1
FLAG_OFF equ 0

;DELAY equ $03C8
;--------------------------------------------------
;Ќачало программы
;--------------------------------------------------
 ORG $100
 ; секци€ инициализации
 
 ; установить режим изменени€ логического уровн€
 ldaa #FRONT_IC1
 staa TCTL2
 
  ; установить режим изменени€ логического уровн€
 ldaa #FRONT_OC2
 staa TCTL1

 ldd #DEFAULT_FREQ
 std DiffEventTime

 ; настройка прерываний
 ; установка бита дл€ регистрации событий
 ldaa #REGISTER_EVENT_TRIGGERED
 staa TMSK1
 
 lda #JMP
 sta INTERRUPT_IC1
 ldd #period_calc
 std INTERRUPT_IC1_PLUS_ONE
 
 cli ;очистить маску прерываний
 
;--------------------------------------------------
; тело основного цикла
loop:
 
 ; увеличиваем частоту в 10 раз(так как считывали весь период)
 ;т.е. делим разницу времени на 10
 ldd DiffEventTime
 ldx #NUM_TEN
 idiv
 stx NewPeriod
 
 ; if( Flag == FLAG_ON){
 ;     прибавить остаток от делени€
 ;     Flag = FLAG_OFF;
 ; }
 ldx Flag
 beq continue
 addd NewPeriod
 std NewPeriodOne
 ; сбрасываем флажок
 ldaa #FLAG_OFF
 staa Flag
 
 ldd TOC2
 addd NewPeriodOne
 std TOC2
 
 jmp continue1
continue:
 ; установить новое значение "будильника"(через прибавление) переключение на высокий сигнал
 ldd TOC2
 addd NewPeriod
 std TOC2
 
continue1:
 ; опрос случилось ли событие в цикле
asking:
 ; считываем состо€ние порта срабатываний компараторов
 ldx #TFLG1
 ; если была единица, то было событие
 brclr 0,x #ALARM_TRIGGERED asking
 ; сбросить флаг
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ;зацикливаем
 jmp loop
 
;--------------------------------------------------
; переход по прерыванию дл€ замера периода

period_calc:
 ; сбросить флаг
 ldaa #EVENT_TRIGGERED
 staa TFLG1

 ; сохран€ем врем€ срабатывани€ событи€
 ldd TIC1
 subd PrevEventTime
 ; фактически здесь период
 std DiffEventTime
 ldd TIC1
 std PrevEventTime
 
 ; устанавливаем флажок
 ldaa #FLAG_ON
 staa Flag
 
 rti
 
;--------------------------------------------------
;¬ыделение пам€ти(нужно инициализировать)
;--------------------------------------------------
; сохранение времени событи€
PrevEventTime:    FDB 0
DiffEventTime:    FDB 3000

NewPeriod:        FDB
NewPeriodOne:     FDB
; флаг срабатывани€ прерывани€
Flag:             FDB