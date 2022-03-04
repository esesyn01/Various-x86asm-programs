#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
int roznica(int*, int**);
int* kopia(int tab[], unsigned int n);
char* komunikat(char* tekst);
int* szukaj(int tab[], int n);
void szyfruj(char*);
unsigned int kwadrat(unsigned int);
unsigned char iteracja(unsigned char);
int main()
{
	/*int a, b, * wsk, wynik;
	wsk = &b;
	a = 21; b = 25;
	wynik = roznica(&a, &wsk);
	printf("%d", wynik);*/

	/*int tab[5] = { 2,1,3,7,10 };
	int *tabk;
	tabk=kopia(tab, 5);
	for (int i = 0; i < 5; i++)
	{
		printf("%d ", tabk[i]);
	}*/

	/*char x[] = { "Elooo" };
	char* t = komunikat(x);
	int i = 0;
	while (t[i] != 0)
	{
		printf("%c", t[i]);
		i++;
	}*/

	/*int pomiary[7] = {-4,12,36,110,-999,2,17};
	int* wsk;
	wsk = szukaj(pomiary, 7);
	printf("%d", *wsk);*/
	
	/*char x[] = { "Elo to bedzie zaszyffrowane." };
	szyfruj(x);
	int i = 0;
	while (x[i] != 0)
	{
		printf("%c", x[i]);
		i++;
	}
	printf("\n");
	i = 0;
	while (x[i] != 0)
	{
		printf("%X ", x[i]);
		i++;
	}*/

	/*unsigned int a = 20;
	printf("%d", kwadrat(a));*/

	//printf("%d", iteracja(32));



	return 0;
}