 		opt f-g-h+l+o+
                org $1000
		
		
start		equ *		;wersja dla liczb 16 bitowych

		
WORD		equ $1003	;w tym bedzie dwu bajtowy wynik w postaci bcd
BYTE		equ $1000	;zmienna BYTE czyli co zmieniamy
		lda #$10	;liczba do zamiany
		sta BYTE	;i kolejnda liczba do zamiany, razem 16 
		lda #$10
		lda BYTE+1		
		lda #0		;zeruje WORDY
		sta WORD
		sta WORD+1
		sta WORD+2
		sta WORD+3
		sta WORD+4
		ldx #8		;tyle razy petla sie wykona, bo tyle bitow jest do sprawdzenia
		sed		;wlaczamy formatowanie do liczb dziesietnych D
cv1		asl BYTE	;przesowamy liczbe wchodzaca w lewo
		lda WORD	;wrzucamy do akumulatora WORD
		adc WORD	;dodajemy WORD-a do obecnej wartosci akumulatora
		sta WORD	;zamipujemy WORD
		rol WORD+1	;dopisujemy do konca WORD+1 kazdy kolejny bit bedacy w C
		dex		;zmniejszamy rejest X
		bne cv1		;sprawdzamy czy nie jest zerem

		ldx #8		;i analogicznie to samo co wyzej, tylko ze dla kolejnego bajtu
cv3		asl BYTE+1	
		lda WORD+3	
		adc WORD+3	
		sta WORD+3	
		rol WORD+4	
		dex		
		bne cv3				
		cld		


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

		lda WORD+3	
		and #15		;i znow to samo co wyzej, tylko juz dla wazniejszego bajtu	
		sta WORD+5	
		ldx #4		
cv4		lsr WORD+3	
		dex
		bne cv4
		clc		
		lda WORD+4	
		ldx WORD+3
		ldy WORD+5
		lda #48		
		adc WORD+4	
		sta WORD+4	
		clc
		lda #48
		adc WORD+5
		sta WORD+5
		clc
		lda #48
		adc WORD+3
		sta WORD+3
		
		
		lda WORD+1	;wypisuje sobie wynik w rejestrach dla mniej znaczacego bajtu
		ldx WORD
		ldy WORD+2

		lda WORD+4	;wypisuje sobie wynik w rejestrach dla bardziej znaczacego bajtu
		ldx WORD+3
		ldy WORD+5	

                org $2E0
                dta a(start)
                end of file
