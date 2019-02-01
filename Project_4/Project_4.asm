; CSCI 150

include Irvine32.inc
include Macros.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword


TimeObj STRUCT
	hours BYTE 0
	minutes BYTE 0
	seconds BYTE 0
	ampm BYTE 'A'
TimeObj ENDS


SetTime PROTO clockAddress:DWORD, seconds:BYTE, minutes:BYTE, hours:BYTE, ampm:BYTE
UpdateTimeObjFromSysClock PROTO clockAddress:DWORD
AddSecs PROTO clockAddress:DWORD, seconds:DWORD
AddMins PROTO clockAddress:DWORD, minutes:DWORD
AddHours PROTO clockAddress:DWORD, hours:DWORD
PrintTime PROTO clockAddress:DWORD


ToggleAMPM MACRO	;Toggles al between 'A' and 'P'.  Assumes al contains 'A' or 'P'
	cmp al, 'A'
	je MakeP
	mov al, 'A'
	jmp ToggleAMPMEnd
	MakeP:
	mov al, 'P'
	ToggleAMPMEnd:
ENDM


DecToBCD MACRO		;converts ax dec to two-digit al BCD  
	mov bl, 10	;set reg8 divisor
	div bl		;ah now stores ones, al now stores tens
	xchg al, ah	;ah now stores tens, al now stores ones (only lower nibbles occupied, assuming valid parameters)
	shl ah, 4		;lower nibble of ah now occupies upper nibble of ah
	or al, ah		;write the upper nibble of ah to the upper nibble of al
ENDM


BCDToDec MACRO			;converts two-digit al BCD to eax dec
	mov bh, al;		;copy BCD byte to bh, from which to isolate ones
	and bh, 00001111b	;isolate ones in bh
	and al, 11110000b	;isolate tens in al upper nibble
	shr al, 4			;move tens to al lower nibble
	mov bl, 10		;set reg8 multiplier
	mul bl			;ax = tens*10
	add al, bh		;add the ones back to al
	and eax, 11111111b	;clear upper 16bits of eax
ENDM


BCDPairToCharPair MACRO	;converts two-digit al BCD to ah:al char pair
	mov ah, al;		;copy BCD byte to ah, from which to isolate tens

	and ah, 11110000b	;isolate tens in upper nibble of ah
	shr ah, 4			;move to (lower nibble of) ah
	add ah, 48		;convert ah to char

	and al, 00001111b	;isolate ones in al lower nibble
	add al, '0'		;convert al to char
ENDM


PrintCharPair MACRO
	xchg al, ah	;swap tens char to al
	call WriteChar	;print it
	xchg al, ah	;swap ones char to al
	call WriteChar	;print it
ENDM


.data
author byte "Authors: Alexander Dunn, Robert Zou",0Dh,0Ah,0

clock TimeObj <>

.code
main proc

	L1:
	call Clrscr
	invoke UpdateTimeObjFromSysClock, offset clock
	invoke PrintTime, offset clock
	
	invoke addSecs, offset clock, 45
	invoke PrintTime, offset clock
	invoke addSecs, offset clock, 45
	invoke PrintTime, offset clock


	invoke addMins, offset clock, 45
	invoke PrintTime, offset clock
     invoke addMins, offset clock, 45
	invoke PrintTime, offset clock

	invoke addHours, offset clock, 8
	invoke PrintTime, offset clock
	invoke addHours, offset clock, 8
	invoke PrintTime, offset clock



	;mov ecx, 0FFFFFFh
	;HolUpDude:
	;mov eax, ecx
	;mov ecx, eax
	;loop HolUpDude


	;jmp L1

	invoke ExitProcess,0
main endp

SetTime PROC USES eax ebx esi clockAddress:DWORD, seconds:BYTE, minutes:BYTE, hours:BYTE, ampm:BYTE

	mov esi, clockAddress
	
	mov al, ampm
	mov (TimeObj ptr [esi]).ampm, al
	
	movzx ax, hours
	DecToBCD
	mov (TimeObj ptr [esi]).hours, al

	movzx ax, minutes
	DecToBCD
	mov (TimeObj ptr [esi]).minutes, al

	movzx ax, seconds
	DecToBCD
	mov (TimeObj ptr [esi]).seconds, al

	ret
SetTime ENDP


UpdateTimeObjFromSysClock PROC USES EAX EBX EDX clockAddress:DWORD ;Gets time from sysclock and updates clockAddress
	
	mov esi, clockAddress

	call GetMseconds
	mov edx, 0	;clear edx
	mov ebx, 1000	;set divisor to 1000
	div ebx		;get seconds

	mov edx, 0	;clear edx
	mov ebx, 43200 ;set divisor to 12*60*60
	div ebx		;eax = isPM, edx = seconds since midnight/noon

	cmp eax, 0	;was eax > 43200 = 12:00:00?
	jg IsPM		;if so, it's PM
	mov al, 'A'	;else set char to 'A'
	jmp ProcessHour;continue
	IsPM:		;if it's PM
	mov al, 'P'	;set char to 'P'
	ProcessHour:	;continue
	;and ax, 0FFFFh;clear first byte of ax
	push ax		;push character to the stack

	mov eax, edx	;set eax equal to the time, in seconds
	mov edx, 0	;clear edx
	mov ebx, 3600	;set divisor to 60*60
	div ebx		;eax = hours, edx = minutes and seconds, in seconds
	push eax		;push hours to the stack

	mov eax, edx	;set eax equal to  minutes and seconds, in seconds
	mov edx, 0	;clear edx
	mov ebx, 60	;set divisor to 60
	div ebx		;eax = minutes, edx = seconds
	push eax		;push minutes to the stack

	push edx		;push seconds to the stack

	push esi		;push TimeObj address

	call SetTime

	ret 4
UpdateTimeObjFromSysClock ENDP


AddSecs PROC USES EAX EBX EDX ESI clockAddress:DWORD, seconds:DWORD
    mov esi, clockAddress

    movzx eax, (TimeObj PTR [esi]).seconds
    BCDToDec
    add eax, seconds

    mov edx, 0
    mov ebx, 60
    div ebx
    xchg eax, edx
    DecToBCD
    xchg eax, edx
    mov (TimeObj PTR [esi]).seconds, dl
    
    cmp eax, 0
    je Complete
    
    invoke AddMins, clockAddress, eax
    
    Complete:
    ret 8
AddSecs ENDP


AddMins PROC USES EAX EBX EDX ESI clockAddress:DWORD, minutes:DWORD
    mov esi, clockAddress

    movzx eax, (TimeObj PTR [esi]).minutes
    BCDToDec
    add eax, minutes
    
    mov edx, 0
    mov ebx, 60
    div ebx
    xchg eax, edx
    DecToBCD
    xchg eax, edx
    mov (TimeObj PTR [esi]).minutes, dl
   
    cmp eax, 0
    je Complete
    
    invoke AddHours, clockAddress, eax

    Complete:
    ret 8
AddMins ENDP


AddHours PROC USES EAX EBX EDX ESI clockAddress:DWORD, hours:DWORD
    mov esi, clockAddress
    
    movzx eax, (TimeObj PTR [esi]).hours
    BCDToDec
    add eax, hours
    
    mov edx, 0
    mov ebx, 12
    div ebx
    xchg eax, edx
    DecToBCD
    xchg eax, edx
    mov (TimeObj PTR [esi]).hours, dl
    
    mov edx, 0
    mov ebx, 2
    div ebx
    cmp edx, 0
    je Complete
    
    mov al, (TimeObj PTR [esi]).ampm
	   ToggleAMPM
    mov (TimeObj PTR [esi]).ampm, al

    Complete:
    ret 8
AddHours ENDP


PrintTime PROC USES eax ebx esi clockAddress:DWORD
	mov esi, clockaddress

	mov al, (TimeObj ptr [esi]).hours
	BCDPairToCharPair
	PrintCharPair

	mWrite ":"

	movzx eax, (TimeObj ptr [esi]).minutes
	BCDPairToCharPair
	PrintCharPair
	
	mWrite ":"

	movzx eax, (TimeObj ptr [esi]).seconds
	BCDPairToCharPair
	PrintCharPair

	mov al, (TimeObj ptr [esi]).ampm
	call WriteChar
	mWriteLn "M"


	ret 4
PrintTime ENDP

end main