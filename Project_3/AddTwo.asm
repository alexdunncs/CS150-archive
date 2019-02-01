; CSCI 150

include Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0

.code
main proc
	mov	eax,5				
	add	eax,6				

	invoke ExitProcess,0
main endp
end main