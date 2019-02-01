#include <iostream>
#include "sumArray.h"
using namespace std;



int main()  {
	uint32_t myArray[100], sum, n;
	
	sum = sumArray(myArray, n);
	
	std::cout << sum;

	return 0;
}