.WARMST equ $FF7C
.OUTSTR equ $FFC7
.INCHAR equ $FFCD
.OUTPUT equ $FFAF
EOT		equ	$04

 ORG $100
 
 ;загружаем в индексный регистр адрес имени
 ldx #Name
 
read_name:
 jsr .INCHAR
 
 ;сохраняем символ
 staa 0,x
 ;увеличиваем содержимое индексного регистра
 inx
 
 cmpa #$d
 ;зацикливаем
 bne read_name
 
 ;пишем конец строки
 ldaa #EOT
 staa 0,x
 
 ;вывод строк
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