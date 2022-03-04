.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxA@16 : PROC
public _main
.data
tekst_pocz db 10, 'Prosz',0a9h, ' napisa',86h, ' jaki',98h,' tekst '
db 'i nacisn',0a5h,86h,' Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
tytul db 'title',0
.code
_main PROC
; wy�wietlenie tekstu informacyjnego
; liczba znak�w tekstu
 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz ; adres tekstu
 push 1 ; nr urz�dzenia (tu: ekran - nr 1)
 call __write ; wy�wietlenie tekstu pocz�tkowego
 add esp, 12 ; usuniecie parametr�w ze stosu
; czytanie wiersza z klawiatury
 push 80 ; maksymalna liczba znak�w
 push OFFSET magazyn
 push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
 call __read ; czytanie znak�w z klawiatury
 add esp, 12 ; usuniecie parametr�w ze stosu
; kody ASCII napisanego tekstu zosta�y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczb�
; wprowadzonych znak�w
 mov liczba_znakow, eax
; rejestr ECX pe�ni rol� licznika obieg�w p�tli
 mov ecx, eax
 mov ebx, 0 ; indeks pocz�tkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
 cmp dl ,0a5h ; �
 je dalej
 cmp dl, 0a9h ; �
 je casee
 cmp dl, 0e4h ; �
 je casen
 cmp dl, 98h ; �
 je cases
 cmp dl, 0beh ; �
 je casez
 cmp dl, 86h ; �
 je casec
 cmp dl, 88h ; �
 je casel
 cmp dl, 0a2h ; �
 je caseo
 cmp dl, 0abh ; �
 je casezz
 cmp dl, 'a'
 jb dalej ; skok, gdy znak nie wymaga zamiany
 cmp dl, 'z'
 ja dalej ; skok, gdy znak nie wymaga zamiany
 sub dl, 20H ; zamiana na wielkie litery
 jmp dalej
; odes�anie znaku do pami�ci
casec:
 add dl, 64
 jmp dalej
casee:
 add dl, 33
 jmp dalej
casel:
 add dl, 27
 jmp dalej
casen:
 sub dl, 19
 jmp dalej
caseo:
 add dl, 49
 jmp dalej
cases:
 sub dl,12
 jmp dalej
casezz:
 sub dl, 28
 jmp dalej
casez:
 sub dl,15
 jmp dalej
dalej:
 mov magazyn[ebx], dl
 inc ebx ; inkrementacja indeksu
 dec ecx ; sterowanie p�tl�
 jnz ptl
; wy�wietlenie przekszta�conego tekstu
 push 0
 push OFFSET tytul
 push OFFSET magazyn
 push 0
 call _MessageBoxA@16 ; wy�wietlenie przekszta�conego ale na latin nie windows 1250 jaki byc powinien
 add esp, 12 ; usuniecie parametr�w ze stosu
 push 0
 call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END