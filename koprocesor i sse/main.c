#include<stdio.h>
#include<xmmintrin.h>
float srednia(float* tab, unsigned int n);
float nowy(float x);
void dodaj_SSE(float*, float*, float*);
void pierwiastek_SSE(float*, float*);
void odwrotnosc_SSE(float*, float*);
void maxy(int*, int*, int*, int);
void sumaa(char*,char*,char*);
void konww(int* c, float* z);
void pm_jeden(float* tabl);
float obje(unsigned int R, unsigned int r, float h);
float rzut(float v, float a);
void tangi();
float potega(unsigned char k, int n);
void vmax(float*,int);
__m128 mull(__m128 one, __m128 two);
void dziel(__m128* tab, unsigned int n, float dzielnik);
int main()
{
	/*unsigned int n = 3;
	float tablica[3] = { 3.3,12.6,-7.2 };
	float sr = srednia(tablica, n);
	printf("%f", sr);*/
	/*printf("%f\n", nowy(2.0));*/
	/*float x = 2.0;
	float sum = 0;
	for (int i = 1; i < 20; i++)
	{
		float temp = x;
		for (int k=1; k<=i; k++)
		{
			temp *= x;
			temp /= k;
		}
		temp /= x;
		sum += temp;
	}
	sum += 1;
	printf("%f", sum);*/
	//float p[4] = { 1.0, 1.5, 2.0, 2.5 };
	//float q[4] = { 0.25, -0.5, 1.0, -1.75 };
	//float r[4];
	//dodaj_SSE(p, q, r);
	//printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	//printf("\n%f %f %f %f", q[0], q[1], q[2], q[3]);
	//printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	//printf("\n\nObliczanie pierwiastka");
	//pierwiastek_SSE(p, r);
	//printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	//printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	//printf("\n\nObliczanie odwrotnoœci - ze wzglêdu na stosowanie");
	//printf("\n12-bitowej mantysy obliczenia s¹ ma³o dok³adne");
	//odwrotnosc_SSE(p, r);
	//printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	//printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);

	/*char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122,-121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3,3, 3, 3, 3, 3, 3, 3, 3 };
	char wyn[16];
	sumaa(liczby_A, liczby_B, wyn);
	for (int i = 0; i < 16; i++)
	{
		printf("%d ", wyn[i]);
	}*/

	//int a[2] = { -17, 24 };
	//float r[4];
	//// podany rozkaz zapisuje w pamiêci od razu 128 bitów,
	//// wiêc musz¹ byæ 4 elementy w tablicy
	//konww(a, r);
	//printf("\nKonwersja = %f %f\n", r[0], r[1]);

	//float tablica[4] = { 27.5,143.57,2100.0, -3.51 };
	//printf("\n%f %f %f %f\n", tablica[0],tablica[1], tablica[2], tablica[3]);
	//pm_jeden(tablica);
	//printf("\n%f %f %f %f\n", tablica[0],tablica[1], tablica[2], tablica[3]);

	//printf("%f", obje(8, 4, 6.1));

	//printf("%f", rzut(8,45));

	//tangi();

	//printf("%f", potega(5,-2));

	/*int v1[8] = { 1,-1,2,-2,3,-3,4,-4 };
	int v2[8] = {-4,-3,-2,-1,0,1,2,3};
	int w[8];
	maxy(v1, v2, w, 8);
	for (int i = 0; i < 8; i++)
	{
		printf("%d ", w[i]);
	}*/

	/*float t[4] = { 27.5,143.57,21000.0,-3.51 };
	vmax(t, 2);
	for (int i = 0; i < 4; i++)
	{
		printf("%f ", t[i]);
	}*/

	/*__m128 one;
	one.m128_i32[0] = 2;
	one.m128_i32[1] = 1;
	one.m128_i32[2] = 3;
	one.m128_i32[3] = 7;
	__m128 two;
	two.m128_i32[0] = -4;
	two.m128_i32[1] = 2;
	two.m128_i32[2] = -8;
	two.m128_i32[3] = 12;
	__m128 w = mull(one, two);
	for (int i = 0; i < 4; i++)
	{
		printf("%d ", w.m128_i32[i]);
	}*/

	__m128 tablica[4] = { (__m128) { 1.0f, 2.0f, 3.0f, 4.0f },
						(__m128) {5.0f, 6.0f, 7.0f, 8.0f},
						(__m128) {9.0f, 10.0f, 11.0f, 12.0f},
						(__m128) {13.0f, 14.0f, 15.0f, 16.0f} };

	dziel(tablica, 4, 2.0);

	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++)
			printf("%d,%d=%f\n", i, j, tablica[i].m128_f32[j]);
	}

	return 0;
}