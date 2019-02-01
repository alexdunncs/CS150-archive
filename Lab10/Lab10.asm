include Irvine32.inc
include Macros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0

targetStr BYTE "ABCDE",10 DUP(0)
sourceStr BYTE "FGH",0

target BYTE "AAEBDCFBBC",0
freqTable DWORD 256 DUP(0)

.code

Str_concat proc, toAdd:PTR BYTE, fromAdd:PTR BYTE
	
	push esi
	push edi
	push ecx
	mov edi, toAdd				;load parameter toAdd
	mov esi, fromAdd			;load parameter fromAdd
	push ebp
	mov ebp, esp

	
	mov ecx, 0
	

	targetIter:				;inc edi until it points to the first null in destination string
		inc edi
		cmp byte ptr [edi], 0
		jnz targetIter

	sourceIter:				;inc ecx once for each valid character in source string
		inc ecx
		cmp byte ptr [esi + ecx], 0
		jnz sourceIter

	rep movsb					;copy from [esi] to [edi] for the desired number of bytes

	pop ebp
	pop ecx
	pop edi
	pop esi
	ret 8

Str_concat endp

Get_frequencies proc, enumStr:PTR BYTE, frequencies:PTR DWORD
	
	push esi
	push edi
	push eax
	push ebx
	push ecx


	mov esi, enumStr			;load parameter target string address to enumerate
	mov ecx, frequencies		;load parameter freqTable address

	push ebp
	mov ebp, esp

	mov ebx, 4				;store scaling factor

	incFreq:
		mov edi, ecx				;jump to first element of freqtable
		movzx eax, byte ptr [esi]	;get ascii for character
		mul ebx					;scale for DWORD
		add edi, eax				;jump to correct index of freqTable
		inc dword ptr [edi]			;increment freqTable element
		inc esi					;move esi to next cha
		cmp byte ptr [esi], 0		;check if null
		jnz incFreq				;if not, repeat
	
	pop ebp
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
	ret 8

Get_frequencies endp

main proc
	mWriteString offset author
	
	mWriteString offset targetStr
	mWriteln " "

	INVOKE Str_concat, OFFSET targetStr, OFFSET sourceStr
		
	mWriteString offset targetStr
	mWriteln " "

	INVOKE Get_frequencies, OFFSET target, OFFSET freqTable
	
	mov ecx, 256
	mov esi, offset freqTable
	PrintLoop:
		movzx eax, byte ptr [esi]
		call WriteDec
		add esi, 4
		loop Printloop

	invoke ExitProcess,0
main endp

end main