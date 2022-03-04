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
;============================================================
; procedura obs�ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u�ywanych rejestr�w
push ax
push bx
push es
push dx
mov dx,cs:ilosc
dec dx
cmp dx,0
jne niekoncz
mov cs:tryb,1
niekoncz:
mov ax, 0B800h ;adres pami�ci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
mov bx, cs:licznik
; przes�anie do pami�ci ekranu kodu ASCII wy�wietlanego znaku
; i kodu koloru: bia�y na czarnym tle (do nast�pnego bajtu)
mov byte PTR es:[bx], '*' ; kod ASCII
mov byte PTR es:[bx+1], 00000111B ; kolor
; zwi�kszenie o 2 adresu bie��cego w pami�ci ekranu
add bx,2
; sprawdzenie czy adres bie��cy osi�gn�� koniec pami�ci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie��cego, gdy ca�y ekran zapisany
mov bx, 0
;zapisanie adresu bie��cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
mov cs:ilosc,dx
; odtworzenie rejestr�w
pop dx
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze wzgl�du na specyfik� obs�ugi przerwa�
; umieszczone s� w segmencie kodu
licznik dw 320 ; wy�wietlanie pocz�wszy od 2. wiersza
ilosc dw 120
wektor8 dd ?
obsluga_zegara ENDP
klawa PROC
 push ax
 in al,60h
 cmp al,45
 jne dakk
 mov cs:tryb,1
 dakk:
 pop ax
jmp dword ptr cs:wektor9
wektor9 dd ?
tryb db 0
klawa endp
;============================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawarto�ci wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pami�ci 4 bajty
; pocz�wszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax
mov ecx,ds:[36] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor9, ecx
; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; cz�� segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwa�
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwa�
mov ax, SEG klawa
mov bx, OFFSET klawa
cli ; zablokowanie przerwa�
; zapisanie adresu procedury 'linia' do wektora nr 8
mov ds:[36], bx
mov ds:[36+2], ax
sti ; odblokowanie przerwa�
; oczekiwanie na naci�ni�cie klawisza 'x'
aktywne_oczekiwanie:
 mov ah,cs:tryb
 cmp ah,1
 jne aktywne_oczekiwanie
; deinstalacja procedury obs�ugi przerwania zegarowego
; odtworzenie oryginalnej zawarto�ci wektora nr 8
koniec:
mov eax, cs:wektor8
mov ecx, cs:wektor9
cli
mov ds:[32], eax ; przes�anie warto�ci oryginalnej
mov ds:[36], ecx
; do wektora 8 w tablicy wektor�w
; przerwa�
sti
; zako�czenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij