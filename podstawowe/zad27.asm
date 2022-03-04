.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxW@16 : PROC
public _main
.data
tekst_pocz db 10, 'Prosz',0a9h, ' napisa',86h, ' jaki',98h,' tekst '
db 'i nacisn',0a5h,86h,' Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
magazyn2 db 160 dup(?)
magazynb dw 80 dup (?)
pom dw ?
nowa_linia db 10
liczba_znakow dd ?
tytul db 'title',0
tytul2 dw 't','i','t','l','e',0
.code
_main PROC
; wyœwietlenie tekstu informacyjnego
; liczba znaków tekstu
 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz ; adres tekstu
 push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
 call __write ; wyœwietlenie tekstu pocz¹tkowego
 add esp, 12 ; usuniecie parametrów ze stosu
; czytanie wiersza z klawiatury
 push 80 ; maksymalna liczba znaków
 push OFFSET magazyn
 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
 call __read ; czytanie znaków z klawiatury
 add esp, 12 ; usuniecie parametrów ze stosu
; kody ASCII napisanego tekstu zosta³y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbê
; wprowadzonych znaków
 mov liczba_znakow, eax
; rejestr ECX pe³ni rolê licznika obiegów pêtli
 mov ecx, eax
 mov ebx, 0 ; indeks pocz¹tkowy
ptl: mov dl, magazyn[ebx];pobranie kolejnego znaku
 cmp dl ,0a5h ; ¹
 je casea
 cmp dl, 0a9h ; ê
 je casee
 cmp dl, 0e4h ; ñ
 je casen
 cmp dl, 98h ; œ
 je cases
 cmp dl, 0beh ; ¿
 je casez
 cmp dl, 86h ; æ
 je casec
 cmp dl, 88h ; ³
 je casel
 cmp dl, 0a2h ; ó
 je caseo
 cmp dl, 0abh ; Ÿ
 je casezz
 cmp dl, 'a'
 jb dalej ; skok, gdy znak nie wymaga zamiany
 cmp dl, 'z'
 ja dalej ; skok, gdy znak nie wymaga zamiany
 sub dl, 20H ; zamiana na wielkie litery
 jmp dalej
; odes³anie znaku do pamiêci
casea:
 sub dl,1
 mov pom, 0104h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
casec:
 add dl, 9
 mov pom, 0106h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
casee:
 sub dl, 1
 mov pom, 0118h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
casel:
 add dl, 21
 mov pom, 0141h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
casen:
 sub dl, 1
 mov pom, 0143h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
caseo:
 add dl, 62
 mov pom, 00d3h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
cases:
 sub dl,1
 mov pom, 015ah 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
casezz:
 sub dl, 30
 mov pom, 0179h 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
casez:
 sub dl,1
 mov pom, 017bh 
 mov al, byte PTR pom
 mov magazyn2[2*ebx],al
 mov al, byte PTR pom+1
 mov magazyn2[2*ebx+1], al
 jmp dalej2
dalej:
 mov magazyn2[2*ebx],dl
 mov magazyn2[2*ebx+1], 0
 dalej2:
 mov magazyn[ebx], dl
 inc ebx ; inkrementacja indeksu
 dec ecx ; sterowanie pêtl¹
 jnz ptl
; wyœwietlenie przekszta³conego tekstu
 push liczba_znakow
 push OFFSET magazyn
 push 1
 call __write ; wyœwietlenie przekszta³conego ale na latin nie windows 1250 jaki byc powinien
 add esp, 12 ; usuniecie parametrów ze stosu
 mov eax,liczba_znakow
 mov ecx,eax
 mov ebx,0
 petla:
  mov dx,word ptr magazyn2[ebx]
  mov magazynb[ebx],dx
  inc ebx
  inc ebx
  dec ecx
  jnz petla
 push 0
 push OFFSET tytul2
 push OFFSET magazynb
 push 0 
 call _MessageBoxW@16
 push 0
 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END