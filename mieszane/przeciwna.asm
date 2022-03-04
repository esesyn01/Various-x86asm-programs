.686
.model flat
public _przeciwna
.code
_przeciwna PROC
push ebp
mov ebp,esp
push ebx
mov ebx,[ebp+8]
mov eax,[ebx]
neg eax
mov [ebx],eax
pop ebx
pop ebp
ret
_przeciwna ENDP
 END