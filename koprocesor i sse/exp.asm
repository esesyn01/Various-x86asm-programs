.686
.model flat
public _nowy
.code
_nowy PROC
push ebp
mov ebp,esp
finit
mov ecx,19
fldz
ptl:

mov esi,ecx
fld dword PTR [ebp+8]
ptl2:
fmul dword PTR[ebp+8]
push esi
fild dword PTR [esp]
add esp,4
fdivp
dec esi
jnz ptl2
fdiv dword PTR[ebp+8]
faddp
loop ptl
fld1
faddp
pop ebp
ret
_nowy ENDP
END