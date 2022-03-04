; Program gwiazdki.asm
; Wyœwietlanie znaków * w takt przerwañ zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakoñczenie programu po naciœniêciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
 ASSUME CS:rozkazy 
;==========================================================================

; podprogram 'wyswietl_AL' wyœwietla zawartoœæ rejestru AL
; w postaci liczby dziesiêtnej bez znaku
wyswietl_AL PROC
; wyœwietlanie zawartoœci rejestru AL na ekranie wg adresu
; podanego w ES:BX
; stosowany jest bezpoœredni zapis do pamiêci ekranu
; przechowanie rejestrów
 push ax
 push cx
 push dx
  
 mov cl, 10 ; dzielnik
 mov ah, 0 ; zerowanie starszej czêœci dzielnej
; dzielenie liczby w AX przez liczbê w CL, iloraz w AL,
; reszta w AH (tu: dzielenie przez 10)
 div cl
 add ah, 30H ; zamiana na kod ASCII
 mov es:[bx+4], ah ; cyfra jednoœci
 mov ah, 0
 div cl ; drugie dzielenie przez 10
 add ah, 30H ; zamiana na kod ASCII
 mov es:[bx+2], ah ; cyfra dziesi¹tek
 add al, 30H ; zamiana na kod ASCII
 mov es:[bx+0], al ; cyfra setek
; wpisanie kodu koloru (intensywny bia³y) do pamiêci ekranu
 mov al, 00001111B
 mov es:[bx+1],al
 mov es:[bx+3],al
 mov es:[bx+5],al

; odtworzenie rejestrów
 pop dx
 pop cx
 pop ax
 ret ; wyjœcie z podprogramu
wyswietl_AL ENDP
;==========================================================================

; procedura obs³ugi przerwania zegarowego
obsluga_klaw PROC
; przechowanie u¿ywanych rejestrów
 push ax
 push bx
 push es
; wpisanie adresu pamiêci ekranu do rejestru ES - pamiêæ
; ekranu dla trybu tekstowego zaczyna siê od adresu B8000H,
; jednak do rejestru ES wpisujemy wartoœæ B800H,
; bo w trakcie obliczenia adresu procesor ka¿dorazowo mno¿y
; zawartoœæ rejestru ES przez 16
 mov ax, 0B800h ;adres pamiêci ekranu
 mov es, ax
; zmienna 'licznik' zawiera adres bie¿¹cy w pamiêci ekranu
 mov bx, cs:licznik
; przes³anie do pamiêci ekranu kodu ASCII wyœwietlanego znaku
; i kodu koloru: bia³y na czarnym tle (do nastêpnego bajtu)
 in al, 60h
 call wyswietl_AL
; zwiêkszenie o 2 adresu bie¿¹cego w pamiêci ekranu
		; add bx, 8, ¿eby siê ³adnie wyœwiet³a³o
; sprawdzenie czy adres bie¿¹cy osi¹gn¹³ koniec pamiêci ekranu
 cmp bx,4000
 jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie¿¹cego, gdy ca³y ekran zapisany
 mov bx, 0
;zapisanie adresu bie¿¹cego do zmiennej 'licznik'
wysw_dalej:
 mov cs:licznik,bx
; odtworzenie rejestrów
 pop es
 pop bx
 pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
 jmp dword PTR cs:wektor9
; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
; umieszczone s¹ w segmencie kodu
licznik dw 320 ; wyœwietlanie pocz¹wszy od 2. wiersza
wektor9 dd ?
obsluga_klaw ENDP


obsluga_klaw2 PROC
; przechowanie u¿ywanych rejestrów
 push ax
 push bx
 push es
 mov ax, 0B800h ;adres pamiêci ekranu
 mov es, ax
 mov bx, 0
 in al, 60h
 cmp al, 128
 jb pokaz2
 sub al, 128
 pokaz2:
 call wyswietl_AL

 pop es
 pop bx
 pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
 jmp dword PTR cs:wektor9
obsluga_klaw2 ENDP


;==========================================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
 ;mov al, 0
 ;mov ah, 5
 ;int 10
 mov ax, 0
 mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartoœci wektora nr 8 i zapisanie go
; w zmiennej 'wektor9' (wektor nr 8 zajmuje w pamiêci 4 bajty
; pocz¹wszy od adresu fizycznego 8 * 4 = 32)
 mov eax,ds:[36] ; adres fizyczny 0*16 + 32 = 32
 mov cs:wektor9, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
 mov ax, SEG obsluga_klaw ; czêœæ segmentowa adresu
 mov bx, OFFSET obsluga_klaw ; offset adresu
 cli ; zablokowanie przerwañ
; zapisanie adresu procedury do wektora nr 8
 mov ds:[36], bx ; OFFSET
 mov ds:[38], ax ; cz. segmentowa
 sti ;odblokowanie przerwañ

; oczekiwanie na naciœniêcie klawisza 'x'
aktywne_oczekiwanie:
 mov ah,1
 int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeœli
; naciœniêto jakiœ klawisz
 jz aktywne_oczekiwanie
; odczytanie kodu ASCII naciœniêtego klawisza (INT 16H, AH=0)
; do rejestru AL
 mov ah, 0
 int 16H
 cmp ah, 1 ; porównanie z scan codem escapea
 jne aktywne_oczekiwanie ; skok, gdy inny znak 
; deinstalacja procedury obs³ugi przerwania zegarowego
; odtworzenie oryginalnej zawartoœci wektora nr 8
 mov eax, cs:wektor9
 cli
 mov ds:[36], eax ; przes³anie wartoœci oryginalnej
 ; do wektora 8 w tablicy wektorów
 ; przerwañ
 sti
; zakoñczenie programu
 mov al, 0
 mov ah, 4CH
 int 21H
rozkazy ENDS
;==========================================================================

nasz_stos SEGMENT stack
 db 128 dup (?)
nasz_stos ENDS
END zacznij