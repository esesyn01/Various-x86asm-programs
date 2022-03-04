.686
.model flat
public _dzielenie
.code
_dzielenie PROC
push ebp
mov ebp,esp
push ebx
push ecx
mov ebx,[ebp+8]
mov ecx,[ebx]
mov eax,[ecx]
mov ebx,[ebp+12]
mov ecx,[ebx]
mov edx,0
idiv ecx
pop ecx
pop ebx
pop ebp
ret
_dzielenie ENDP
 END