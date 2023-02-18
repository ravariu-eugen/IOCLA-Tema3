section .text
	global par
	
;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	pop eax			; adresa de retur
	pop ecx			; str_length
	pop edx			; str

	push edx		;
	push ecx		; refacem stiva
	push eax		;

	xor eax, eax	; contorul de paranteze


loop_par:			; parcurgem sirul de paranteze de la dreapta la stanga 
	cmp byte[edx + ecx - 1], ')'
	je increment	; daca avem o paranteza inchisa, incrementam eax	
	sub eax, 2		; altfel, decrementam eax ( -2 + 1 = -1)
increment:
	inc eax
	cmp eax, 0
	jl return0		; daca eax devine negativ, avem paranteze deschise 
	loop loop_par	; care nu vor fi niciodata inchise

	cmp eax, 0	; daca eax e diferit de 0 la sfarsit, avem paranteze inchise 
	jne return0 ; care nu vor fi niciodata deschise
return1:
	xor eax, eax
	inc eax
	ret
return0:
	xor eax, eax
	ret
