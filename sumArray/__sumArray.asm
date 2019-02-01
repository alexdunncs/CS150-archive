; __sumArray function      (__sumArray.asm)

.586
.model flat,C
__sumArray PROTO,
	arrayAddress:PTR DWORD, arraySize:DWORD

.code
;-----------------------------------------------
__sumArray PROC uses ecx esi edi,
	arrayAddress:PTR DWORD, arraySize:DWORD
	mov ecx, arraySize
	mov esi, arrayAddress
	mov eax, 0;

	AddVal:
		add eax, DWORD PTR [esi]
		add esi, type DWORD
		loop AddVal

		ret
__sumArray ENDP
END