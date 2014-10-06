 		opt f-g-h+l+o+
                org $1000
		
		
start		equ *

		
WORD		equ $1001	;w tym bedzie dwu bajtowy wynik w postaci bcd
BYTE		equ $1000	;zmienna BYTE czyli co zmieniamy
		lda #199		;liczba do zamiany
		sta BYTE		
		lda #0		;zeruje WORDY
		sta WORD
		sta WORD+1
		ldx #8		;tyle razy petla sie wykona, bo tyle bitow jest do sprawdzenia
		sed		;wlaczamy formatowanie do liczb dziesietnych D
cv1		asl BYTE	;przesowamy liczbe wchodzaca w lewo
		lda WORD	;wrzucamy do akumulatora WORD
		adc WORD	;dodajemy WORD-a do obecnej wartosci akumulatora
		sta WORD	;zamipujemy WORD
		rol WORD+1	;dopisujemy do konca WORD+1 kazdy kolejny bit bedacy w C
		dex		;zmniejszamy rejest X
		bne cv1		;sprawdzamy czy nie jest zerem
		cld		;wylaczamy formatowanie D
		lda WORD	
		and #15		;anduje z 7 zeby sie ladnie bity wyzerowaly 	
		sta WORD+2	;zapisuje ladnie wyzerowane bity do WORD+2
		ldx #4		
cv2		lsr WORD	;przesuwam sobie WORD 4 razy w lewo aby byl sliczny i zeby dobrze sie do niego dodawalo
		dex
		bne cv2
		clc		;czyszcze znacznik
		lda WORD+1	
		ldx WORD
		ldy WORD+2
		lda #48		;do akumulatora przypisuje 48 czyli ZERO
		adc WORD+1	;dodaje 48 do WORD+1 
		sta WORD+1	;zapisuje z akml do WORD+1 (i tak jeszcze dwa razy, dla kazdego worda)
		clc
		lda #48
		adc WORD+2
		sta WORD+2
		clc
		lda #48
		adc WORD
		sta WORD
		
		
		lda WORD+1	;sprawdzam czy sie zgadza wszystko za pomoca rejestrow
		ldx WORD
		ldy WORD+2	

                org $2E0
                dta a(start)
                end of file
