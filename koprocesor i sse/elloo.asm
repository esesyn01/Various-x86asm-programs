.686
.XMM
.model flat
public _maxy,_vmax,_mull,_dziel
.data
obszar dd 4 dup(?)
.code
_dziel PROC
push ebp
mov ebp,esp
push ebx
mov ebx,offset obszar
mov eax,[ebp+8]
mov edx,[ebp+16]
mov ecx,[ebp+12]
mov [ebx],edx
mov [ebx+4],edx
mov [ebx+8],edx
mov [ebx+12],edx
ptl:
movups xmm0,[eax]
movups xmm1,[ebx]
divps xmm0,xmm1
movups [eax],xmm0
add eax,16
loop ptl
pop ebx
pop ebp
ret
_dziel ENDP
_maxy PROC
push ebp
mov ebp,esp
push ebx
mov eax,[ebp+8]
mov edx,[ebp+12]
mov ebx,[ebp+16]
mov ecx,[ebp+20]
ptl:
movdqu xmm5,[eax]
movdqu xmm6,[edx]
pmaxsd xmm5,xmm6
movdqu [ebx],xmm5
add eax,16
add ebx,16
add edx,16
sub ecx,4
jnz ptl
pop ebx
pop ebp
ret
_maxy ENDP
_vmax PROC
push ebp
mov ebp,esp
push ebx
mov eax,[ebp+12]
mov edx,[ebp+8]
mov ebx,offset obszar
mov [ebx],eax
mov [ebx+4],eax
mov [ebx+8],eax
mov [ebx+12],eax
movups xmm5,[edx]
cvtdq2ps xmm6,[ebx]
maxps xmm5,xmm6
movups [edx],xmm5
pop ebx
pop ebp
ret
_vmax ENDP
_mull PROC
push ebp
mov ebp,esp
movdqu xmm0,[ebp+8]
movdqu xmm1,[ebp+24]
pmulld xmm0,xmm1
pop ebp
ret
_mull ENDP
END
