; ����������� ����������
; ��������� ������� ����� ��������� ������� IC1

.WARMST equ $FF7C
.OUT2BS equ $FFC1 ;����� ���� ����

; ������� �������� ������ IC1
;���� ���������� ������ ������� �������
TIC1 equ $1010

; ������� - ��������� ����������� ������ 
;�������(�����) �� ������ PA0 (pin32) ��� ������ IC1

; ������� ����������� ������ �������
TCTL2 equ $1021
; �������� ������ ��� IC1
FRONT equ %00010000 ;? ����� ��?

; ����� �������� ������� ������������
TFLG1 equ $1023
; �������� ��� IC1F
EVENT_TRIGGERED equ %00000100

; ����� �������� ...
TMSK1 equ $1022
; �������� ��� IC1I
REGISTER_EVENT_TRIGGERED equ %00000100

; ��������� ��� ��������
DIVIDENT equ $1E84 ; �������
EIGHT equ $0008 ; �������


 ORG $100
 
 ; ������ �������������
 
 ; ���������� ����� ��������� ����������� ������
 ldaa #FRONT
 staa TCTL2

 ;? ��������� ���� ��� ����������� �������
 ldaa #REGISTER_EVENT_TRIGGERED
 staa TMSK1

; ���� ��������� �����
loop:

; ����� ��������� �� ������� � �����
asking:
 ; ��������� ��������� ����� ������������ ������������
 ldx #TFLG1
 ; ���� ���� �������, �� ���� �������
 brclr 0,x #EVENT_TRIGGERED asking
 ; �������� ����
 ldaa #EVENT_TRIGGERED
 staa TFLG1

 ; ��������� ����� ������� ������������ �������
 ldd TIC1
 std FirstEventTime
 
; ����� ��������� �� ������� � �����
asking2:
 ; ��������� ��������� ����� ������������ ������������
 ldx #TFLG1
 ; ���� ���� �������, �� ���� �������
 brclr 0,x #EVENT_TRIGGERED asking2
 ; �������� ����
 ldaa #EVENT_TRIGGERED
 staa TFLG1
 
 ; ��������� ������� �����
 ldd TIC1
 subd FirstEventTime
 std DiffEventTime
 
 ; �������� �������� �� ������ � �������
 ; ------------------------
 ; 2000000 Hz * 1/Ntakt
 ; ��������� �������� � Freq
 ldd #DIVIDENT
 ldx DiffEventTime
 idiv
 xgdx ;�����
 ; �����
 asld
 asld
 asld
 asld
 xgdx
 stx Freq
 
 ; �����
 asld
 asld
 asld
 asld
 ; ��������� 8
 addd #EIGHT
 
 ldx DiffEventTime
 idiv
 xgdx ;�����
 ; ������� �� ��������� � Freq
 addd Freq
 ; �����
 asld
 asld
 asld
 asld
 xgdx ;�����
 stx Freq
 
 ; �����
 asld
 asld
 asld
 asld
 
 ldx DiffEventTime
 idiv
 xgdx ;�����
 addd Freq
 std Freq
 ; ------------------------

 ; ������� ��������� ������� �������
 ldx #Freq
 jsr .OUT2BS

 ;�����������
 jmp loop
 

;--------------------------------------------------
;��������� ������(����� ����������������)
;--------------------------------------------------
; ���������� ������� �������
FirstEventTime:    FDB
DiffEventTime:     FDB
Freq:              FDB