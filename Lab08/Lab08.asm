; CSCI 150

include Irvine32.inc
include macros.inc


.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

author byte "Author: Alexander Dunn",0Dh,0Ah,0
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
keySize = $ - key
plainText BYTE "This is a secret message.", 0  

.code

Encode proc
	push esi
	push eax
	push ecx
	push edi

	EncodeChar:

	cmp byte ptr [esi], 0	; if null, string has terminated
	je Complete			; jump to Complete
	
	push ecx				; preserve counter
	mov cl, byte ptr [edi]	; store current key in cl
	ror byte ptr [esi], cl	; encode character with key
	pop ecx				; restore counter

	mov al, byte ptr [esi]	; load encoded char for echo
	call writechar			; echo encoded char
	inc esi				; move to next character
	inc edi				; move to next encoding key
	loop EncodeChar		; loop while encoding keys remain

	jmp Incomplete

	Complete:
	pop edi
	pop ecx
	pop eax
	pop esi
	cmp eax, eax			; set ZF
	jmp Return
	
	Incomplete:
	pop edi
	pop ecx
	pop eax
	call Encode			; recursive call
	pop esi

	Return:
	ret

Encode endp

Invert proc	; Negates encode/decode key
	push ecx
	push edi
	InvertChar:
		neg byte ptr [edi]
		inc edi
	loop InvertChar
	pop edi
	pop ecx
	ret
Invert endp

Decode proc
	Call Invert	; Negate key
	Call Encode	; Encode with negated key
	Call Invert	; Restore key
	ret
Decode endp

main PROC
	mov esi, OFFSET plainText
	mov ecx, keySize
	mov edi, OFFSET key

	; moved loop to run recursively inside proc
	call Encode ; encode up to keySize bytes

	mov  esi,OFFSET plainText
     mov  ecx,LENGTHOF plainText
	mov  ebx,TYPE plainText
     call DumpMem

	mov ecx, keySize
	call Decode ; decode

	mov  esi,OFFSET plainText
     mov  ecx,LENGTHOF plainText
	mov  ebx,TYPE plainText
     call DumpMem

	exit
main ENDP

end main