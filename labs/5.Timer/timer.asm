.WARMST equ $FF7C
; задержки фаз
DELAY_HIGH equ  $0028;%0000001000000000
DELAY_LOW equ $0028;%0000000100000000
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
 
 ; установить режим изменения логического уровня
 ldaa #MODE
 staa TCTL1
 
loop:
 ; установить новое значение "будильника"(через прибавление) переключение на высокий сигнал
 ldd TOC2
 addd #DELAY_LOW
 std TOC2
 
 ; опрос случилось ли событие в цикле
asking_low:
 ; считываем состояние порта срабатываний компараторов
 ldaa TFLG1
 anda #ALARM_TRIGGERED
 cmpa #ALARM_TRIGGERED
 bne asking_low
 ; сбросить флаг
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ; установить новое значение "будильника"(через прибавление) переключение на низкий сигнал
 ldd TOC2
 addd #DELAY_HIGH
 std TOC2

 ; опрос случилось ли событие в цикле
asking_high:
 ldaa TFLG1
 anda #ALARM_TRIGGERED
 cmpa #ALARM_TRIGGERED
 bne asking_high
 ; сбросить флаг
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ;зацикливаем
 jmp loop