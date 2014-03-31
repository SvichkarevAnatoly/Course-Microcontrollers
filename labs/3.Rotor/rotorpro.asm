.WARMST equ $FF7C
.OUTSTR equ $FFC7
.INPUT  equ $FFAC
EOT		equ	$04

; значения фаз для вращение на шаг ротора
STEP1 equ $03
STEP2 equ $06
STEP3 equ $0c
STEP4 equ $09

;адрес порта ротора
ROTOR equ $1004

; константа задержки по умолчанию
DEF_DELAY equ $0900
; константа изменения скорости
DIF_DELAY equ $50

; константы направления
CW equ $00 ;по часовой стрелке
CCW equ $01 ;против часовой стрелке

; число циклов
LOOP_COUNT equ $0100
;--------------------------------------------------
;Программа
;--------------------------------------------------
 ORG $100

 ;ldy #LOOP_COUNT
main_loop:
 jsr .INPUT
 beq label4
 
 cmpa #'w ;клавиша 'w' - увеличение скорости
 beq speed_up

label1:
 cmpa #'s ;клавиша 's' - уменьшение скорости
 beq speed_down

label2:
 cmpa #'a ;клавиша 'a' - против часовой стрелке
 beq set_ccw
 
label3:
 cmpa #'d ;клавиша 'd' - по часовой стрелке
 beq set_cw

label4:
 ldx #Params
 ldaa 1,x
 cmpa CW
 beq rotate_cw
 bne rotate_ccw
 
 ;jsr rotate_cw

 bra main_loop
 ;dey
 ;bne main_loop

 jsr .WARMST

;--------------------------------------------------
;Подпрограммы
;--------------------------------------------------
 
; организуем цикл для задержки 3 мс
; инициализируем нулём
wait: 
 ;ldx #DEF_DELAY
 ldx Params
wait1:
 dex
 bne wait1
 rts
 
; увеличиваем скорость
speed_up:
 ldd Params
 subd #DIF_DELAY
 std Params
 bra label4
 
; увеличиваем скорость
speed_down:
 ldd Params
 addd #DIF_DELAY
 std Params
 bra label4

; устанавливаем режим по часовой стрелке
set_cw:
 ldaa CW
 ldx #Params
 staa 1,x
 bra label4

; устанавливаем режим против часовой стрелке
set_ccw:
 ldaa CCW
 ldx #Params
 staa 1,x
 bra label4
 
; организуем цикл вращения по часовой стрелке CW
rotate_cw:
 ldaa #STEP1
 staa ROTOR
 jsr wait
 ldaa #STEP2
 staa ROTOR
 jsr wait
 ldaa #STEP3
 staa ROTOR
 jsr wait
 ldaa #STEP4
 staa ROTOR
 jsr wait
 bra main_loop
 
; организуем цикл вращения против часовой стрелке CCW
rotate_ccw:
 ldaa #STEP4
 staa ROTOR
 jsr wait
 ldaa #STEP3
 staa ROTOR
 jsr wait
 ldaa #STEP2
 staa ROTOR
 jsr wait
 ldaa #STEP1
 staa ROTOR
 jsr wait
 jmp main_loop
 
;--------------------------------------------------
;Выделение памяти
;--------------------------------------------------
; параметры (задержка, направление)
Params: FDB DEF_DELAY
		FCB CW