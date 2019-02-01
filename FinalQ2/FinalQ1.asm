include Irvine32.inc
include Macros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0

n DWORD 35
sum DWORD ?
count DWORD ?

.code

main proc
	
	mov count, 0
	mov sum, 0

	call ReadDec	    ; read stdInput
	mov n, eax	    ; move value to n

	L1:
	   mov eax, n	    ; eax = n
	   add sum, eax    ; eax = n + sum

	   mov eax, n	    ; eax = n again
	   shr eax, 1	    ; eax /= 2
	   mov n, eax	    ; n = eax

	   inc count	    ; count = count + 1
	   cmp n, 0	    ; if n > 0

	   jg L1		    ; loop

    mov eax, count
    mWrite "Count: "
    call WriteDec

    mov eax, sum
    mWrite " Sum: "
    call WriteDec

	invoke ExitProcess,0
main endp

end main