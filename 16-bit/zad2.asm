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
;============================================================
; procedura obs³ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u¿ywanych rejestrów
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
mov ax, 0B800h ;adres pamiêci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie¿¹cy w pamiêci ekranu
mov bx, cs:licznik
; przes³anie do pamiêci ekranu kodu ASCII wyœwietlanego znaku
; i kodu koloru: bia³y na czarnym tle (do nastêpnego bajtu)
mov byte PTR es:[bx], '*' ; kod ASCII
mov byte PTR es:[bx+1], 00000111B ; kolor
; zwiêkszenie o 2 adresu bie¿¹cego w pamiêci ekranu
add bx,2
; sprawdzenie czy adres bie¿¹cy osi¹gn¹³ koniec pamiêci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie¿¹cego, gdy ca³y ekran zapisany
mov bx, 0
;zapisanie adresu bie¿¹cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
mov cs:ilosc,dx
; odtworzenie rejestrów
pop dx
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
; umieszczone s¹ w segmencie kodu
licznik dw 320 ; wyœwietlanie pocz¹wszy od 2. wiersza
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
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartoœci wektora nr 8 i zapisanie go
; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamiêci 4 bajty
; pocz¹wszy od adresu fizycznego 8 * 4 = 32)
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax
mov ecx,ds:[36] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor9, ecx
; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwañ
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwañ
mov ax, SEG klawa
mov bx, OFFSET klawa
cli ; zablokowanie przerwañ
; zapisanie adresu procedury 'linia' do wektora nr 8
mov ds:[36], bx
mov ds:[36+2], ax
sti ; odblokowanie przerwañ
; oczekiwanie na naciœniêcie klawisza 'x'
aktywne_oczekiwanie:
 mov ah,cs:tryb
 cmp ah,1
 jne aktywne_oczekiwanie
; deinstalacja procedury obs³ugi przerwania zegarowego
; odtworzenie oryginalnej zawartoœci wektora nr 8
koniec:
mov eax, cs:wektor8
mov ecx, cs:wektor9
cli
mov ds:[32], eax ; przes³anie wartoœci oryginalnej
mov ds:[36], ecx
; do wektora 8 w tablicy wektorów
; przerwañ
sti
; zakoñczenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
db 128 dup (?)
nasz_stos ENDS
END zacznij