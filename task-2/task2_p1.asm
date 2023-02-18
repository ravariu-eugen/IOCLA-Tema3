section .text
	global cmmmc
	
;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	pop eax 		; adresa de retur
	pop ecx			; a
	pop edx 		; b
	push eax		; punem adresa de retur inapoi pe stiva
	push edx		; punem valorile inapoi de stiva pentru a le folosi 
	push ecx		; mai tarziu la produs
	
	; mai intai calculam cmmdc(a,b)
cmmdc_loop:
	cmp ecx, edx
	jae no_swap
swap:				; daca a < b, interschimbam valorile
	push ecx
	push edx
	pop ecx
	pop edx
no_swap:
	sub ecx, edx	; a = a-b

	cmp edx, 0
	jne cmmdc_loop
end_loop:

				; calculam acum cmmmc(a,b)
	pop eax		; a
	pop edx		; b
	mul edx		; 
	div ecx		; cmmmc(a,b) = a*b/cmmdc(a,b)

	pop ecx 	; luam adresa de retur si o punem inapoi la locul ei
	push edx	; dupa cei 2 parametrii ai functiei
	push eax
	push ecx


	ret 
