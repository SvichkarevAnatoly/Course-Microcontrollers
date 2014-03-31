.WARMST equ $FF7C
; �������� ���
DELAY_HIGH equ  $0028;%0000001000000000
DELAY_LOW equ $0028;%0000000100000000
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
 
loop:
 ; ���������� ����� �������� "����������"(����� �����������) ������������ �� ������� ������
 ldd TOC2
 addd #DELAY_LOW
 std TOC2
 
 ; ����� ��������� �� ������� � �����
asking_low:
 ; ��������� ��������� ����� ������������ ������������
 ldaa TFLG1
 anda #ALARM_TRIGGERED
 cmpa #ALARM_TRIGGERED
 bne asking_low
 ; �������� ����
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ; ���������� ����� �������� "����������"(����� �����������) ������������ �� ������ ������
 ldd TOC2
 addd #DELAY_HIGH
 std TOC2

 ; ����� ��������� �� ������� � �����
asking_high:
 ldaa TFLG1
 anda #ALARM_TRIGGERED
 cmpa #ALARM_TRIGGERED
 bne asking_high
 ; �������� ����
 ldaa #ALARM_TRIGGERED
 staa TFLG1
 
 ;�����������
 jmp loop