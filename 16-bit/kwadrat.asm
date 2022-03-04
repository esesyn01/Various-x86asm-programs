.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
; przechowanie rejestr�w
push ax
push bx
push es
push cx
push di
push si
mov ax, 0A000H ; adres pami�ci ekranu dla trybu 13H
mov es, ax
mov bx, cs:adres_piksela ; adres bie��cy piksela
mov al, cs:kolor
mov es:[bx], al ; wpisanie kodu koloru do pami�ci ekranu
mov ah,cs:sciana
mov al,cs:in_kol
dec dx
cmp dx,16
jb ffb
pierwszy:
mov al, cs:inny_kolor
ffb:
mov di,cs:zero
add di,641
cmp dx,0
jne ffa
; przej�cie do nast�pnego wiersza na ekranie
mov dx,30
ffa:
push bx
mov bl,cs:kod
cmp bl,1
jne fgg
mov al,20
fgg:
pop bx
mov cx,38
ptl1:
mov si,39
ptl2:
mov es:[di],al
inc di
dec si
jnz ptl2
sub di,39
add di,320
dec cx
jnz ptl1
mov al,cs:kolor
s0:
cmp ah,0
jne s1
add bx, 320
; sprawdzenie czy ca�a linia wykre�lona
cmp bx, 320*40
jb dalej 
jmp zmiana; skok, gdy linia jeszcze nie wykre�lona
s1:
cmp ah,1
jne s2
add bx,1
cmp bx,12840
jb dalej
jmp zmiana
s2:
cmp ah,2
jne s3
sub bx,320
cmp bx,360
jg dalej
jmp zmiana
s3:
sub bx,1
cmp bx,320
jg dalej
jmp zmiana
; kre�lenie linii zosta�o zako�czone - nast�pna linia b�dzie
; kre�lona w innym kolorze o 10 pikseli dalej
add word PTR cs:przyrost, 10
mov bx, 10
add bx, cs:przyrost
inc cs:kolor ; kolejny kod koloru
; zapisanie adresu bie��cego piksela
zmiana:
inc ah
cmp ah,4
je minuss
jmp dalej
minuss:
sub ah,4
dalej:
mov cs:adres_piksela, bx
mov cs:sciana,ah
; odtworzenie rejestr�w
 pop si
 pop di
 pop cx
 pop es
 pop bx
 pop ax
; skok do oryginalnego podprogramu obs�ugi przerwania
; zegarowego
 jmp dword PTR cs:wektor8
; zmienne procedury
inny_kolor db 6
in_kol db 50
zero dw 0
sciana db 0
kolor db 3 ; bie��cy numer koloru
adres_piksela dw 320 ; bie��cy adres piksela
przyrost dw 0
wektor8 dd ?
licznik db 0
linia ENDP
obslugaklaw proc
 push ax
 in al,60h
 cmp al,30
 je ddas
 cmp al, 158
 je ddas2
 jmp kon
 ddas:
 mov cs:kod,byte ptr 1
 jmp kon
 ddas2:
 mov cs:kod,byte ptr 0
 kon:
 pop ax
jmp dword ptr cs:wektor9
wektor9 dd ?
obslugaklaw endp

kod db 0
kol db 20
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
