
;******************************************************************************************
;
; Wrap a .bas module callback from a CDECL function
;
; v1.00 20071201 Original cut.......................................................... prc
;******************************************************************************************
; FASM syntax

use32						;32bit

	call	L1				;Call the next instruction
L1:	pop	eax				;Pop the return address into eax (eax = L1)

	pop	dword [eax+(L3-L1)]		;Pop the calling cdecl function's return address to the save location

	db	0E8h				;Op-code for a relative address call
	dd	55555555h			;Address of target vb module function, patched at run-time

	sub	esp, 55h			;Unfix the stack, our caller expects to do it

	call	L2				;Call the next instruction
L2:	pop	edx				;Pop the return address into edx (edx = L2)

	push	dword [edx+(L3-L2)]		;Push the saved return address, the stack is now as it was on entry to callback_wrapper
	ret					;Return to caller

	db	0				;Alignment pad
L3:	dd	0				;Return address of the cdecl caller saved here