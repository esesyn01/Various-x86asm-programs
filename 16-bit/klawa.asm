; Program gwiazdki.asm
; Wy�wietlanie znak�w * w takt przerwa� zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zako�czenie programu po naci�ni�ciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
 ASSUME CS:rozkazy 
;==========================================================================

; podprogram 'wyswietl_AL' wy�wietla zawarto�� rejestru AL
; w postaci liczby dziesi�tnej bez znaku
wyswietl_AL PROC
; wy�wietlanie zawarto�ci rejestru AL na ekranie wg adresu
; podanego w ES:BX
; stosowany jest bezpo�redni zapis do pami�ci ekranu
; przechowanie rejestr�w
 push ax
 push cx
 push dx
  
 mov cl, 10 ; dzielnik
 mov ah, 0 ; zerowanie starszej cz�ci dzielnej
; dzielenie liczby w AX przez liczb� w CL, iloraz w AL,
; reszta w AH (tu: dzielenie przez 10)
 div cl
 add ah, 30H ; zamiana na kod ASCII
 mov es:[bx+4], ah ; cyfra jedno�ci
 mov ah, 0
 div cl ; drugie dzielenie przez 10
 add ah, 30H ; zamiana na kod ASCII
 mov es:[bx+2], ah ; cyfra dziesi�tek
 add al, 30H ; zamiana na kod ASCII
 mov es:[bx+0], al ; cyfra setek
; wpisanie kodu koloru (intensywny bia�y) do pami�ci ekranu
 mov al, 00001111B
 mov es:[bx+1],al
 mov es:[bx+3],al
 mov es:[bx+5],al

; odtworzenie rejestr�w
 pop dx
 pop cx
 pop ax
 ret ; wyj�cie z podprogramu
wyswietl_AL ENDP
;==========================================================================

; procedura obs�ugi przerwania zegarowego
obsluga_klaw PROC
; przechowanie u�ywanych rejestr�w
 push ax
 push bx
 push es
; wpisanie adresu pami�ci ekranu do rejestru ES - pami��
; ekranu dla trybu tekstowego zaczyna si� od adresu B8000H,
; jednak do rejestru ES wpisujemy warto�� B800H,
; bo w trakcie obliczenia adresu procesor ka�dorazowo mno�y
; zawarto�� rejestru ES przez 16
 mov ax, 0B800h ;adres pami�ci ekranu
 mov es, ax
; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
 mov bx, cs:licznik
; przes�anie do pami�ci ekranu kodu ASCII wy�wietlanego znaku
; i kodu koloru: bia�y na czarnym tle (do nast�pnego bajtu)
 in al, 60h
 call wyswietl_AL
; zwi�kszenie o 2 adresu bie��cego w pami�ci ekranu
		; add bx, 8, �eby si� �adnie wy�wiet�a�o
; sprawdzenie czy adres bie��cy osi�gn�� koniec pami�ci ekranu
 cmp bx,4000
 jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie��cego, gdy ca�y ekran zapisany
 mov bx, 0
;zapisanie adresu bie��cego do zmiennej 'licznik'
wysw_dalej:
 mov cs:licznik,bx
; odtworzenie rejestr�w
 pop es
 pop bx
 pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
 jmp dword PTR cs:wektor9
; dane programu ze wzgl�du na specyfik� obs�ugi przerwa�
; umieszczone s� w segmencie kodu
licznik dw 320 ; wy�wietlanie pocz�wszy od 2. wiersza
wektor9 dd ?
obsluga_klaw ENDP


obsluga_klaw2 PROC
; przechowanie u�ywanych rejestr�w
 push ax
 push bx
 push es
 mov ax, 0B800h ;adres pami�ci ekranu
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
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
 jmp dword PTR cs:wektor9
obsluga_klaw2 ENDP


;==========================================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
 ;mov al, 0
 ;mov ah, 5
 ;int 10
 mov ax, 0
 mov ds,ax ; zerowanie rejestru DS
; odczytanie zawarto�ci wektora nr 8 i zapisanie go
; w zmiennej 'wektor9' (wektor nr 8 zajmuje w pami�ci 4 bajty
; pocz�wszy od adresu fizycznego 8 * 4 = 32)
 mov eax,ds:[36] ; adres fizyczny 0*16 + 32 = 32
 mov cs:wektor9, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
 mov ax, SEG obsluga_klaw ; cz�� segmentowa adresu
 mov bx, OFFSET obsluga_klaw ; offset adresu
 cli ; zablokowanie przerwa�
; zapisanie adresu procedury do wektora nr 8
 mov ds:[36], bx ; OFFSET
 mov ds:[38], ax ; cz. segmentowa
 sti ;odblokowanie przerwa�

; oczekiwanie na naci�ni�cie klawisza 'x'
aktywne_oczekiwanie:
 mov ah,1
 int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 je�li
; naci�ni�to jaki� klawisz
 jz aktywne_oczekiwanie
; odczytanie kodu ASCII naci�ni�tego klawisza (INT 16H, AH=0)
; do rejestru AL
 mov ah, 0
 int 16H
 cmp ah, 1 ; por�wnanie z scan codem escapea
 jne aktywne_oczekiwanie ; skok, gdy inny znak 
; deinstalacja procedury obs�ugi przerwania zegarowego
; odtworzenie oryginalnej zawarto�ci wektora nr 8
 mov eax, cs:wektor9
 cli
 mov ds:[36], eax ; przes�anie warto�ci oryginalnej
 ; do wektora 8 w tablicy wektor�w
 ; przerwa�
 sti
; zako�czenie programu
 mov al, 0
 mov ah, 4CH
 int 21H
rozkazy ENDS
;==========================================================================

nasz_stos SEGMENT stack
 db 128 dup (?)
nasz_stos ENDS
END zacznij