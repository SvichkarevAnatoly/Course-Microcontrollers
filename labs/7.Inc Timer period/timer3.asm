; ����������� ��������� ���������� �������(������� ������ ������� ���������������)

.WARMST equ $FF7C

; ��������� �������� ���
DELAY_START equ  $0100 ;?
; ���������� �������
DT equ  $0050 ;?
GLOB_DT_UP equ $0180 ;?
GLOB_DT_DOWN equ $0080 ;?

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
 
 ; ���������� ����� ��������� ����������� ������
 ldaa #MODE
 staa TCTL1
 
 ;��������� ������� ��-���������
 ldd CurDelay
 std TOC2
 
loop:
 ; �������� ������ �� �������
 ldd TOC2
 subd #GLOB_DT_UP
 bge if_change_sign
 
 ldd TOC2
 subd #GLOB_DT_DOWN
 bls if_change_sign
 
add_cur_delay:
 ; ������� ����������
 ldd CurDelay
 addd CurDT
 std CurDelay
 
 ; ���������� ����� �������� "����������"(����� �����������)
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
if_change_sign:
 ; ������ ���� CurDT
 ldd CurDT
 COMA
 COMB
 INCB ; �� ������ �����
 std CurDT
 jmp add_cur_delay

;--------------------------------------------------
;��������� ������
;--------------------------------------------------
; ���������� ��������
CurDelay:     FDB DELAY_START
CurDT:        FDB DT