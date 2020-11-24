#include <iostream>  
#include <string>
#include <complex> 
#include <math.h>

using namespace std;  

#define ROW 10
#define COL 10

int arr[ROW][COL] = 
{{ 5 , 13 ,  1 , 56 , 54 , 43 , 13 , 28 , 37 , 26},
{ 35 , 42 , 16 ,  7 , 25 , 47 , 23 , 12 , 35 , 40},
{ 47 , 29 , 15 , 47 , 38 , 10 , 28 , 57 , 61 , 17},
{ 52 , 61 , 24 , 18 , 55 ,  4 , 61 , 43 , 38 , 27},
{ 50 , 24 , 47 ,  8 , 34 , 54 ,  7 ,  3 , 16 , 17},
{ 20 , 54 , 12 , 61 , 23 ,  7 , 21 , 14 , 36 ,  4},
{ 58 , 42 , 41 , 56 , 10 , 61 , 47 , 56 , 14 , 35},
{ 19 , 16 , 35 , 23 , 24 , 51 ,  7 , 63 , 10 , 17},
{  0 , 16 ,  2 ,  3 , 50 , 19 , 14 , 17 , 55 , 54},
{ 21 , 50 , 58 , 26 , 12 , 27 , 13 , 10 , 15 ,  8}};


int main(){

    for(int i = 0; i < ROW; i++)
    {
        for (int j = 0; j < COL; j++)
        {
            if ((i==0) || (j==0) ||(i==ROW-1) || (j==COL-1)) cout << "0\t";
            else cout <<  (- (arr[i-1][j-1] + 2*arr[i-1][j] + arr[i-1][j+1])
                          +  arr[i+1][j-1] + 2*arr[i+1][j] + arr[i+1][j+1])/4  << "\t";
        }
        cout << endl;
    }

    return 0;
}