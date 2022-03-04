.686
.model flat
public _odejmij_jeden
.code
_odejmij_jeden PROC
push ebp
mov ebp,esp
push ebx
push ecx
mov ebx,[ebp+8]
mov ecx,[ebx]
mov eax,[ecx]
dec eax
mov [ecx],eax
mov [ebx],ecx
pop ecx
pop ebx
pop ebp
ret
_odejmij_jeden ENDP
 END