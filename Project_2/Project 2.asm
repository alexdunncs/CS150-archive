; CSCI 150 Project 2

include Irvine32.inc
include macros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0
n DWORD ?
lowFib DWORD 0
highFib DWORD 1
sum DWORD 0

destArr DWORD 22 DUP(0)  ; to store vals for extra credit

.code

fibonacci PROC
	mWrite "Enter a positive number [2 - 20] --> "
	call ReadInt ;read standard input as int to eax
	mov n, eax
	
	mWrite "Fibonacci sequence: 0"
	
	mov ecx, n

	printAndGenNext:
		mWrite ", "
		mov eax, highFib
		call WriteDec
		add sum, eax
		call generateNextFib
		loop printAndGenNext	

     mWriteLn " "	
	mWrite "Sum: "
	mov eax, sum
	call WriteDec
	
	mWriteLn " "
	mWrite "Last value: "
	mov eax, ebx
	call WriteDec
	mWriteLn " "
	
ret
fibonacci ENDP

fibonacci2 PROC
	;eax stores n
	;ebx stores storage array (of type BYTE) offset (address)
	
	push eax				  ;preserve used regs
	push ecx
	push esi

	mov ecx, eax			  ; init loop counter

	mov DWORD PTR [ebx], 0	  ; init first two numbers
	mov DWORD PTR [ebx+4], 1
	
	mov esi, ebx			  ; init array element iterator
	add esi, 8

	storeNext:
		mov eax, 0				 ; init value with 0
		add eax, DWORD PTR [esi - 4]; add previous value
		add eax, DWORD PTR [esi - 8]; and the one before that
		mov DWORD PTR [esi], eax

		add esi, 4				 ; now points to next free element
		loop storeNext	
	
	pop esi	 ; restore changed regs
	pop ecx
	pop eax
ret
fibonacci2 ENDP

generateNextFib PROC
    push eax	 ; preserve regs
    ;push ebx	   required to preserve last value

    mov eax, lowFib	    ; sum to generate next number
    add eax, highFib
    mov ebx, highFib    ; move old high var to register
    mov lowFib, ebx	    ; then to low var
    mov highFib, eax    ; move new number to second

    ;pop ebx ; Restore used registers
    pop eax

ret
generateNextFib ENDP

printArray PROC	; pass address, length
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push esi

	mov ecx, [ebp + 8] ; loads length from stack
	mov ebx, [ebp + 12] ; loads address from stack
	mov esi, 0

	printElem:			; print contents of array to confirm
		mov eax, DWORD PTR [ebx + esi] ; cout confirmation
		call WriteDec
		mWrite " "
		add esi, 4
		loop printElem

	pop esi
	pop ecx
	pop ebx
	pop eax
	pop ebp

ret
printArray ENDP

sumArray PROC	; pass address, length
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push esi

	mov ecx, [ebp + 8] ; loads length from stack
	mov ebx, [ebp + 12] ; loads address from stack
	mov esi, 0
	mov eax, 0 ; initialise sum

	printElem:			; print contents of array to confirm
		add eax, DWORD PTR [ebx + esi] ; add element to sum
		add esi, 4
		loop printElem

	pop esi
	pop ecx
	pop ebx
	pop ebp

ret
sumArray ENDP

main proc
	call fibonacci			; n = 4 test

	call fibonacci			; n = 20 test

	mov eax, 10			; extra credit, n = 10
	mov ebx, OFFSET destArr  ; using register parameters
	call fibonacci2
	
	push OFFSET destArr ; second argument, using stack parameters
	push 12			; first argument
	call printArray	; print the array
	call sumArray		; sum the array
	mWrite "Sum: "
	call writeDec
	add esp, 8		; ditch the two arguments

	invoke ExitProcess,0
main endp
end main