.686
.model flat
public _merge
.data
adres dd 0
.code
_merge PROC
push ebp
mov ebp,esp
push ebx
mov ecx,[ebp+16]
mov ebx,[ebp+8]
cmp ecx,32
jg koniec
mov edx,OFFSET adres
ptl:
mov eax,[ebx]
mov [edx],eax
add ebx,4
add edx,4
loop ptl
mov ecx,[ebp+16]
mov ebx,[ebp+12]
ptl2:
mov eax,[ebx]
mov [edx],eax
add ebx,4
add edx,4
loop ptl2
mov eax,OFFSET adres
gotowe:
pop ebx
pop ebp
ret
koniec:
mov eax,0
jmp gotowe
_merge ENDP
END