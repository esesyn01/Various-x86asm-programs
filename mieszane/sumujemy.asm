.686
.model flat
public _sumo
.data
adres dd 0
.code
_sumo PROC
push ebp
mov ebp,esp
push ebx
mov eax,0
mov ecx,[ebp+8]
mov ebx,3
ptl:
mov edx,[ebp][4*ebx]
add eax,edx
add edx,4
inc ebx
loop ptl
pop ebx
pop ebp
ret
_sumo ENDP
END