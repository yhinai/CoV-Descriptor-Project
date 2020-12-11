
#include <iostream>
#include <cmath>
#define PI 3.141592654

using namespace std;

int main()
{
  double result;
  float x = -100;
  int y = 3;
  
  for (int i = -128; i < 128; i++)
    for (int j = -128; j < 128; j++)

      cout << (i+128) << "-" << (j+128) << " - " << (int) (atan2(j, i)*128/PI) << ";\n";

  return 0;
}