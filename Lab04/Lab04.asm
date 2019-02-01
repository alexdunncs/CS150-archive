; Copying a String (CopyStr.asm)

; This program copies a string.

include Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:dword

.data
source  DWORD  5,276,100,1234
target  DWORD  SIZEOF source DUP(0)

bigEndian BYTE 12h,34h,56h,78h
littleEndian DWORD ?

svar SBYTE 128

.code
main proc

	mov al, bigEndian
	mov BYTE PTR littleEndian + 3, al
	mov al, bigEndian + 1
	mov BYTE PTR littleEndian + 2, al
	mov al, bigEndian + 2
	mov BYTE PTR littleEndian + 1, al
	mov al, bigEndian + 3
	mov BYTE PTR littleEndian, al

	mov  esi,0				; index register
	mov  ecx,SIZEOF source - 1	; loop counter
L1:
	mov  eax,source[esi*4]		; get a character from source
	mov  target[ecx*4],eax		; store it in the target
	inc  esi					; move to next character
	loop L1					; repeat for entire string


	mov  esi,0				; index register
	mov  ecx,SIZEOF source /4	; loop counter

L2:
	mov  eax,target[esi*4]		; get a character from source
	Call WriteInt				; print contents of array element
	inc  esi					; move to next character
	loop L2					; repeat for entire string

	invoke ExitProcess,0
main endp
end main