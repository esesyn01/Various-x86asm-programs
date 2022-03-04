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
dekoder db '0123456789ABCDEF'
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
mov byte PTR znaki [esi], 20H ; kod spacji
dec esi ; zmniejszenie indeksu
jmp wypeln
wyswietl:
mov byte PTR znaki [0], 0AH ; kod nowego wiersza
mov byte PTR znaki [11], 0AH ; kod nowego wiersza
; wy�wietlenie cyfr na ekranie
push dword PTR 12 ; liczba wy�wietlanych znak�w
push dword PTR OFFSET znaki ; adres wy�w. obszaru
push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
call __write ; wy�wietlenie liczby na ekranie
add esp, 12 ; usuni�cie parametr�w ze stosu
popa
ret
wyswietl_EAX ENDP
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
_main PROC
call wczytaj_EAX
mul eax
call wyswietl_EAX
call wyswietl_EAX_hex
push 0
call _ExitProcess@4
_main ENDP
