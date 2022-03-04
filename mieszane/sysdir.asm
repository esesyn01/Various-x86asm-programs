.686
.model flat
extern _GetSystemDirectoryA@8 : PROC
public _getsys
.code
_getsys PROC
push ebp
mov ebp,esp
push ebx
sub esp,400
mov ebx,[ebp+8]
mov edx,esp
mov ecx,400
push ecx
push edx
call _GetSystemDirectoryA@8
mov ecx,eax
mov al,byte PTR [ebx]
ptl:
cmp al,byte PTR [edx]
jne nierowne
add ebx,1
add edx,1
mov al,byte PTR [ebx]
loop ptl
mov eax,1
jmp koniec
nierowne:
mov eax,0
koniec:
add esp,400
pop ebx
pop ebp
ret
_getsys ENDP
END