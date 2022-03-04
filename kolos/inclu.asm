.686
.model flat
extern _malloc : proc
public _nwd 
public _fth
public _spacje
public _rozklad
.data
dekoder db 30h,0,31h,0,32h,0,33h,0,34h,0,35h,0,36h,0,37h,0,38h,0,39h,0,8ah,21h,8bh,21h
.code
_zamm proc
push ebp
mov ebp,esp
push esi
push ebx
mov eax,0
mov esi,[ebp+8]
mov ebx,12
mov ecx,0
ptl:
mov cx,[esi]
cmp cx,0
je koniec
cmp cx,40h
ja powalone
sub cx,30h
mov edx,0
mul ebx
add eax,ecx
dalej:
add esi,2
jmp ptl
koniec:
pop ebx
pop esi
pop ebp
ret
powalone:
mov edx,0
cmp cx,218ah
jne drugi
mov edx,0
mul ebx
add eax,10
jmp dalej
drugi:
mov edx,0
mul ebx
add eax,11
jmp dalej
_zamm endp
_rozklad proc
push ebp
mov ebp,esp
push ebx
push edi
push esi
mov eax,64
push eax
call _malloc
mov edi,eax
add esp,4
mov ecx,16
push edi
ptl2:
mov [edi],dword ptr 0
add edi,4
dec ecx
jnz ptl2
pop edi
mov ebx,[ebp+8]
mov ecx,[ebp+12]
mov esi,16
ptl:
mov edx,0
mov eax,[ebx]
div esi
mov eax,[edi][4*edx]
inc eax
mov [edi][4*edx],eax
add ebx,8
dec ecx
jnz ptl
mov eax,edi
pop esi
pop edi
pop ebx
pop ebp
ret
_rozklad endp
_spacje proc
push ebp
mov ebp,esp
push ebx
push edi
mov eax,129
push eax
call _malloc
mov edi,eax
add esp,4
mov ebx,edi
mov eax,0
mov al,[ebp+8]
mov ecx,128
ptl:
mov byte ptr [ebx],al
inc ebx
dec ecx
jnz ptl
mov al,0
mov byte ptr[ebx],al
mov eax,edi
pop edi
pop ebx
pop ebp
ret
_spacje endp
_zami proc
push ebp
mov ebp,esp
push edi
push esi
push ebx
mov eax,[ebp+8]
mov esi,offset dekoder
mov ecx,0
mov ebx,12
ptl:
mov edx,0
div ebx
inc ecx
cmp eax,0
jne ptl
push ecx
add ecx,ecx
add ecx,2
push ecx
call _malloc
add esp,4
mov edi,eax
mov eax,[ebp+8]
pop ecx
push edi
add edi,ecx
add edi,ecx
mov word ptr [edi],0
sub edi,2
ptl2:
mov edx,0
mov ebx,12
div ebx
push eax
mov eax,edx
mov ebx,2
mov edx,0
mul ebx
mov dx,[esi][eax]
mov word ptr [edi],dx
sub edi,2
pop eax
dec ecx
jnz ptl2
pop edi
mov eax,edi
pop ebx
pop esi
pop edi
pop ebp
ret
_zami endp
_fth proc
push ebp
mov ebp,esp
mov edx,[ebp+8]
mov ecx,edx
mov eax,0
bt edx,31
jc ujemna
konw:
and edx,7f800000h
and ecx,007fffffh
shr edx,23
sub edx,112
shl edx,10
shr ecx,13
or edx,ecx
or eax,edx
pop ebp
ret
ujemna:
bts ax,15
jmp konw
_fth endp
_nwd proc
push ebp
mov ebp,esp
mov eax,[ebp+8]
mov edx,[ebp+12]
cmp eax,edx
je koniec
ja wieksze
sub edx,eax
push edx
push eax
call _nwd
add esp,8
koniec:
pop ebp
ret
wieksze:
sub eax,edx
push edx
push eax
call _nwd
add esp,8
jmp koniec
_nwd endp
end