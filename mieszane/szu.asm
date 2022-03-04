.686
.model flat
public _szukaj
.code
_szukaj PROC
push ebp ; zapisanie zawartoœci EBP na stosie
mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
push ebx ; przechowanie zawartoœci rejestru EBX
mov ebx, [ebp+8] ; adres tablicy tabl
mov ecx, [ebp+12] ; liczba elementów tablicy
dec ecx
mov eax, [ebx]
mov edx,ebx
add ebx,4
ptl: 
cmp eax,[ebx]
jl pwiekszy
gotowe:
add ebx, 4 ; wyznaczenie adresu kolejnego elementu
loop ptl ; organizacja pêtli
mov eax,edx
pop ebx ; odtworzenie zawartoœci rejestrów
pop ebp
ret ; powrót do programu g³ównego
pwiekszy:
mov eax,[ebx]
mov edx,ebx
jmp gotowe
_szukaj ENDP
 END