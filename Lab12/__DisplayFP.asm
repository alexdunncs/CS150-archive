; CSCI150 Lab03

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

include Irvine32.inc
include macros.inc

.data
author byte "Author: Alexander Dunn",0Dh,0Ah,0

a SWORD 20
b SWORD 15
d SWORD 30

.code
main proc
	mov edx, OFFSET author
	call WriteString

	mov ax, 15d	;move 15 to ax
	call DumpRegs
	mShow ax, in
	add ax, 30d	;add 30 to ax
	call DumpRegs
	mShow ax, in
	neg ax		;perform implicit multiplication by -1
	call DumpRegs
	mShow ax, in
	add ax, 20d	;add 20 to ax
	call DumpRegs
	mShow ax, in

	mov bx, b		;move 15 to ax
	call DumpRegs
	mShow bx, in
	add bx, d		;add 30 to ax
	call DumpRegs
	mShow bx, in
	neg bx		;perform implicit multiplication by -1
	call DumpRegs
	mShow bx, in
	add bx, a		;add 20 to ax
	call DumpRegs
	mShow bx, in

	invoke ExitProcess,0
main endp
end main