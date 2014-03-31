.WARMST equ $FF7C
.OUTSTR equ $FFC7
EOT		equ	$04

 ORG $100
 ldx #String
 jsr .OUTSTR
 jsr .WARMST

String: FCC 'Hello'
		FCB EOT