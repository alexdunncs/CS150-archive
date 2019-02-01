; Copying a String (CopyStr.asm)

; This program copies a string.

include Irvine32.inc
include macros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:dword

.data
source  byte  "12345",0
target  byte  SIZEOF source DUP(0)

.code

betterRandomRange proc
    sub eax, ebx
    call RandomRange
    add eax, ebx
    ret
betterRandomRange endp


main proc

;   PART ONE

	mWriteString OFFSET source ; output initial string
	mWriteSpace

	mov  ecx,SIZEOF source - 1 ; set loop counter
	mov esi, 0			  ; set iterator
pushChars:
	
	movzx eax, source[esi] ; get a character from source
	push eax			   ; push it to stack
	inc  esi			   ; move to next character
	loop pushChars		   ; repeat for entire string

	mov  ecx,SIZEOF source - 1 ; reset loop counter
	mov esi, 0			  ; reset iterator

popChars:
	pop eax			   ; pop a character from the stack
	mov target[esi], al	   ; write it to the target string
	inc  esi			   ; move to next character
	loop popChars		   ; repeat for entire string

	mWriteString OFFSET target ; output string to confirm
	mWriteln " "

	; PART TWO
	
	mov ecx, 50		   ; set loop counter

bRandRange:
	mov eax, 101		   ; set upper bound
	mov ebx, 50		   ; set lower bound 
	call betterRandomRange ; generate random number
	call WriteDec		   ; print it out
	mWriteSpace		   ; print space separator
	loop bRandRange	   ; do it again

	invoke ExitProcess,0
main endp
end main