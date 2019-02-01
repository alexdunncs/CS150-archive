; CSCI 150

include Irvine32.inc
include Macros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0
testStr byte "This is a TEST: 1, 2, 3."
alphas word 0	; Counts number of letters

limit	  SDWORD 40
sortedArr	  SDWORD 10, 17, 19, 25, 30, 40, 41, 43, 55
unsortedArr SDWORD 10, -30, 25, 15, -17, 55, 40, 41, 43

.code

isAlpha proc
	cmp al, 65	; <65 is not alpha
	jc Fail
		
	cmp al, 91	; >=65, <91 is alpha
	jc Success

	cmp al, 97		; >= 91, <97 is not alpha
	jc Fail

	cmp al, 123	; >=97, <123 is alpha
	jc Success

	jmp Fail

	Success:
	test al, 0	; set ZF
	jmp Return

	Fail:
	or al, 1		; clear ZF
	
	Return:
	ret
isAlpha endp

sumArrayUnder PROC	; pass address, length, exclusive upper limit
	push ebp		; establish stackframe
	mov ebp, esp
	push ebx		; preserve registers
	push ecx
	push edx
	push esi

	mov ebx, [ebp + 8]	   ; loads limit from stack
	mov ecx, [ebp + 12]	   ; loads array size from stack
     mov edx, [ebp + 16]	   ; loads address from stack

	mov eax, 0
	mov esi, 0

	CheckAndSumElem:	   ; print contents of array to confirm
		cmp DWORD PTR [edx + esi*4], ebx ; sets CF if <limit
		jge SkipAcc	   ; skip accumulation if not <limit
		add eax, DWORD PTR [edx + esi*4]
		SkipAcc:
		inc esi
		loop CheckAndSumElem

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop ebp

ret
sumArrayUnder ENDP

sumArrayUnderTerminate PROC	; pass address, length, exclusive upper limit
	push ebp		; establish stackframe
	mov ebp, esp
	push ebx		; preserve registers
	push ecx
	push edx
	push esi

	mov ebx, [ebp + 8]	   ; loads limit from stack
	mov ecx, [ebp + 12]	   ; loads array size from stack
     mov edx, [ebp + 16]	   ; loads address from stack

	mov eax, 0
	mov esi, 0

	CheckAndSumElem:	   ; print contents of array to confirm
		cmp DWORD PTR [edx + esi*4], ebx ; sets CF if <limit
		jge LimitHit	   ; termintate if not <limit
		add eax, DWORD PTR [edx + esi*4]
		inc esi
		loop CheckAndSumElem
	LimitHit:

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop ebp

ret
sumArrayUnderTerminate ENDP

main proc
	mov	ecx, LENGTHOF testStr

	ProcessCharacter:
		mov al, testStr[ecx - 1]
		call isAlpha;
		jnz NotAlpha
		inc alphas
		NotAlpha:
		loop ProcessCharacter
	
	movzx eax, alphas
	call WriteDec
	mWriteLn " alpha chars "
		
	push OFFSET sortedArr		; pass three args
	push LENGTHOF sortedArr
	push limit

	call sumArrayUnder
	call WriteInt
	mWriteLn " "

	add esp, 12				; ditch the three arguments

	push OFFSET unsortedArr	; pass three args
	push LENGTHOF unsortedArr
	push limit

	call sumArrayUnder
	call WriteInt
	mWriteLn " "

	add esp, 12				; ditch the three arguments

	push OFFSET sortedArr		; pass three args
	push LENGTHOF sortedArr
	push limit

	call sumArrayUnderTerminate
	call WriteInt
	mWriteLn " "

	add esp, 12				; ditch the three arguments



	invoke ExitProcess,0
main endp
end main