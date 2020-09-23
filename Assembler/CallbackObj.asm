
;******************************************************************************************
;
; Wrap a object (cls/frm/ctl) callback from a CDECL or stdcall function
;
; v1.00 20071201 Original cut.......................................................... prc
;******************************************************************************************
; FASM syntax

use32						;32bit

	mov	eax, esp			;Save the stack pointer

	call	L1				;Call the next instruction
L1:	pop	edx				;Pop the return address into edx (edx = L1)

	add	edx, (L5-L1)			;Add the offeset to L5 (edx = L5)
	push	edx				;Push the return value location

	mov	ecx, 55h			;Number of parameters into ecx, patched at runtime
	jecxz	L3				;If ecx = 0 (no parameters) jump over the parameter push loop

L2:	push	dword [eax + ecx * 4]		;Push the parameter
	loop	L2				;Next parameter

L3:	push	55555555h			;Push the object address, patched at runtime
	db	0E8h				;Op-code for a relative address call
	dd	55555555h			;Address of target object function, patched at run-time

	call	L4				;Call the next instruction
L4:	pop	edx				;Pop the return address into edx (edx = L4)

	mov	eax, [edx+(L5-L4)]		;Move the return value stored at L5 to eax
	ret	55h				;Return to caller, stack adjustment patched at runtime

L5:	dd	0				;Return address of the caller saved here