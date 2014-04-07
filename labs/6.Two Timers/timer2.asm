; ������������� ��� �������,
;��� ������ ������ OC1 � OC2

.WARMST equ $FF7C

; �������� ���
DELAY equ $0001

; ������� ������ ������������
TCTL1 equ $1020
; �������� ��� ��������� �������� ����������� ������ ��� 2-�� �����������
MODE2 equ $C0

; ����� ��� ���������� ������� �����������
OC1D equ $100D
; �������� ��� ��������� ������� ����������� ������ ��� 1-�� �����������
MODE1 equ $00 ;?


; ������ ������������(��������)
TOC1 equ $1016
TOC2 equ $1018

; ��������� ��������� ������ OC1 �� ����� OC2
OC1M equ $100C
PA6 equ $40

; �������� ��������� ������(�� 1 ��� 2 ������)
ALARM_TRIGGERED equ %11000000
; ����� �������� ������� ������������ ������������
TFLG1 equ $1023


 ORG $100
 
 ; ��������� ��������� ������ OC1 �� ����� OC2
 ldaa #PA6
 staa OC1M
 
 ; ���������� ������ 1-�� �����������
 ldaa #MODE1
 staa OC1D
 ; ���������� ������ 2-�� �����������
 ldaa #MODE2
 staa TCTL1
 
loop:
 ; ���������� ����� �������� "����������"(����� �����������) ������������ �� ������� ������
 ;��� ������� �����������
 ldd TOC2
 addd #DELAY
 std TOC2
 ;��� ������� �����������
 addd #DELAY
 std TOC1
 
 ; ����� ��������� �� ������� � �����
asking:
 ldx #TFLG1
 ; ���� ���� ������� � ����� �� ���� �����, �� ���� �������
 brclr 0,x #ALARM_TRIGGERED asking
 ; �������� ����
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 
 ;�����������
 jmp loop