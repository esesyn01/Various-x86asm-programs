.686
.model flat
extern _malloc : PROC
public _func
.data
adres dd 0
mno dd 4
elem dd 0
.code
_func PROC
push ebp
mov ebp,esp
push ebx
mov eax,[ebp+8]
mov elem,eax
mul mno
mov edi,eax
call _malloc
mov adres,eax
mov ecx,elem
mov ebx,0
ptl:
mov edx,ebx
add edx,ebx
add edx,ebx
dec edx
mov [eax],edx
inc ebx
add eax,4
loop ptl
koniec:
mov eax,adres
pop ebx
pop ebp
ret
_func ENDP
 END