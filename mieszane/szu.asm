.686
.model flat
public _szukaj
.code
_szukaj PROC
push ebp ; zapisanie zawarto�ci EBP na stosie
mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
push ebx ; przechowanie zawarto�ci rejestru EBX
mov ebx, [ebp+8] ; adres tablicy tabl
mov ecx, [ebp+12] ; liczba element�w tablicy
dec ecx
mov eax, [ebx]
mov edx,ebx
add ebx,4
ptl: 
cmp eax,[ebx]
jl pwiekszy
gotowe:
add ebx, 4 ; wyznaczenie adresu kolejnego elementu
loop ptl ; organizacja p�tli
mov eax,edx
pop ebx ; odtworzenie zawarto�ci rejestr�w
pop ebp
ret ; powr�t do programu g��wnego
pwiekszy:
mov eax,[ebx]
mov edx,ebx
jmp gotowe
_szukaj ENDP
 END