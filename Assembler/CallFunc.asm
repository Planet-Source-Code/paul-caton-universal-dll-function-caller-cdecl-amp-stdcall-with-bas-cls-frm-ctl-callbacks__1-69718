
;******************************************************************************************
;
; Universal function caller... both CDECL and stdcall
;
; v1.00 20071201 Original cut.......................................................... prc
;******************************************************************************************
; FASM syntax

use32						;32bit

	call	L1				;Call the next instruction
L1:	pop	eax				;Pop the return address into eax (eax = L1)

	mov	[eax+(L4-L1)], esp		;Save the stack pointer to L4

	mov	eax, dword [esp+8]		;Address of the parameter block into eax
	mov	ecx, [eax]			;Number of parameters into ecx
	jecxz	L3				;If ecx = 0 (no parameters) then jump over the parameter push loop

L2:	push	dword [eax + ecx * 4]		;Push the parameter
	loop	L2				;Next parameter

L3:	db	0E8h				;Call relative
	dd	55555555h			;Relative address of the target function, patched by cCallFunc.cls

	db	0BCh				;Mov esp, absolute value
L4:	dd	55555555h			;Absolute value, patched by the code after 'L1'

	mov	edx, dword [esp+12]		;Get the address of the return value location
	mov	[edx], eax			;Write the function return value to the return value location
	xor	eax, eax			;Clear eax, indicates to VB that all is well
	ret	12				;Return
	db	0				;Padding