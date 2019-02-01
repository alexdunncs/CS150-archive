// main.cpp - Testing the sumArray function.

#include <iostream>
#include "__sumArray.h"
using namespace std;

int main()  {
	uint32_t arr[5] = {1,2,3,4,5};
	
	uint32_t sum = sumArray(arr, 5);
	
	std::cout << sum;

	return 0;
}