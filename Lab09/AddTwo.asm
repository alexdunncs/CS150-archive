; CSCI 150

include Irvine32.inc
include Macros.inc


.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0

.code

EuclidGCD proc, val1:DWORD, val2:DWORD
	push eax		; Preserve regs
	push ebx
	mov ebx, val2	; Load parameters
	mov eax, val1
	push ebp		; Establish stack-frame
	mov ebp, esp

	cmp eax, ebx   ; Compare eax, ebx
	jg Ordered	; eax < ebx, correct order for subtraction
	jl Swap		; eax > ebx, requires swap
				; Otherwise, equal
	call WriteDec	; Display result
	jmp	Complete	; Begin unwinding the recursive calls

	Swap:
	xchg eax, ebx	; Swap eax, ebx

	Ordered:
	sub eax, ebx	; Replace biggest with difference
	push ebx		; Push new biggest to stack
	push eax		; Push new smaller to stack
	call EuclidGCD	; Recurse

	Complete:
	pop ebp
	pop ebx
	pop eax
	ret 8

EuclidGCD endp

EuclidGCDIter proc, val1:DWORD, val2:DWORD
	push eax		; Preserve regs
	push ebx
	mov ebx, val2	; Load parameters
	mov eax, val1
	push ebp		; Establish stack-frame
	mov ebp, esp

	Iterate:
		cmp eax, ebx   ; Compare eax, ebx
		jg Ordered	; eax < ebx, correct order for subtraction
		jl Swap		; eax > ebx, requires swap
					; Otherwise, equal
		call WriteDec	; Display result
		jmp	Complete	; Begin unwinding the recursive calls

		Swap:
		xchg eax, ebx	; Swap eax, ebx

		Ordered:
		sub eax, ebx	; Replace biggest with difference
		jmp Iterate
	
	Complete:
	pop ebp
	pop ebx
	pop eax
	ret 8

EuclidGCDiter endp

main proc
	INVOKE EuclidGCD, 5, 20
	mWriteln " "
	INVOKE EuclidGCD, 24, 18
	mWriteln " "
	INVOKE EuclidGCD, 11,7
	mWriteln " "
	INVOKE EuclidGCD, 432, 226
	mWriteln " "
	INVOKE EuclidGCD, 26,13
	mWriteln " "
	mWriteln " "
	INVOKE EuclidGCDIter, 5, 20
	mWriteln " "
	INVOKE EuclidGCDIter, 24, 18
	mWriteln " "
	INVOKE EuclidGCDIter, 11,7
	mWriteln " "
	INVOKE EuclidGCDIter, 432, 226
	mWriteln " "
	INVOKE EuclidGCDIter, 26,13


	invoke ExitProcess,0
main endp
end main