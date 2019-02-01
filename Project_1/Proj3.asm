; Project Three

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

include Irvine32.inc
include macros.inc

.data ; initialised variables

author byte "Author: Alexander Dunn",0Dh,0Ah,0

.data? ; non-initialised (i.e. zeroed) variables


.code

sqrt PROC
    fild    dword ptr [esp + 4]	; load the first stack element into the FPU
    fsqrt						; use the FPU to calculate sqrt
    fistp   dword ptr [esp + 4]	; store the result in the first stack element
    ret 

sqrt ENDP



isPrime PROC						; takes arg from stack.  sets zf if compound, clears zf if prime
	push ebp						; establish stackframe
	mov ebp, esp
	push eax						; preserve in-use regs
	push ecx

	mov eax, dword ptr [ebp + 8]		; fetch arg
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
	cmp eax, eax					; set ZF
	jmp Complete

	Prime:						; if prime
	cmp eax, 0					; clear ZF
	jmp Complete

	Complete:

	pop ecx						; restore preserved regs
	pop eax
	pop ebp
ret 4							; pop arg
isPrime ENDP



smallestPrimeGEX PROC				; takes arg from stack, stores closest prime >=arg in eax
	push ebp						; establish stackframe
	mov ebp, esp

	mov eax, dword ptr [ebp + 8]		; fetch arg to eax

	Continue:
	push eax						; push arg
	call isPrime					; clear ZF if prime, else set
	jnz Complete					; jump if prime

	inc eax						; iterate to next candidate
	cmp eax, 2000000011				; check for high candidate limit
	ja 	LimitReached				; jump if limit reached
	jmp Continue					; else loop and process new candidate

	LimitReached:					; if limit reached with no prime found
	mov eax, 0					; set error value

	Complete:
	pop ebp

ret 4							; pop arg
smallestPrimeGEX ENDP



largestPrimeLEX PROC	; takes arg from stack, stores closest prime >=arg in eax
	push ebp						; establish stackframe
	mov ebp, esp

	mov eax, dword ptr [ebp + 8]		; fetch arg to eax

	Continue:
	push eax						; push arg
	call isPrime					; clear ZF if prime, else set
	jnz Complete					; jump if prime

	dec eax						; iterate to next candidate
	jmp Continue					; loop and process new candidate

	Complete:
	pop ebp

ret 4							; pop arg
largestPrimeLEX ENDP



allPrimes2toX PROC	; takes x in eax, stores closest prime <=x in eax
	push ebp					; establish stackframe
	mov ebp, esp
	push ecx					; preserve in-use reg

	mov eax, dword ptr [ebp + 8]	; fetch arg

	mov ecx, eax				; assign loop counter based on arg
	dec ecx					; with -1 offset, since it starts at 2
	mov eax, 2				; assign starting value of 2
	
	Continue:
	push eax					; push arg
	call isPrime				; clear ZF if prime, else set
	jz Skip					; if composite, skip console write step

	call WriteDec				; write to console
	mWriteLn " "

	Skip:
	inc eax					; select next candidate
	loop Continue				; loop and process next candidate

	Complete:
	pop ecx					; restore reg
	pop ebp

ret 4						; pop arg
allPrimes2toX ENDP



main proc
	mov edx, OFFSET author
	call WriteString

	Begin:
	
	mWriteLn " "
	mWriteLn " "
	mWriteLn " "

	mWriteLn "Input: [2,2000000000]"
	mWriteLn "Output selection: 1 - Largest smaller/equal prime"
	mWriteLn "                  2 - Smallest larger/equal prime"
	mWriteLn "                  3 - List all primes on [2,x]"
	
	mWrite "Input: "
	call ReadDec
	mWriteLn " "
	push eax

	mWrite "Selection: "
	call ReadDec
	mWriteLn " "
	cmp eax, 2
	jb Option1
	je Option2
	ja Option3

	Option1:
	;pop eax
	call largestPrimeLEX
	call WriteDec
	jmp Begin

	Option2:
	;pop eax
	call smallestPrimeGEX
	call WriteDec
	jmp Begin

	Option3:
	;pop eax
	call allPrimes2toX
	jmp Begin





	invoke ExitProcess,0
main endp
end main
