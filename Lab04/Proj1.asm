; Project One

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

include \masm32\include\masm32rt.inc

.data ; initialised variables

v1 sdword 1
v2 sdword 1
v3 sdword 1
v4 word 1


.data? ; non-initialised (i.e. zeroed) variables

r1 sdword ?
r2 word ?


.code
main proc
	mov eax, v1
	add eax, v3
	mov ebx, v2
	sub ebx, eax
	mov eax, 1
	sub eax, ebx
	mov r1, eax

	mov ax, v4
	add ax, 10h
	mov r2, ax

	invoke ExitProcess,0
main endp
end main
