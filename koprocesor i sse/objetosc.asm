.686
.model flat
public _obje,_rzut,_tangi,_potega
.data
konw dd 180
g dd 9.81
.code
_obje PROC
push ebp
mov ebp,esp
finit
fild dword PTR[ebp+8]
fild dword PTR[ebp+8]
fmulp
fild dword PTR[ebp+8]
fild dword PTR[ebp+12]
fmulp
faddp
fild dword PTR[ebp+12]
fild dword PTR[ebp+12]
fmulp
faddp
fld dword PTR[ebp+16]
fmulp
fldpi
fmulp
fld1
fld1
fld1
faddp
faddp
fdivp
pop ebp
ret
_obje ENDP
_rzut PROC
push ebp
mov ebp,esp
finit
fld dword PTR [ebp+12]
fldpi
fmulp
mov eax,OFFSET konw
fild dword PTR [eax]
fdivp
fsincos
fmulp
fld dword PTR [ebp+8]
fld dword PTR [ebp+8]
fmulp
fmulp
fld1
fld1
faddp
fmulp
mov eax,Offset g
fld dword PTR [eax]
fdivp
pop ebp
ret
_rzut ENDP
_tangi PROC
finit
mov ecx,5
mov eax,0
ptl:
push eax
fild dword PTR[esp]
add esp,4
mov ebx,OFFSET konw
fild dword PTR[ebx]
fdivp
fldpi
fmulp
fptan
fmulp
add eax,15
loop ptl
ret
_tangi ENDP
_potega PROC
push ebp
mov ebp,esp
mov eax,0
finit
fild dword PTR [ebp+12]
mov al,byte PTR[ebp+8]
push eax
fild dword PTR[esp]
add esp,4
fyl2x
fst st(1)
frndint
fsub st(1),st(0)
fxch
f2xm1
fld1 ; liczba 1
faddp st(1), st(0) ; dodanie 1 do wyniku
fscale
fstp st(1)
pop ebp
ret
_potega ENDP
END