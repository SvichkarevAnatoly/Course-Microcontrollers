.WARMST equ $FF7C
.OUTSTR equ $FFC7
.INPUT  equ $FFAC
EOT		equ	$04

; �������� ��� ��� �������� �� ��� ������
STEP1 equ $03
STEP2 equ $06
STEP3 equ $0c
STEP4 equ $09

;����� ����� ������
ROTOR equ $1004

; ��������� �������� �� ���������
DEF_DELAY equ $0900
; ��������� ��������� ��������
DIF_DELAY equ $50

; ��������� �����������
CW equ $00 ;�� ������� �������
CCW equ $01 ;������ ������� �������

; ����� ������
LOOP_COUNT equ $0100
;--------------------------------------------------
;���������
;--------------------------------------------------
 ORG $100

 ;ldy #LOOP_COUNT
main_loop:
 jsr .INPUT
 beq label4
 
 cmpa #'w ;������� 'w' - ���������� ��������
 beq speed_up

label1:
 cmpa #'s ;������� 's' - ���������� ��������
 beq speed_down

label2:
 cmpa #'a ;������� 'a' - ������ ������� �������
 beq set_ccw
 
label3:
 cmpa #'d ;������� 'd' - �� ������� �������
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
;������������
;--------------------------------------------------
 
; ���������� ���� ��� �������� 3 ��
; �������������� ����
wait: 
 ;ldx #DEF_DELAY
 ldx Params
wait1:
 dex
 bne wait1
 rts
 
; ����������� ��������
speed_up:
 ldd Params
 subd #DIF_DELAY
 std Params
 bra label4
 
; ����������� ��������
speed_down:
 ldd Params
 addd #DIF_DELAY
 std Params
 bra label4

; ������������� ����� �� ������� �������
set_cw:
 ldaa CW
 ldx #Params
 staa 1,x
 bra label4

; ������������� ����� ������ ������� �������
set_ccw:
 ldaa CCW
 ldx #Params
 staa 1,x
 bra label4
 
; ���������� ���� �������� �� ������� ������� CW
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
 
; ���������� ���� �������� ������ ������� ������� CCW
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
;��������� ������
;--------------------------------------------------
; ��������� (��������, �����������)
Params: FDB DEF_DELAY
		FCB CW