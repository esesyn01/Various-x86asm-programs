.686
.XMM
.model flat
public _pm_jeden
.data
jedynki dd 1.0,1.0,1.0,1.0
.code
_pm_jeden PROC
push ebp
mov ebp,esp
mov eax,[ebp+8]
mov edx, OFFSET jedynki
movups xmm5,[eax]
movups xmm6,[edx]
addsubps xmm5,xmm6
movups [eax],xmm5
pop ebp
ret
_pm_jeden ENDP
END