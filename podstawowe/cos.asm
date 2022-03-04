.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data
tytul dw 't','i','t','l','e',0
ciag dw 'e','l','a',' ','m','a',' ','k','o','t','a',0
magazyn dw 80 dup (?)
.code
_main PROC
 mov eax,6
 mov ecx,eax
ptl:
 mov dx,ciag[ecx-2]
 push dx
 dec ecx
 dec ecx
 jnz ptl
 mov dx,20h
 push dx
 mov eax,12
 mov ecx,eax
ptl2:
 mov dx,ciag[ecx-2]
 push dx
 dec ecx
 dec ecx
 cmp ecx,6
 jne ptl2
 mov eax,22
 mov ecx,eax
ptl3:
 mov dx,ciag[ecx-2]
 push dx
 dec ecx
 dec ecx
 cmp ecx,12
 jne ptl3
mov ecx,12
mov ebx,0
ptl4:
 pop dx
 mov magazyn[ebx],dx
 inc ebx
 inc ebx
 dec ecx
 jnz ptl4
 push 0
 push OFFSET tytul
 push OFFSET magazyn
 push 0
 call _MessageBoxW@16
 push 0
 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END