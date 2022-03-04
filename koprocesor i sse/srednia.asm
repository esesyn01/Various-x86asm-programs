.686
.model flat
public _srednia
.code
_srednia PROC
push ebp
mov ebp,esp
push ebx
mov ecx,[ebp+12]
mov ebx,[ebp+8]
finit
fldz
ptl:

fld1
fld dword PTR [ebx]
fdivp
faddp
add ebx,4
loop ptl
fild dword PTR [ebp+12]
fdiv ST(0),ST(1)
pop ebx
pop ebp
ret
_srednia ENDP
END