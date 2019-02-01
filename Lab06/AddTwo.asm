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

;PART ONE
	mov al, 11111000b	;signed			
	mov bl, 00011111b	;unsigned
	
	; based on flags, is cmp implemented by performing a test SUB dest, source?

	cmp al, bl	; !ZF, !CF, SF, !OF
	call dumpregs
	cmp bl, al	; !ZF, CF, !SF, !OF
	call dumpregs
	cmp al, al	; ZF, !CF, !SF, !OF
	call dumpregs

;PART TWO WITH EC (works for 2bit and 8bit)
	mov cl, al ;copy al, since we need to use it twice
	and cl, bl ;store al&bl in cl
	or  al, bl ;store al^bl in al
	sub al, cl ; holds 11100111b

	mov ebx, 1	; prepare to write 8bit
	call WriteBinB ; write result to console
	

	invoke ExitProcess,0
main endp
end main