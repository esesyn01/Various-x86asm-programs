 .686
.model flat
extern _malloc : proc
extern _GetSystemInfo@4 : proc
public _roznica
public _kopia
public _komunikat
public _szukaj
public _szyfruj
public _kwadrat
public _iteracja
public _pole_kola
public _avg_wd
public _liczba_procesorow
public _sortowanie
public _asc
.code
_asc proc
push ebp
mov ebp,esp
push ebx
mov ecx,[ebp+12]
mov eax,ecx
add eax,ecx
add eax,2
push eax
call _malloc
mov edx,[ebp+8]
mov ecx,[ebp+12]
add esp,4
mov edi,eax
ptl:
mov bl,[edx]
mov [eax],bl
mov bl,0
mov [eax+1],bl
inc edx
add eax,2
dec ecx
jnz ptl
mov [eax],word ptr 0
mov eax,edi
pop ebx
pop ebp
ret
_asc endp
_sortowanie proc
push ebp
mov ebp,esp
push ebx
push esi
push edi
mov ebx,[ebp+8]
mov edi,ebx
mov ecx,[ebp+16]
dec ecx
ptl:
mov ebx,edi
mov esi,ecx
ptl2:
mov eax,[ebx]
mov edx,[ebx+4]
add ebx,8
cmp edx,[ebx+4]
ja wieksza
je rowne
dalej:
dec esi
jnz ptl2
dec ecx
jnz ptl
mov ecx,[ebp+16]
mov ebx,edi
dec ecx
ptl3:
add ebx,8
dec ecx
jnz ptl3
mov edx,[ebx+4]
mov eax,[ebx]
pop edi
pop esi
pop ebx
pop ebp
ret
wieksza:
xchg eax,dword ptr [ebx]
xchg edx,dword ptr [ebx+4]
xchg eax,dword ptr [ebx-8]
xchg edx,dword ptr [ebx-4]
jmp dalej
rowne:
cmp eax,[ebx]
ja wieksza
jmp dalej
_sortowanie endp
_liczba_procesorow proc
push ebp
mov ebp,esp
push edx
call _GetSystemInfo@4
pop ebp
ret
_liczba_procesorow endp
_avg_wd proc
push ebp
mov ebp,esp
push ebx
mov ecx,[ebp+8]
mov ebx,[ebp+12]
mov edx,[ebp+16]
finit
fldz
fldz
fldz
ptl:
fld dword ptr[ebx]
fld dword ptr[edx]
fmulp
faddp
fld dword ptr [edx]
faddp ST(2),ST(0)
add ebx,4
add edx,4
loop ptl
fxch
fdivp 
pop ebx
pop ebp
ret
_avg_wd endp
_pole_kola proc
push ebp
mov ebp,esp
finit
mov edx,[ebp+8]
mov ecx,[edx]
sub esp,4
mov [esp],ecx
fld dword ptr[esp]
fld dword ptr[esp]
fldpi
fmulp
fmulp
fstp dword ptr [esp]
mov ecx,[esp]
add esp,4
mov [edx],ecx
mov [ebp+8],edx
pop ebp
ret
_pole_kola endp
_iteracja proc
push ebp
mov ebp,esp
mov al,[ebp+8]
sal al,1
jc zakoncz
inc al
push eax
call _iteracja
add esp, 4
pop ebp
ret
zakoncz: rcr al, 1
; rozkaz RCR wykonuje przesuniêcie
; cykliczne w prawo przez CF
pop ebp
ret
_iteracja endp
_kwadrat proc
push ebp
mov ebp,esp
mov ecx,[ebp+8]
cmp ecx,0
je zero
cmp ecx,1
je jeden
sub ecx,2
sub esp,4
mov [esp],ecx
call _kwadrat
add esp,4
add ecx,2
add eax,ecx
add eax,ecx
add eax,ecx
add eax,ecx
sub eax,4
jmp koniec
zero:
mov eax,0
jmp koniec
jeden:
mov eax,1
jmp koniec
koniec:
pop ebp
ret
_kwadrat endp
_szyfruj proc
push ebp
mov ebp,esp
mov eax,52525252h
mov edx,[ebp+8]
ptl:
mov cl,byte ptr [edx]
cmp cl,0
je koniec
xor cl,al
mov byte ptr [edx],cl
inc edx
mov ecx,eax
and ecx,00000003h
shl eax,1
cmp ecx,1
jb xor0
cmp ecx,2
ja xor0
jmp xor1
xor0:
btr eax,0
jmp dalej
xor1:
bts eax,0
dalej:
jmp ptl
koniec:
pop ebp
ret
_szyfruj endp
_szukaj proc
push ebp
mov ebp,esp
push ebx
mov edx,[ebp+8]
mov ecx,[ebp+12]
mov ebx,[edx]
mov eax,edx
ptl:
cmp ebx,dword ptr [edx]
jg dalej
mov ebx,dword ptr [edx]
mov eax,edx
dalej:
add edx,4
dec ecx
jnz ptl
pop ebx
pop ebp
ret
_szukaj endp
_komunikat proc
push ebp
mov ebp,esp
push ebx
push esi
push edi
mov edx,[ebp+8]
mov ecx,0
ptl:
mov bl,byte ptr [edx]
inc edx
inc ecx
cmp bl,0
jne ptl
add ecx,5
mov eax,ecx
push ecx
call _malloc
mov edi,eax
mov edx,[ebp+8]
pop ecx
dec ecx
ptl2:
cmp ecx,5
jg normal
mov byte ptr [eax],'B'
mov byte ptr [eax+1],'l'
mov byte ptr [eax+2],'a'
mov byte ptr [eax+3],'d'
mov byte ptr [eax+4],'.'
mov byte ptr [eax+5],0
jmp koniec
normal:
mov bl,byte ptr [edx]
mov byte ptr [eax],bl
inc edx
inc eax
dec ecx
jnz ptl2
koniec:
mov eax,edi
pop edi
pop esi
pop ebx
pop ebp
ret
_komunikat endp
_kopia proc
push ebp
mov ebp,esp
push ebx
push edi
push esi
mov ebx,[ebp+8]
mov esi,ebx
mov ecx,[ebp+12]
mov eax,ecx
add eax,ecx
add eax,ecx
add eax,ecx
add esp,400
sub esp,eax
mov edi,esp
mov edx,edi
ptl:
mov eax,[ebx]
bt eax,0
jc zero
mov [edx],eax
jmp dalej
zero:
mov [edx],dword ptr 0
dalej:
add ebx,4
add edx,4
add esp,4
dec ecx
jnz ptl
mov eax,edi
sub esp,400
pop esi
pop edi
pop ebx
pop ebp
ret
_kopia endp
_roznica proc
push ebp
mov ebp,esp
push ebx
push esi
mov ebx,[ebp+8]
mov eax,[ebx]
mov edx,[ebp+12]
mov esi,[edx]
mov ecx,[esi]
sub eax,ecx
pop esi
pop ebx
pop ebp
ret
_roznica endp
end