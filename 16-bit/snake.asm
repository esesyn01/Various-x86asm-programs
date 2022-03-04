.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
; przechowanie rejestrów
push ax
push bx
push es
push cx
mov ax, 0A000H ; adres pamiêci ekranu dla trybu 13H
mov es, ax
mov bx, cs:adres_piksela ; adres bie¿¹cy piksela
mov al, cs:kolor
mov cx, cs:kod
mov es:[bx], al ; wpisanie kodu koloru do pamiêci ekranu
; przejœcie do nastêpnego wiersza na ekranie
add bx, cx
; sprawdzenie czy ca³a linia wykreœlona
cmp bx, 320*200
jb dalej ; skok, gdy linia jeszcze nie wykreœlona
; kreœlenie linii zosta³o zakoñczone - nastêpna linia bêdzie
; kreœlona w innym kolorze o 10 pikseli dalej
add word PTR cs:przyrost, 10
mov bx, 10
add bx, cs:przyrost
inc cs:kolor ; kolejny kod koloru
; zapisanie adresu bie¿¹cego piksela
dalej:
mov cs:adres_piksela, bx
; odtworzenie rejestrów
pop cx
 pop es
 pop bx
 pop ax
; skok do oryginalnego podprogramu obs³ugi przerwania
; zegarowego
 jmp dword PTR cs:wektor8
; zmienne procedury
kolor db 1 ; bie¿¹cy numer koloru
adres_piksela dw 10 ; bie¿¹cy adres piksela
przyrost dw 0
wektor8 dd ?
linia ENDP

obslugaklaw proc
 push ax
 in al,60h
 cmp al, 72
 jne aa
 mov cs:kod,-320
 jmp kon
 aa:
 cmp al, 75
 jne cc
 mov cs:kod,-1
 jmp kon
 cc:
 cmp al,77
 jne ee
 mov cs:kod,1
 jmp kon
 ee:
 cmp al,80
 jne kon
 mov cs:kod,320
 kon:
 pop ax
jmp dword ptr cs:wektor9
wektor9 dd ?
obslugaklaw endp
kod dw 320
; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
mov dx,30
mov ah, 0
mov al, 13H ; nr trybu
int 10H
mov bx, 0
mov es, bx ; zerowanie rejestru ES
mov eax, es:[32] ; odczytanie wektora nr 8
mov cs:wektor8, eax; zapamiêtanie wektora nr 8
mov ecx,es:[36] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor9, ecx
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia
cli ; zablokowanie przerwañ
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax
sti ; odblokowanie przerwañ
mov ax, SEG obslugaklaw
mov bx, OFFSET obslugaklaw
cli ; zablokowanie przerwañ
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[36], bx
mov es:[36+2], ax
sti ; odblokowanie przerwañ
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
mov eax, cs:wektor8
mov es:[32], eax
mov ecx, cs:wektor9
mov es:[36], ecx
; zakoñczenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij
