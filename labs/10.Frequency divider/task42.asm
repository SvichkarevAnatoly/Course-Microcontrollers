; ���������� � ��������� � 5 ��� ����
;(������ ��������� ������� - ���������� �� ������ ����������)

;--------------------------------------------------
;��������� ��������
;--------------------------------------------------
.WARMST equ $FF7C

; ������� �������� ������ IC1
;���� ���������� ������ ������� �������
TIC1 equ $1010

; ����� �����������
TOC2 equ $1018

; �������� ��������� ������(��� ������)
ALARM_TRIGGERED equ %01000000

; ������� ����������� ������ �������
TCTL2 equ $1021
; �������� ������ ��� IC1
FRONT_IC1 equ %00010000

; ������� ����������� ������ �������
TCTL1 equ $1020
; �������� ������ ��� OC2
FRONT_OC2 equ %01000000

; ����� �������� ������� ������������
TFLG1 equ $1023
; �������� ��� IC1F
EVENT_TRIGGERED equ %00000100

; ����� �������� ...
TMSK1 equ $1022
; �������� ��� IC1I
REGISTER_EVENT_TRIGGERED equ %00000100

; ��� ����������
; ����� ������������� �� IC1
INTERRUPT_IC1 equ $00E8
INTERRUPT_IC1_PLUS_ONE equ $00E9
JMP equ $7E

DEFAULT_FREQ equ 2000

NUM_TEN equ 10 ; ��� ���������� �������

FLAG_ON equ 1
FLAG_OFF equ 0

;DELAY equ $03C8
;--------------------------------------------------
;������ ���������
;--------------------------------------------------
 ORG $100
 ; ������ �������������
 
 ; ���������� ����� ��������� ����������� ������
 ldaa #FRONT_IC1
 staa TCTL2
 
  ; ���������� ����� ��������� ����������� ������
 ldaa #FRONT_OC2
 staa TCTL1

 ldd #DEFAULT_FREQ
 std DiffEventTime

 ; ��������� ����������
 ; ��������� ���� ��� ����������� �������
 ldaa #REGISTER_EVENT_TRIGGERED
 staa TMSK1
 
 lda #JMP
 sta INTERRUPT_IC1
 ldd #period_calc
 std INTERRUPT_IC1_PLUS_ONE
 
 cli ;�������� ����� ����������
 
;--------------------------------------------------
; ���� ��������� �����
loop:
 
 ; ����������� ������� � 10 ���(��� ��� ��������� ���� ������)
 ;�.�. ����� ������� ������� �� 10
 ldd DiffEventTime
 ldx #NUM_TEN
 idiv
 stx NewPeriod
 
 ; if( Flag == FLAG_ON){
 ;     ��������� ������� �� �������
 ;     Flag = FLAG_OFF;
 ; }
 ldx Flag
 beq continue
 addd NewPeriod
 std NewPeriodOne
 ; ���������� ������
 ldaa #FLAG_OFF
 staa Flag
 
 ldd TOC2
 addd NewPeriodOne
 std TOC2
 
 jmp continue1
continue:
 ; ���������� ����� �������� "����������"(����� �����������) ������������ �� ������� ������
 ldd TOC2
 addd NewPeriod
 std TOC2
 
continue1:
 ; ����� ��������� �� ������� � �����
asking:
 ; ��������� ��������� ����� ������������ ������������
 ldx #TFLG1
 ; ���� ���� �������, �� ���� �������
 brclr 0,x #ALARM_TRIGGERED asking
 ; �������� ����
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ;�����������
 jmp loop
 
;--------------------------------------------------
; ������� �� ���������� ��� ������ �������

period_calc:
 ; �������� ����
 ldaa #EVENT_TRIGGERED
 staa TFLG1

 ; ��������� ����� ������������ �������
 ldd TIC1
 subd PrevEventTime
 ; ���������� ����� ������
 std DiffEventTime
 ldd TIC1
 std PrevEventTime
 
 ; ������������� ������
 ldaa #FLAG_ON
 staa Flag
 
 rti
 
;--------------------------------------------------
;��������� ������(����� ����������������)
;--------------------------------------------------
; ���������� ������� �������
PrevEventTime:    FDB 0
DiffEventTime:    FDB 3000

NewPeriod:        FDB
NewPeriodOne:     FDB
; ���� ������������ ����������
Flag:             FDB