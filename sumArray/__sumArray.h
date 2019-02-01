extern "C" {

	void __sumArray(uint32_t* array , uint32_t arraySize);
}

uint32_t sumArray(uint32_t* array , uint32_t arraySize) {
		uint32_t retVal = 0;
		__sumArray(array, arraySize);
		__asm mov retVal, eax;
		return retVal;
}