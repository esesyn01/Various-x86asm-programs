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
dziesiec dd 10 ; mno¿nik
dekoder db '0123456789ABCDEF'
.code
wyswietl_EAX PROC
pusha
mov esi, 10 ; indeks w tablicy 'znaki'
mov ebx, 10 ; dzielnik równy 10
konwersja:
mov edx, 0 ; zerowanie starszej czêœci dzielnej
div ebx ; dzielenie przez 10, reszta w EDX,
; iloraz w EAX
add dl, 30H ; zamiana reszty z dzielenia na kod
; ASCII
mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
dec esi ; zmniejszenie indeksu
cmp eax, 0 ; sprawdzenie czy iloraz = 0
jne konwersja ; skok, gdy iloraz niezerowy
; wype³nienie pozosta³ych bajtów spacjami i wpisanie
; znaków nowego wiersza
wypeln:
or esi, esi
jz wyswietl ; skok, gdy ESI = 0
mov byte PTR znaki [esi], 20H ; kod spacji
dec esi ; zmniejszenie indeksu
jmp wypeln
wyswietl:
mov byte PTR znaki [0], 0AH ; kod nowego wiersza
mov byte PTR znaki [11], 0AH ; kod nowego wiersza
; wyœwietlenie cyfr na ekranie
push dword PTR 12 ; liczba wyœwietlanych znaków
push dword PTR OFFSET znaki ; adres wyœw. obszaru
push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
call __write ; wyœwietlenie liczby na ekranie
add esp, 12 ; usuniêcie parametrów ze stosu
popa
ret
wyswietl_EAX ENDP
wczytaj_EAX PROC
push ebx
push ecx
; max iloœæ znaków wczytywanej liczby
push dword PTR 12
push dword PTR OFFSET obszar ; adres obszaru pamiêci
push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
call __read ; odczytywanie znaków z klawiatury
; (dwa znaki podkreœlenia przed read)
add esp, 12 ; usuniêcie parametrów ze stosu
; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
mov eax, 0
mov ebx, OFFSET obszar ; adres obszaru ze znakami
pobieraj_znaki:
mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
; ASCII
inc ebx ; zwiêkszenie indeksu
cmp cl,10 ; sprawdzenie czy naciœniêto Enter
je byl_enter ; skok, gdy naciœniêto Enter
sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
movzx ecx, cl ; przechowanie wartoœci cyfry w
; rejestrze ECX
; mno¿enie wczeœniej obliczonej wartoœci razy 10
mul dword PTR dziesiec
add eax, ecx ; dodanie ostatnio odczytanej cyfry
jmp pobieraj_znaki ; skok na pocz¹tek pêtli
byl_enter:
; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w
pop ecx
pop ebx
ret
wczytaj_EAX ENDP
wyswietl_EAX_hex PROC
pusha
sub esp, 12
mov edi, esp ; adres zarezerwowanego obszaru
mov ecx, 8 ; liczba obiegów pêtli konwersji
mov esi, 1 ; indeks pocz¹tkowy u¿ywany przy
ptl3hex:
rol eax, 4
; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy
; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym
mov ebx, eax ; kopiowanie EAX do EBX
and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX
mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
; przes³anie cyfry do obszaru roboczego
mov [edi][esi], dl
inc esi ;inkrementacja modyfikatora
loop ptl3hex ; sterowanie pêtl¹

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
; wyœwietlenie przygotowanych cyfr
push 10 ; 8 cyfr + 2 znaki nowego wiersza
push edi ; adres obszaru roboczego
push 1 ; nr urz¹dzenia (tu: ekran)
call __write ; wyœwietlenie
; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
; przez 3 rozkazy push przed rozkazem call
; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu
add esp, 24

popa ; odtworzenie rejestrów
ret ; powrót z podprogramu
wyswietl_EAX_hex ENDP
_main PROC
call wczytaj_EAX
mul eax
call wyswietl_EAX
call wyswietl_EAX_hex
push 0
call _ExitProcess@4
_main ENDP
