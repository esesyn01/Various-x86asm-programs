#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
#include<Windows.h>
extern int szukaj4_max(int w,int x, int y, int z);
extern void przeciwna(int *x);
void plus_jeden(int *x);
void odejmij_jeden(int** x);
void przestaw(int tab[], int n);
int* szukaj(int tab[], int n);
int odejmowaniee(int** a, int* b);
int dataa(SYSTEMTIME* s);
int func(int n);
int weektor(int tab1[], int tab2[], int n);
int* merge(int tab1[], int tab2[], int n);
int sumo(int n, ...);
unsigned int getsys(char* dir);
int dzielenie(int** a, int* b);
int main()
{
	//int a, b, c, d, wynik;
	//printf("Wpisz 4 liczby\n");
	////scanf("%d %d %d %d", &a, &b, &c, &d);
	//for (int i = 1; i < 5; i++)
	//{
	//	for (int j = 1; j < 5; j++)
	//	{
	//		for (int k = 1; k < 5; k++)
	//		{
	//			for (int l = 1; l < 5; l++)
	//			{
	//				wynik = szukaj4_max(i, j, k, l);
	//				if (wynik != 4)
	//				{
	//					printf("Blad dla %d %d %d %d\n", i, j, k, l);
	//				}
	//			}
	//		}
	//	}
	//}
	////wynik = szukaj4_max(a, b, c, d);
	//printf("Max to %d", wynik);
	/*int x;
	printf("Wpisz liczbe\n");
	scanf("%d", &x);	
	przeciwna(&x);
	printf("Liczba przeciwna to %d", x);*/
	/*int k=-543;
	int* w;
	w = &k;
	odejmij_jeden(&w);
	printf("%d", k);*/
	/*int n;
	scanf("%d", &n);
	int* tab;
	tab = (int*)malloc(n * sizeof(int));
	for (int i = 0; i < n; i++)
	{
		scanf("%d", &tab[i]);
	}
	for (int i = 0; i < n-1; i++)
	{
		przestaw(tab, n - i);
	}
	for (int i = 0; i < n; i++)
	{
		printf("%d ", tab[i]);
	}
	free(tab);*/
	/*int tab[7] = { 489,7,12,-5,2,99999 };
	int n = 7;
	int* w;
	w = szukaj(tab, n);
	printf("%d", *w);*/
	/*int a=20, b=2;
	int* w = &a;
	printf("%d", odejmowaniee(&w,&b));*/
	/*SYSTEMTIME s;
	int m=dataa(&s);
	printf("%d", m);*/
	//int m = dataa(&s);
	/*int tab1[3] = { 1,-2,3 };
	int tab2[3] = {4,5,6};
	int n = 3;
	int* w = merge(tab1, tab2, n);
	if (w == 0)
	{
		printf("Lipa");
		return -1;
	}
	for (int i = 0; i < 2 * n; i++)
	{
		printf("%d ", w[i]);
	}*/
	/*int* tab = func(n);
	for (int i = 0; i < n; i++)
	{
		printf("%d ", tab[i]);
	}*/
	/*int n = 3,w;
	w = weektor(tab1, tab2, n);
	printf("%d", w);*/
	/*int summ = sumo(5, 1, 2, 3, 4, 5);
	printf("%d", summ);*/
	/*char* w = {"C:\\Windows\\system32\\ded"};
	printf("%d", getsys(w));*/
	/*GetSystemDirectory(w, 200);
	for (int i=0; i<200; i++)
	printf("%c", w[i]);*/
	int a = 7, b = 2;
	int* w = &a;
	printf("%d", dzielenie(&w, &b));
	return 0;
}