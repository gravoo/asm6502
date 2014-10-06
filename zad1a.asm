 		opt f-g-h+l+o+
                org $1000
		
		
start		equ *
RESOULT		equ $1009	;wynik
WORD		equ $1001	;jakies cyfry w ASCII
		lda #'0'
		sta WORD
		lda #'0'
		sta WORD+1
		lda #'1'
		sta WORD+2
	
		cld		;cyscimy znacznik na wsio
		lda WORD	;wczytujemy najmniej znaczacy bit
		sec		;ustawiamy znacznik sec
		sbc #'0'	;odejmujemy 48
		sta RESOULT	;ustawiamy wynik

		


		lda WORD+1	;wczytujemy kolejny, wazniejszy bit
		SEC		;ustawiamy znacznik sec
		sbc #'0'	;odejmujemy zero
		TAX 		;przerzucamy wartosc z akumulatora do rejestru X
		beq zero	;sprawdzamy czy rejestr nie jest rowny zero
		clc 		;czyscimy znacznik C
		lda #0		;zerujemy akumulator
cv1		adc #10		;tutaj dodajemy 10 tyle razy ile wynosi liczba WORD+1
		dex		;zmienszamy x
		bne cv1		;skaczemy do cv1
zero		clc		
		adc RESOULT	;dodajemy akumulator do wyniku
		sta RESOULT	;zapisujemy wynik
	
		lda WORD+2	;analogicznie to co wyzej
		SEC
		sbc #'0'
		TAX 
		beq zero1
		clc 
		lda #0
cv2		adc #100
		dex
		bne cv2
zero1		clc
		adc RESOULT
		sta RESOULT	;zapisujemy wynik w akumulatorze

	

		lda RESOULT

		


   		org $2E0
                dta a(start)

                end of file
