.686
.model flat
public _szukaj4_max
.code
_szukaj4_max PROC
push ebp
mov ebp,esp
mov eax,[ebp+8]
cmp eax,[ebp+12]
jg abig1
mov eax,[ebp+12]
cmp eax,[ebp+16]
jg ostatni
cbig:
mov eax,[ebp+16]
ostatni:
cmp eax,[ebp+20]
jg koniec
mov eax,[ebp+20]
jmp koniec
koniec:
pop ebp
ret
abig1:
cmp eax,[ebp+16]
jg ostatni
jmp cbig
_szukaj4_max ENDP
END