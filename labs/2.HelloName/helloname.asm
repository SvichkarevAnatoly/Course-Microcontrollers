.WARMST equ $FF7C
.OUTSTR equ $FFC7
.INCHAR equ $FFCD
.OUTPUT equ $FFAF
EOT		equ	$04

 ORG $100
 
 ;��������� � ��������� ������� ����� �����
 ldx #Name
 
read_name:
 jsr .INCHAR
 
 ;��������� ������
 staa 0,x
 ;����������� ���������� ���������� ��������
 inx
 
 cmpa #$d
 ;�����������
 bne read_name
 
 ;����� ����� ������
 ldaa #EOT
 staa 0,x
 
 ;����� �����
 ldx #String
 jsr .OUTSTR
 
 ldx #Name
 jsr .OUTSTR
 
 ;jsr .INCHAR
 ;jsr .OUTPUT
 
 jsr .WARMST

String: FCC 'Hello '
		FCB EOT
Name:	FCC ''
		;FCB EOT