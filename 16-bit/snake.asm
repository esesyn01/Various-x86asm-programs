.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
; przechowanie rejestr�w
push ax
push bx
push es
push cx
mov ax, 0A000H ; adres pami�ci ekranu dla trybu 13H
mov es, ax
mov bx, cs:adres_piksela ; adres bie��cy piksela
mov al, cs:kolor
mov cx, cs:kod
mov es:[bx], al ; wpisanie kodu koloru do pami�ci ekranu
; przej�cie do nast�pnego wiersza na ekranie
add bx, cx
; sprawdzenie czy ca�a linia wykre�lona
cmp bx, 320*200
jb dalej ; skok, gdy linia jeszcze nie wykre�lona
; kre�lenie linii zosta�o zako�czone - nast�pna linia b�dzie
; kre�lona w innym kolorze o 10 pikseli dalej
add word PTR cs:przyrost, 10
mov bx, 10
add bx, cs:przyrost
inc cs:kolor ; kolejny kod koloru
; zapisanie adresu bie��cego piksela
dalej:
mov cs:adres_piksela, bx
; odtworzenie rejestr�w
pop cx
 pop es
 pop bx
 pop ax
; skok do oryginalnego podprogramu obs�ugi przerwania
; zegarowego
 jmp dword PTR cs:wektor8
; zmienne procedury
kolor db 1 ; bie��cy numer koloru
adres_piksela dw 10 ; bie��cy adres piksela
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
mov cs:wektor8, eax; zapami�tanie wektora nr 8
mov ecx,es:[36] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor9, ecx
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia
cli ; zablokowanie przerwa�
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax
sti ; odblokowanie przerwa�
mov ax, SEG obslugaklaw
mov bx, OFFSET obslugaklaw
cli ; zablokowanie przerwa�
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[36], bx
mov es:[36+2], ax
sti ; odblokowanie przerwa�
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
mov eax, cs:wektor8
mov es:[32], eax
mov ecx, cs:wektor9
mov es:[36], ecx
; zako�czenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij
