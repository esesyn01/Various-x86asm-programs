.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre?lenia)
extern __read : PROC ; (dwa znaki podkre?lenia)
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
; wy?wietlenie tekstu informacyjnego
; liczba znak?w tekstu
 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz ; adres tekstu
 push 1 ; nr urz?dzenia (tu: ekran - nr 1)
 call __write ; wy?wietlenie tekstu pocz?tkowego
 add esp, 12 ; usuniecie parametr?w ze stosu
; czytanie wiersza z klawiatury
 push 80 ; maksymalna liczba znak?w
 push OFFSET magazyn
 push 0 ; nr urz?dzenia (tu: klawiatura - nr 0)
 call __read ; czytanie znak?w z klawiatury
 add esp, 12 ; usuniecie parametr?w ze stosu
; kody ASCII napisanego tekstu zosta?y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczb?
; wprowadzonych znak?w
 mov liczba_znakow, eax
; rejestr ECX pe?ni rol? licznika obieg?w p?tli
 mov ecx, eax
 mov ebx, 0 ; indeks pocz?tkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
 cmp dl ,0a5h ; ?
 je minus1
 cmp dl, 0a9h ; ?
 je minus1
 cmp dl, 0e4h ; ?
 je minus1
 cmp dl, 98h ; ?
 je minus1
 cmp dl, 0beh ; ?
 je minus1
 cmp dl, 86h ; ?
 je plus9
 cmp dl, 88h ; ?
 je plus21
 cmp dl, 0a2h ; ?
 je plusd
 cmp dl, 0abh ; ?
 je minusd
 cmp dl, 'a'
 jb dalej ; skok, gdy znak nie wymaga zamiany
 cmp dl, 'z'
 ja dalej ; skok, gdy znak nie wymaga zamiany
 sub dl, 20H ; zamiana na wielkie litery
 jmp dalej
; odes?anie znaku do pami?ci
minusd:
 sub dl,30
 jmp dalej
plusd:
 add dl, 62
 jmp dalej
plus21:
 add dl, 21
 jmp dalej
plus9:
 add dl,9
 jmp dalej
minus1: 
 sub dl,1
 jmp dalej
dalej:
 mov magazyn[ebx], dl
 inc ebx ; inkrementacja indeksu
 dec ecx ; sterowanie p?tl?
 jnz ptl
; wy?wietlenie przekszta?conego tekstu
 push liczba_znakow
 push OFFSET magazyn
 push 1
 call __write ; wy?wietlenie przekszta?conego
 add esp, 12 ; usuniecie parametr?w ze stosu
 push 0
 call _ExitProcess@4 ; zako?czenie programu
_main ENDP
END