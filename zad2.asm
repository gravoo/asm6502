 		opt f-g-h+l+o+
                org $1000
		
		
start		equ *
DA		equ $1001		
DK		equ $1002
A		equ $1003
RESZTA		equ $1004
WYNIK		equ $1006
tmp		equ $1009		
		lda #$0
		
		sta RESZTA
		lda #$1
		sta DK
		lda #$11
		sta DA
		lda #$ff	
		sta A
		lda #$00
		sta WYNIK
		sta WYNIK+1
		lda #00
		sta tmp+1

		lda A
		CMP DK
		BCS nie16		;gdy dzielnik ma 8 bitow to skocz tu
		JSR DZIEL

nie16		lda A
		CMP DK
		BCC szesna		;gdzy dzielnik ma 16 bitow to skocz tu
		JSR DZIEL1



szesna		lda WYNIK+1
		ldx WYNIK
		ldy RESZTA
		BRK
	
DZIEL		LDX #8			;dziel
CYKL		asl WYNIK		;przesowamy wynik w lewo
		asl DA			;przesowamy LSB dzielnika w lewo
		ROL @			;dopisujemy do konca MSB dzielnika to co wypadnie z DA
		CMP DK			;porownujemy z DK, jesli akml<DK 
		BCC OMIN		;to skocz do omin
		SBC DK			;odejmowanie dzielnika od MSB dzielnej
		INC WYNIK		;zwiekszamy wynik o jeden
OMIN		DEX			;zmniejszamy petle
		BNE CYKL		;jesli x wiekszy od 0, skocz do CYKL
		STA RESZTA		;zapisujemy reszte
		RTS

DZIEL1					;dzielenie dla 16 bitow
		jsr spr			;skaczemy do procedury obliczajacej o ile ma sie przesunac dzielnik w lewo
		lda A		
		LDX #16

cykl1		ldy DK			
		clc
		asl WYNIK		;przesowamy wynik w lewo
		rol WYNIK+1		;w razie jak cos wypadnie z WYNIK, lapiemy do wynik+1
		asl DA			;przesowamy LSB w lewo
		ROL @			;lapiemy to co wypadnie z DA
		CMP DK			;porownyjemy z DK
		bcc nie			;jesli A wiekszy od DK to skocz do nie
		SBC DK			;odejmujemy od akmulatora DK
		clc
		INC WYNIK		;zwiekszamy wynik
		bcc dalej
		INC WYNIK+1		;jak cos wypadnie to lapiemy
dalej		nop
nie		dex
		bne cykl1		
		STA RESZTA
		RTS

spr		clc			
		sta tmp			;tmp, czyli MSB dzielej
sk		inc tmp+1		;liczymy kiedy sie wyzeruje
		lsr tmp
		bne sk
		lda DK
		sta tmp

sk2		dec tmp+1		;teraz zmniejszamy tmp+1 o tyle
		lsr tmp			;ile bitow ma MSB dzielnej
		bne sk2
		lda tmp+1
		tax
		clc
sk3		rol DK			;przesowamy dzielnik o tmp+1 pozycji
		dex
		bne sk3
		lda DK
		clc
		cmp A	
		bcs pomin
		lsr DK		
pomin		rts

		org $2E0
                dta a(start)
                end of file
