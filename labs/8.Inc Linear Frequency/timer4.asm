; реализовать генератор качающейся частоты
; все приращения теперь относительно частоты

.WARMST equ $FF7C

; начальная задержка фаз
DELAY_START equ  $0100 ;?
; приращение периода
DT equ  10 ;?
DT_NEG equ -10 ;?

GLOB_DT_UP equ $1180 ;?
GLOB_DT_DOWN equ $100 ;?

; регистр режима компараторов
TCTL1 equ $1020
; значение для изменение логического уровня на втором компараторе
MODE equ $40
; адрес компаратора
TOC2 equ $1018
; значение поднятого флажка
ALARM_TRIGGERED equ %01000000
; адрес регистра флажков срабатывания компараторов
TFLG1 equ $1023

 ORG $100
 
 ; секция инициализации
 ldd #DELAY_START
 std CurDelay
 
 ldd #DT
 std CurDT
 
 ; установить режим изменения логического уровня
 ldaa #MODE
 staa TCTL1
 
 ;установка периода по-умолчанию
 ldd CurDelay
 std TOC2
 
loop:
 ; проверка выхода за границу
 ldd CurDelay
 cmpd #GLOB_DT_UP
 bhs if_reached_up
 
 ldd CurDelay
 cmpd #GLOB_DT_DOWN
 bls if_reached_down
 
add_cur_delay:
 ; добавим приращение
 ldd CurDelay
 addd CurDT
 std CurDelay
 
 ; здесь переводим из частоты в период
 ; 
 ; 1/CurDelay = CurTDelay приращение периода
 ldd #1000 ; чтобы получили осмысленное деление
 ldx #CurDelay
 idiv
 stx CurTDelay
 
 ; установить новое значение "будильника"(через прибавление)
 ldd TOC2
 addd CurTDelay
 std TOC2
 
 ; опрос случилось ли событие в цикле
asking:
 ; считываем состояние порта срабатываний компараторов
 ldx #TFLG1
 ; если была единица, то было событие
 brclr 0,x #ALARM_TRIGGERED asking
 ; сбросить флаг
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ;зацикливаем
 jmp loop

; для ветвлений
;достигли верхней границы -
if_reached_up:
 ;меняем знак у прирощения
 ldd #DT_NEG
 std CurDT
 ;устанавливаем новый период,
 ;равный верхней границе
 ldd #GLOB_DT_UP
 std CurDelay
 jmp add_cur_delay

;достигли нижней границы
if_reached_down:
 ldd #DT
 std CurDT
 ldd #GLOB_DT_DOWN
 std CurDelay
 jmp add_cur_delay
;--------------------------------------------------
;Выделение памяти(нужно инициализировать)
;--------------------------------------------------
; переменная задержки
CurDelay:     FDB DELAY_START
CurTDelay:     FDB DELAY_START
CurDT:        FDB DT