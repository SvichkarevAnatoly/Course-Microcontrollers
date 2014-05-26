; реализовать частотомер
; используя входной канал основного таймера IC1

.WARMST equ $FF7C
.OUT2BS equ $FFC1 ;вывод двух байт

; регистр входного канала IC1
;сюда происходит запись времени события
TIC1 equ $1010

; событие - изменение логического уровня 
;сигнала(фронт) на выходе PA0 (pin32) для канала IC1

; регистр определения фронта сигнала
TCTL2 equ $1021
; значение фронта для IC1
FRONT equ %00010000 ;? такой ли?

; адрес регистра флажков срабатывания
TFLG1 equ $1023
; значение для IC1F
EVENT_TRIGGERED equ %00000100

; адрес регистра ...
TMSK1 equ $1022
; значение для IC1I
REGISTER_EVENT_TRIGGERED equ %00000100

; константы для перевода
DIVIDENT equ $1E84 ; делимое
EIGHT equ $0008 ; остаток


 ORG $100
 
 ; секция инициализации
 
 ; установить режим изменения логического уровня
 ldaa #FRONT
 staa TCTL2

 ;? установка бита для регистрации событий
 ldaa #REGISTER_EVENT_TRIGGERED
 staa TMSK1

; тело основного цикла
loop:

; опрос случилось ли событие в цикле
asking:
 ; считываем состояние порта срабатываний компараторов
 ldx #TFLG1
 ; если была единица, то было событие
 brclr 0,x #EVENT_TRIGGERED asking
 ; сбросить флаг
 ldaa #EVENT_TRIGGERED
 staa TFLG1

 ; сохраняем время первого срабатывания события
 ldd TIC1
 std FirstEventTime
 
; опрос случилось ли событие в цикле
asking2:
 ; считываем состояние порта срабатываний компараторов
 ldx #TFLG1
 ; если была единица, то было событие
 brclr 0,x #EVENT_TRIGGERED asking2
 ; сбросить флаг
 ldaa #EVENT_TRIGGERED
 staa TFLG1
 
 ; вычисляем разницу времён
 ldd TIC1
 subd FirstEventTime
 std DiffEventTime
 
 ; алгоритм перевода из тактов в частоту
 ; ------------------------
 ; 2000000 Hz * 1/Ntakt
 ; результат сохраним в Freq
 ldd #DIVIDENT
 ldx DiffEventTime
 idiv
 xgdx ;обмен
 ; сдвиг
 asld
 asld
 asld
 asld
 xgdx
 stx Freq
 
 ; сдвиг
 asld
 asld
 asld
 asld
 ; прибавить 8
 addd #EIGHT
 
 ldx DiffEventTime
 idiv
 xgdx ;обмен
 ; сложить со значением в Freq
 addd Freq
 ; сдвиг
 asld
 asld
 asld
 asld
 xgdx ;обмен
 stx Freq
 
 ; сдвиг
 asld
 asld
 asld
 asld
 
 ldx DiffEventTime
 idiv
 xgdx ;обмен
 addd Freq
 std Freq
 ; ------------------------

 ; выводим результат времени события
 ldx #Freq
 jsr .OUT2BS

 ;зацикливаем
 jmp loop
 

;--------------------------------------------------
;Выделение памяти(нужно инициализировать)
;--------------------------------------------------
; сохранение времени события
FirstEventTime:    FDB
DiffEventTime:     FDB
Freq:              FDB