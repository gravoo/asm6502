 		opt f-g-h+l+o+
                org $1000
		
		
start		equ *
tablica		equ $0100
tabptr		EQU $00
rozmiar		equ $ff03
cur_val		equ $ff06
licz		equ $ff08
check		equ $ff0a
mnozenie	equ $ff0e
tmp		equ $ff10
tmp3		equ $ff14
		
		lda <tablica	;LSB adresu tablicy
 		sta tabptr	;zapisujemy MSB do tabtptr
  		lda >tablica	;MSB adresu tablicy 
  		sta tabptr+1	;zapisujemy LSB do tabptr+1
		
		lda #45		;ladujemy rozmiar do akumulatora
		sta rozmiar+1	;zapisujemy to MSB rozmiar+1

		lda >tablica
		sta tabptr+1
		lda <tablica
		sta tabptr
		ldy #00
		clc
		lda #01
		sta (tabptr),y		
		iny
		sta (tabptr),y

		lda #00
		sta cur_val
		sta cur_val+1
		sta licz
		ldx #01
		jmp etykieta
		org $bb00
koniec		jmp def_koniec

etykieta
k_skok
new		lda #00
		sta check
		sta licz+1
		jsr mnoze	;mnozymy MSB obecnie sprawdzanej czesci tablicy
		lda rozmiar+1	;porownujemy z rozmiarem
		cmp mnozenie	;if mnozenie>rozmiar+1 to papa
		bcc koniec	;jesli mnozenie okazalo sie wieksze to nara
		inx		;obecna pozycja na ktorej sprawdzamy
		txa		
		tay		
		dec tabptr+1	;zmniejszamy o jeden wartosc na tabptr+1 bo w tym momencie ma 01
		lda tabptr+1	;wrzucamy do akumulatora
		inc tabptr+1	;przywracamy poprzednia wartosc tabptr+1
		sta cur_val+1	;zapisujemy z akm, MSB tabptr+1
		lda (tabptr),y	;sciagamy do akumulatora to co jest pod tym adresem			
		sta cur_val	;zapisujemy do cur_val aktualna wartosc lsb
		bne k_skok	;jesli wartosc jest 0 to przechodzimy dalej
		clc
		txa
		sta licz
		sta check
		asl licz	;mnozymy licz *2
		lda #0
		adc licz+1	;zbieramy to co moze wypasc
		sta licz+1
zerko
od_nowa		
		
jeszcze_raz	lda licz+1	;wczytujemy MSB potencjalnie do wykreslenia liczby
		cmp cur_val+1	;jesli licz+1 jest takie rozne co obecna wartosc MSB danego indeksu
		bne rozne	;to trzeba zwiekszyc MSB indeksu
		lda licz	;to wczytujemy LSB
		tay		;zapisujemy do y indeks ktory zostanie wykreslony
		lda #1		;wpisujemy do aku 1
		sta (tabptr),y  ;wykreslamy licz+1
		clc
		lda check
		adc licz
		sta licz
		lda #0
		adc licz+1
		sta licz+1
		lda licz	;jesli licz nie jest zerem to wracamy
		bne zerko	;a jak jest
		lda tabptr+1	;wczytujemy
		sta cur_val+1	;zapisujemy
		inc tabptr+1    ;zwiekszamy tabptr
		cmp rozmiar+1	;porownujemy z rozmiarem
		bne od_nowa	;jesli cur_val jest rozny od rozmiaru+1 to wracamy 
		lda >tablica	;jesli jednak beda kiedys beda rowne rowne to trzeba zaczac od poczatku
		sta tabptr+1
		jmp new

rozne		lda tabptr+1	;wczytujemy
		sta cur_val+1	;zapisujemy
		inc tabptr+1    ;zwiekszamy tabptr
		cmp rozmiar+1	;porownujemy z rozmiarem
		bne jeszcze_raz	;jesli cur_val jest rozny od rozmiaru+1 to wracamy 
		clc		;dla zasady
		lda >tablica
		sta tabptr+1
		jmp new
def_koniec			;dyfinitywny koniec petli	
		
		lda <tablica
		sta tabptr
		lda >tablica
		sta tabptr+1
		ldy #02
				

		
	
		jmp wypisz

 	        org $dd00
wypisz
text            equ *
text2		equ $dddd
tmp_l		equ $ef05
licznik		equ $ef08

		lda <text
                sta $80
                lda >text
                sta $81   
         	lda #32
                sta text+4
                lda #0
                sta text+5
		
		
		ldy #01
           	lda tabptr+1
		jsr phex
		ldy #03
		lda #02
		jsr phex
		lda <text
                ldx >text
                jsr $ff80
		
				;ostatnia faza !!
		ldy #01

skok		iny
		beq zerol	;jesli przelecimy cala petle
i_skok		lda (tabptr),y	;sprawdzamy co jest pod tym adresem		
		bne skok	;jesli zero to pieknie
		tya		;sciagamy pozycje z rejestru y
		sta tmp_l	;i zapisujemy do tmp_l
		dec tabptr+1	;zmniejszamy MSB adresu talibcy bo zaczyna sie od 01 a chcemy wartosc
		lda tabptr+1	;ladujemy do aku
		inc tabptr+1	;przywracamy poprzednia wartosc, w aku wartosc o jeden mniejsza
		ldy #01		;pierwsza czesc stringa
		jsr phex	;zamieniamy na hex
		ldy #03		;druga czesc stringa
		lda tmp_l	;ladujemy lsb do aku
		jsr phex	;zamieniamy na hex
		lda <text	;wypisywanko
                ldx >text	;tu
                jsr $ff80	;funkcja wypisujaca
		ldy tmp_l
		bne skok
zerol		lda tabptr+1
		inc tabptr+1
		cmp rozmiar+1	;if rozmiar+1 != tabptr+1 to skok
		bne i_skok	;to inny skok
		brk

		org $ee00

phex            pha		;funckja pana zawady, zamienia to co dostaje na reprezentacje hex
                jsr pxdig
                pla
                lsr @
                lsr @
                lsr @
                lsr @
pxdig           and #%00001111
                ora #'0'
                cmp #'9'+1
                bcc pr
                adc #'A'-'9'-2
pr              sta ($80),y
                dey
                rts


		org $ef00	;mnozenie dwoch liczb, najwazniejszy jest MSB ilorazu
mnoze		lda #08
		sta tmp3		
		txa
		sta mnozenie
		sta mnozenie+1	
		lda #00
		sta tmp
cykl		lsr mnozenie
		bcc nied
		clc
		adc mnozenie+1
nied		ror @
		ror tmp
		dec tmp3
		bne cykl
		sta mnozenie
		lda mnozenie+1
		sta mnozenie+1
		rts

		org $2E0
                dta a(start)

                end of file
