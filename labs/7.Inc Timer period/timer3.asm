; реализовать генератор качающейс€ частоты(сначала период линейно увеличивающийс€)

.WARMST equ $FF7C

; начальна€ задержка фаз
DELAY_START equ  $0100 ;?
; приращение периода
DT equ  $0050 ;?
GLOB_DT_UP equ $0180 ;?
GLOB_DT_DOWN equ $0080 ;?

; регистр режима компараторов
TCTL1 equ $1020
; значение дл€ изменение логического уровн€ на втором компараторе
MODE equ $40
; адрес компаратора
TOC2 equ $1018
; значение подн€того флажка
ALARM_TRIGGERED equ %01000000
; адрес регистра флажков срабатывани€ компараторов
TFLG1 equ $1023

 ORG $100
 
 ; установить режим изменени€ логического уровн€
 ldaa #MODE
 staa TCTL1
 
 ;установка периода по-умолчанию
 ldd CurDelay
 std TOC2
 
loop:
 ; проверка выхода за границу
 ldd TOC2
 subd #GLOB_DT_UP
 bge if_change_sign
 
 ldd TOC2
 subd #GLOB_DT_DOWN
 bls if_change_sign
 
add_cur_delay:
 ; добавим приращение
 ldd CurDelay
 addd CurDT
 std CurDelay
 
 ; установить новое значение "будильника"(через прибавление)
 std TOC2
 
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

; дл€ ветвлений
if_change_sign:
 ; мен€ем знак CurDT
 ldd CurDT
 COMA
 COMB
 INCB ; Ќе совсем верно
 std CurDT
 jmp add_cur_delay

;--------------------------------------------------
;¬ыделение пам€ти
;--------------------------------------------------
; переменна€ задержки
CurDelay:     FDB DELAY_START
CurDT:        FDB DT