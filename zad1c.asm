 		opt f-g-h+l+o+
                org $1000
		
		
start		equ *
RESOULT		equ $1009	;wynik
WORD		equ $1001	;jakies cyfry w ASCII
PODSTAWA 	equ $100D
		lda #'5'
		sta WORD
		lda #'3'
		sta WORD+1
		lda #'5'
		sta WORD+2
		lda #'0'
		sta WORD+3
		lda #'5'
		sta WORD+4
	
		cld		;cyscimy znacznik na wsio
		lda WORD	;wczytujemy najmniej znaczacy bit
		sec		;ustawiamy znacznik sec
		sbc #'0'	;odejmujemy 48
		sta RESOULT	;ustawiamy wynik
		lda #0
		sta RESOULT+1
		clc 
		

		
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

		lda #100
		sta PODSTAWA
		lda WORD+2	;analogicznie to co wyzej
		SEC
		sbc #'0'
		clc
		TAX 		
		beq zero1	;sprawdzam czy wartosc nie jest zerem
		lda #0
cv2	 	adc PODSTAWA	;dodajemy podstawe 
		BCC DALEJ	;jesli wyskoczy znaczkic C to zwiekszamy drugi bajt o jeden
		INC RESOULT+1
		clc		;czyscimy c zeby nie przeszkadzalo
DALEJ		dex
		bne cv2
zero1		adc RESOULT
		sta RESOULT	;zapisujemy wynik w akumulatorze
		BCC DALEJ6	;i znow jak wyskoczy przeniesienie, dodajemy do wazniejszego bajtu 1
		INC RESOULT+1
DALEJ6		clc
		

		lda #$e8	;mniej wazny bit 1000
		sta PODSTAWA
		lda #$3		;wazniejszy bit 1000
		sta PODSTAWA+1
		lda WORD+3	;analogicznie to co wyzej
		SEC
		sbc #'0'
		clc 
		TAX 
		beq zero2
		lda #0
		ldy #0
		pha 		;na stos wrzucamy 0
cv3		TYA	 	;do rejestru Y wrzucamy to co jest w akumulatorze
		adc PODSTAWA
		TAY		;do akumulatora wrzucamy to co w rejestrze Y
		BCC DALEJ1	;jak wyszkoczy C to dodajemy 1 do kolejnego bajtu
		INC RESOULT+1
		clc
DALEJ1		pla		;sciagamy ze stosu to co wrzucilismy wczesniej
		adc PODSTAWA+1
		pha 		;wrzucamy na stos wynik dodawania wazniejszych bajtow
		dex
		bne cv3
zero2		TYA		;sciagamy z rejestru Y wynik dodawania mniej waznych bajtow
		adc RESOULT
		sta RESOULT	;zapisujemy wynik w akumulatorze

		BCC DALEJ2	;jak wyczkoczy C to 
		INC RESOULT+1
		clc
DALEJ2		pla		;sciagamy wynik dodawania wazniejszych bajtow
		adc RESOULT+1
		sta RESOULT+1
		

		ldy #0		;analogicznie to co wyzej dla 10 000
 		lda #$10
		sta PODSTAWA
		lda #$27
		sta PODSTAWA+1
		lda WORD+4	
		SEC
		sbc #'0'
		clc 
		TAX 
		beq zero3
		clc 
		lda #0
		pha 
cv4		TYA	 	
		adc PODSTAWA
		TAY
		BCC DALEJ3
		INC RESOULT+1
		clc
DALEJ3		pla
		adc PODSTAWA+1
		clc 
		pha 
		dex
		bne cv4
zero3		TYA
		adc RESOULT
		sta RESOULT	;zapisujemy wynik w akumulatorze

		BCC DALEJ4
		INC RESOULT+1
		clc

DALEJ4		pla
		adc RESOULT+1
		sta RESOULT+1

		ldx RESOULT	;mniej wazny bit
		lda RESOULT+1	;wazniejszy bit
		


   		org $2E0
                dta a(start)

                end of file
