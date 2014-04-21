; ����������� ��������� ���������� �������
; ��� ���������� ������ ������������ �������

.WARMST equ $FF7C

; ��������� �������� ���
DELAY_START equ  $0100 ;?
; ���������� �������
DT equ  10 ;?
DT_NEG equ -10 ;?

GLOB_DT_UP equ $1180 ;?
GLOB_DT_DOWN equ $100 ;?

; ������� ������ ������������
TCTL1 equ $1020
; �������� ��� ��������� ����������� ������ �� ������ �����������
MODE equ $40
; ����� �����������
TOC2 equ $1018
; �������� ��������� ������
ALARM_TRIGGERED equ %01000000
; ����� �������� ������� ������������ ������������
TFLG1 equ $1023

 ORG $100
 
 ; ������ �������������
 ldd #DELAY_START
 std CurDelay
 
 ldd #DT
 std CurDT
 
 ; ���������� ����� ��������� ����������� ������
 ldaa #MODE
 staa TCTL1
 
 ;��������� ������� ��-���������
 ldd CurDelay
 std TOC2
 
loop:
 ; �������� ������ �� �������
 ldd CurDelay
 cmpd #GLOB_DT_UP
 bhs if_reached_up
 
 ldd CurDelay
 cmpd #GLOB_DT_DOWN
 bls if_reached_down
 
add_cur_delay:
 ; ������� ����������
 ldd CurDelay
 addd CurDT
 std CurDelay
 
 ; ����� ��������� �� ������� � ������
 ; 
 ; 1/CurDelay = CurTDelay ���������� �������
 ldd #1000 ; ����� �������� ����������� �������
 ldx #CurDelay
 idiv
 stx CurTDelay
 
 ; ���������� ����� �������� "����������"(����� �����������)
 ldd TOC2
 addd CurTDelay
 std TOC2
 
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

; ��� ���������
;�������� ������� ������� -
if_reached_up:
 ;������ ���� � ����������
 ldd #DT_NEG
 std CurDT
 ;������������� ����� ������,
 ;������ ������� �������
 ldd #GLOB_DT_UP
 std CurDelay
 jmp add_cur_delay

;�������� ������ �������
if_reached_down:
 ldd #DT
 std CurDT
 ldd #GLOB_DT_DOWN
 std CurDelay
 jmp add_cur_delay
;--------------------------------------------------
;��������� ������(����� ����������������)
;--------------------------------------------------
; ���������� ��������
CurDelay:     FDB DELAY_START
CurTDelay:     FDB DELAY_START
CurDT:        FDB DT