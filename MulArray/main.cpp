// main.cpp - Testing the IndexOf function.

#include <iostream>
#include <time.h>
#include "__sumArray.h"
using namespace std;

int main()  {
	int arr[5] = {1,2,3,4,5};
	
	int sum = sumArray(arr, 5);
	
	std::cout << sum;

	return 0;
}