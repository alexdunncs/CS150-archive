; __isPrime function      (__isPrime.asm)

.586
.model flat,C

sqrt PROTO
__isPrime PROTO, n:DWORD


.code
;-----------------------------------------------
sqrt PROC
    fild    dword ptr [esp + 4]	; load the first stack element into the FPU
    fsqrt						; use the FPU to calculate sqrt
    fistp   dword ptr [esp + 4]	; store the result in the first stack element
    ret 

sqrt ENDP



__isPrime PROC uses ECX, n:DWORD		; sets eax = 0 if compound, sets eax = 1 if prime
	
	mov eax, n					; fetch arg
	push eax						; push arg to stack for sqrting
	call sqrt						; sqrts the first stack element
	pop ecx						; sqrt of eax becomes our loop counter
	
	Continue:
	cmp ecx, 1					; If ecx has reached 1
	je Prime						; Argument has not failed any primality test
	
	mov eax, dword ptr [ebp + 8]		; reset argument value
	mov edx, 0					; clear edx to prepare for div
	div ecx						; eax = eax / ecx, edx = eax % ecx
	cmp edx, 0					; check for compositeness
	je Composite					; jump if composite
	loop Continue					; otherwise, loop and try next candidate

	Composite:					; if composite
	mov eax, 0					; set EAX = 0
	jmp Complete

	Prime:						; if prime
	mov eax, 1					; set EAX = 1
	jmp Complete

	Complete:
	ret 							;
__isPrime ENDP

END