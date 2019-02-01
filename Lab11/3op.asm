; CSCI 150

include Irvine32.inc
include Macros.inc


add3 MACRO destination, source1, source2
	mov eax, source1
	add eax, source2
	mov destination, eax
ENDM

sub3 MACRO destination, source1, source2
	mov eax, source1
	sub eax, source2
	mov destination, eax
ENDM

mul3 MACRO destination, source1, source2
	mov eax, source1
	mul source2
	mov destination, eax
ENDM

div3 MACRO destination, source1, source2
	mov eax, source1
	mov edx, 0
	div source2
	mov destination, eax
ENDM

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0
destination DWORD ?
source1 DWORD 25
source2 DWORD 10

.code
main proc
	add3 destination, source1, source2
	mov eax, destination
	call WriteDec
	mWriteln " "
	sub3 destination, source1, source2
	mov eax, destination
	call WriteDec
	mWriteln " "
	mul3 destination, source1, source2
	mov eax, destination
	call WriteDec
	mWriteln " "
	div3 destination, source1, source2
	mov eax, destination
	call WriteDec
	mWriteln " "

	;invoke ExitProcess,0
main endp
END main
