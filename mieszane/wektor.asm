.686
.model flat
public _weektor
.data
magazyn dd 0
mnoznik dd 0
temp dd 0
.code
_weektor PROC
push ebp ; zapisanie zawarto�ci EBP na stosie
mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
push ebx ; przechowanie zawarto�ci rejestru EBX
mov ebx, [ebp+8] ; adres tablicy tab1
mov edx, [ebp+12] ; adres tab2
mov ecx,[ebp+16] ; liczba elementow
ptl: 
mov eax,[edx]
mov mnoznik,eax
mov eax,[ebx]
mov temp,edx
imul mnoznik
mov edx,temp
add magazyn,eax
gotowe:
add ebx, 4 ; wyznaczenie adresu kolejnego elementu
add edx, 4
loop ptl ; organizacja p�tli
mov eax,magazyn
pop ebx ; odtworzenie zawarto�ci rejestr�w
pop ebp
ret ; powr�t do programu g��wnego
_weektor ENDP
 END