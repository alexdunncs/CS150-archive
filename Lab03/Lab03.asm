; CSCI150 Lab03

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

include Irvine32.inc
include macros.inc

.data

A REAL4 -1.75
B REAL4 1.25
D REAL4 10000.5


.code
;-----------------------------------------------
__DisplayFP PROC uses EAX ECX ESI, n:REAL4	;
	mov eax, n
	mov ecx, (type real4)*8
	mov esi, 1
	PrintBit:
		mov eax, n
		mov ebx, ecx
		mov ecx, esi
		rol eax, cl
		mov ecx, ebx
		and eax, 00000001h
		cmp eax, 0
		je Zero
		mov al, '1'
		jmp Print
		Zero:
		mov al, '0'
		Print:
		call WriteChar
		cmp esi, 1
		je InsertSpace
		cmp esi, 9
		je InsertSpace
		jmp Finish
		InsertSpace:
		mov al, ' '
		call WriteChar
		Finish:
		inc esi
		loop PrintBit
		
	ret 							;
__DisplayFP ENDP

main proc
	invoke __DisplayFP, A
	mWriteLn " "
	invoke __DisplayFP, B
	mWriteLn " "
	invoke __DisplayFP, D


	invoke ExitProcess,0
main endp
end main