.686
.model flat
extern _GetSystemTime@4 : PROC
public _dataa
.code
_dataa PROC
push ebp
mov ebp,esp
push ebx
mov ebx,[ebp+8]
push ebx
call _GetSystemTime@4
mov ecx,[ebx+10]
mov eax,0
mov al, cl
pop ebx
pop ebp
ret
_dataa ENDP
END