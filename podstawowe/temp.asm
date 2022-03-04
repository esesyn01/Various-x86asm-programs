.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
public _main
.data
znaki db 12 dup (?)
cnt dd ?
obszar db 12 dup (?)
dziesiec dd 10 ; mno�nik
dwana dd 12
dekoder db '0123456789ABCDEF'
mnoz dd ?
przec db ','
minu db '-'
zmienna dd 45
.code
wyswietl_EAX PROC
pusha
mov esi, 10 ; indeks w tablicy 'znaki'
mov ebx, 10 ; dzielnik r�wny 10
konwersja:
mov edx, 0 ; zerowanie starszej cz�ci dzielnej
div ebx ; dzielenie przez 10, reszta w EDX,
; iloraz w EAX
add dl, 30H ; zamiana reszty z dzielenia na kod
; ASCII
mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
dec esi ; zmniejszenie indeksu
cmp eax, 0 ; sprawdzenie czy iloraz = 0
jne konwersja ; skok, gdy iloraz niezerowy
; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
; znak�w nowego wiersza
wypeln:
or esi, esi
jz wyswietl ; skok, gdy ESI = 0
mov byte PTR znaki [esi], 0 ; kod spacji
dec esi ; zmniejszenie indeksu
jmp wypeln
wyswietl:
; wy�wietlenie cyfr na ekranie
mov byte PTR znaki[11], 10
push dword PTR 12 ; liczba wy�wietlanych znak�w
push dword PTR OFFSET znaki ; adres wy�w. obszaru
push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
call __write ; wy�wietlenie liczby na ekranie
add esp, 12 ; usuni�cie parametr�w ze stosu
popa
ret
wyswietl_EAX ENDP
wyswietl_EAX2 PROC
pusha
mov esi, 10 ; indeks w tablicy 'znaki'
mov ebx, 10 ; dzielnik r�wny 10
konwersja:
mov edx, 0 ; zerowanie starszej cz�ci dzielnej
div ebx ; dzielenie przez 10, reszta w EDX,
; iloraz w EAX
add dl, 30H ; zamiana reszty z dzielenia na kod
; ASCII
mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
dec esi ; zmniejszenie indeksu
cmp eax, 0 ; sprawdzenie czy iloraz = 0
jne konwersja ; skok, gdy iloraz niezerowy
; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
; znak�w nowego wiersza
wypeln:
or esi, esi
jz wyswietl ; skok, gdy ESI = 0
cmp esi, 7
ja zeroo
mov byte PTR znaki [esi], 0 ; kod spacji
jmp lecymy
zeroo:
mov byte PTR znaki [esi],30h
lecymy:
dec esi ; zmniejszenie indeksu
jmp wypeln
wyswietl:
; wy�wietlenie cyfr na ekranie
push dword PTR 12 ; liczba wy�wietlanych znak�w
push dword PTR OFFSET znaki ; adres wy�w. obszaru
push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
call __write ; wy�wietlenie liczby na ekranie
add esp, 12 ; usuni�cie parametr�w ze stosu
popa
ret
wyswietl_EAX2 ENDP
wczytaj_EAX PROC
push ebx
push ecx
; max ilo�� znak�w wczytywanej liczby
push dword PTR 12
push dword PTR OFFSET obszar ; adres obszaru pami�ci
push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
call __read ; odczytywanie znak�w z klawiatury
; (dwa znaki podkre�lenia przed read)
add esp, 12 ; usuni�cie parametr�w ze stosu
; bie��ca warto�� przekszta�canej liczby przechowywana jest
; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
mov eax, 0
mov ebx, OFFSET obszar ; adres obszaru ze znakami
pobieraj_znaki:
mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
; ASCII
inc ebx ; zwi�kszenie indeksu
cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
je byl_enter ; skok, gdy naci�ni�to Enter
sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
movzx ecx, cl ; przechowanie warto�ci cyfry w
; rejestrze ECX
; mno�enie wcze�niej obliczonej warto�ci razy 10
mul dword PTR dziesiec
add eax, ecx ; dodanie ostatnio odczytanej cyfry
jmp pobieraj_znaki ; skok na pocz�tek p�tli
byl_enter:
; warto�� binarna wprowadzonej liczby znajduje si� teraz w
pop ecx
pop ebx
ret
wczytaj_EAX ENDP
wyswietl_EAX_hex PROC
pusha
sub esp, 12
mov edi, esp ; adres zarezerwowanego obszaru
mov ecx, 8 ; liczba obieg�w p�tli konwersji
mov esi, 1 ; indeks pocz�tkowy u�ywany przy
ptl3hex:
rol eax, 4
; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy
; 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym
mov ebx, eax ; kopiowanie EAX do EBX
and ebx, 0000000FH ; zerowanie bit�w 31 - 4 rej.EBX
mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
; przes�anie cyfry do obszaru roboczego
mov [edi][esi], dl
inc esi ;inkrementacja modyfikatora
loop ptl3hex ; sterowanie p�tl�

; wpisanie znaku nowego wiersza przed i po cyfrach
mov byte PTR [edi][0], 10
mov byte PTR [edi][9], 10
mov ecx,7
mov ebx,1
spacje:
mov dl,[edi][ebx]
cmp dl, 30h
je spacje1
mov ecx,1
jmp dalej
spacje1:
mov dl, 20h
mov [edi][ebx],dl
dalej:
inc ebx
dec ecx
jnz spacje
; wy�wietlenie przygotowanych cyfr
push 10 ; 8 cyfr + 2 znaki nowego wiersza
push edi ; adres obszaru roboczego
push 1 ; nr urz�dzenia (tu: ekran)
call __write ; wy�wietlenie
; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych
; przez 3 rozkazy push przed rozkazem call
; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu
add esp, 24
popa ; odtworzenie rejestr�w
ret ; powr�t z podprogramu
wyswietl_EAX_hex ENDP
wczytaj_do_EAX_hex PROC
; wczytywanie liczby szesnastkowej z klawiatury � liczba po
; konwersji na posta� binarn� zostaje wpisana do rejestru EAX
; po wprowadzeniu ostatniej cyfry nale�y nacisn�� klawisz
; Enter
push ebx
push ecx
push edx
push esi
push edi
push ebp
; rezerwacja 12 bajt�w na stosie przeznaczonych na tymczasowe
; przechowanie cyfr szesnastkowych wy�wietlanej liczby
sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
mov esi, esp ; adres zarezerwowanego obszaru pami�ci
push dword PTR 10 ; max ilo�� znak�w wczytyw. liczby
push esi ; adres obszaru pami�ci
push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
call __read ; odczytywanie znak�w z klawiatury
; (dwa znaki podkre�lenia przed read)
add esp, 12 ; usuni�cie parametr�w ze stosu
mov eax, 0 ; dotychczas uzyskany wynik
pocz_konw:
mov dl, [esi] ; pobranie kolejnego bajtu
inc esi ; inkrementacja indeksu
cmp dl, 10 ; sprawdzenie czy naci�ni�to Enter
je gotowe ; skok do ko�ca podprogramu
; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
cmp dl, '0'
jb pocz_konw ; inny znak jest ignorowany
cmp dl, '9'
ja sprawdzaj_dalej
sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry
dopisz:
shl eax, 4 ; przesuni�cie logiczne w lewo o 4 bity
or al, dl ; dopisanie utworzonego kodu 4-bitowego
 ; na 4 ostatnie bity rejestru EAX
jmp pocz_konw ; skok na pocz�tek p�tli konwersji
; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
sprawdzaj_dalej:
cmp dl, 'A'
jb pocz_konw ; inny znak jest ignorowany
cmp dl, 'F'
ja sprawdzaj_dalej2
sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
jmp dopisz
; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
sprawdzaj_dalej2:
cmp dl, 'a'
jb pocz_konw ; inny znak jest ignorowany
cmp dl, 'f'
ja pocz_konw ; inny znak jest ignorowany
sub dl, 'a' - 10
jmp dopisz
gotowe:
; zwolnienie zarezerwowanego obszaru pami�ci
add esp, 12
pop ebp
pop edi
pop esi
pop edx
pop ecx
pop ebx
ret
wczytaj_do_EAX_hex ENDP
wczytaj_dwu PROC
push ebx
push ecx
push edx
push esi
push edi
push ebp
push dword PTR 12
push dword PTR OFFSET obszar ; adres obszaru pami�ci
push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
call __read ; odczytywanie znak�w z klawiatury
; (dwa znaki podkre�lenia przed read)
add esp, 12 ; usuni�cie parametr�w ze stosu
; bie��ca warto�� przekszta�canej liczby przechowywana jest
; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
mov eax, 0
mov ebx, OFFSET obszar ; adres obszaru ze znakami
ptl:
mov cl,[ebx]
cmp cl,10
je bylenter
cmp cl,3ah
jb cyfra
sub cl, 55
jmp dalej
cyfra:
sub cl, 30h
dalej:
movzx ecx,cl
inc ebx
mul dwana
add eax,ecx
jmp ptl
bylenter:
pop ebp
pop edi
pop esi
pop edx
pop ecx
pop ebx
ret
wczytaj_dwu ENDP
wczytaj_EAXn PROC
push ecx
; max ilo�� znak�w wczytywanej liczby
; (dwa znaki podkre�lenia przed read)
; bie��ca warto�� przekszta�canej liczby przechowywana jest
; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
mov eax,[ebx]
pop ecx
ret
wczytaj_EAXn ENDP
przecinek PROC
pusha
push 1
push OFFSET przec
push 1
call __write
add esp,12
popa
ret
przecinek ENDP
minuss PROC
pusha
push 1
push OFFSET minu
push 1
call __write
add esp,12
popa
ret
minuss ENDP
ciag PROC
pusha
lea ebx,zmienna
mov ecx,[ebx]
mov eax,1
mov ebx,0
ptl:
cmp eax,0
jle ujemna
call wyswietl_EAX
inc ebx
dec ecx
cmp ecx,0
je koniec
sub eax,ebx
jmp dalej
ujemna:
neg eax
call minuss
call wyswietl_EAX
neg eax
inc ebx
cmp ecx,0
je koniec
add eax,ebx
jmp dalej
dalej:
jmp ptl
koniec:
popa
ret
ciag ENDP
_main PROC
call wczytaj_dwu
mov ebx,eax
call wczytaj_dwu
xchg eax,ebx
mov edx,0
div ebx
call wyswietl_EAX
call przecinek
mov eax,edx
mov mnoz, 1000
mul mnoz
mov edx,0
div ebx
call wyswietl_EAX2
;mov eax,1
;mov ebx,1
;mov ecx,15
;ptl:
;call wyswietl_EAX
;sub eax,ebx
;inc ebx
;cmp eax, 0
;jne dalej
;call wyswietl_EAX
;jmp dalej2
;dalej:
;neg eax ; tu jeszcze wyswietlic minus
;call wyswietl_EAX
;neg eax
;dalej2:
;add eax,ebx
;inc ebx
;dec ecx
;jnz ptl
;call ciag
push 0
call _ExitProcess@4
_main ENDP
END