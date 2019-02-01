; sumArray function      (sumArray.asm)

.586
.model flat,C
sumArray PROTO,
	arrayAddress:PTR DWORD, arraySize:DWORD

.code
;-----------------------------------------------
MulArray PROC uses eax ebx ecx esi edi,
	arrayAddress:PTR DWORD, arraySize:DWORD
	mov ecx, arraySize
	mov esi, arrayAddress
	mov ebx, mulFactor

	Multiply:
		mov eax, DWORD PTR [esi]
		mul ebx
		mov DWORD PTR [esi], eax
		add esi, type DWORD
		loop Multiply

		ret
MulArray ENDP
END

