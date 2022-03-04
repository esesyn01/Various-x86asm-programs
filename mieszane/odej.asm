.686
.model flat
public _odejmowaniee
.code
_odejmowaniee PROC
push ebp
mov ebp,esp
push ebx
push ecx
mov ebx,[ebp+8]
mov ecx,[ebx]
mov eax,[ecx]
mov ebx,[ebp+12]
mov ecx,[ebx]
sub eax,ecx
pop ecx
pop ebx
pop ebp
ret
_odejmowaniee ENDP
 END