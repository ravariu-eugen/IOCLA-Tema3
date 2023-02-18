

section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };
struc node
	val: resd 1
	next: resd 1
endstruc

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	push ebx
	mov ebx, [ebp + 8] 	; n
	dec ebx				; n-1
	shl ebx, 3 			; 8*n - 8
	add ebx, [ebp + 12] ; node + 8*n - 8; ultimul nod din vector
find_first_loop:	; cautam primul nod
	cmp dword[ebx], 1 	; verificam daca nodul de la adresa ebx este cel de la
	je found_first		; inceput (are valoarea 1)

	sub ebx, 8			; trecem la nodul urmator
	jmp find_first_loop	; putem face un salt necondionat pt. ca avem garantia 
						; ca vom gasi un nod cu valoarea data
found_first:
	mov eax, ebx 		; nodul de la inceputul listei

	mov edx, ebx		; ultimul nod din lista
	mov ecx, 2			; contor pentru valoarea nodului cautat
make_list_loop:
	mov ebx, [ebp + 8]	; n
	dec ebx				; n-1
	shl ebx, 3 			; 8*n - 8
	add ebx, [ebp + 12] ; node + 8*n - 8; ultimul nod din vector
find_next_loop:		; cautam urmatorul nod
	cmp dword[ebx], ecx	; verificam daca nodul curent este cel cautat
	je	found_next		;

	sub ebx, 8			; trecem la nodul urmator
	jmp find_next_loop	; putem face un salt necondionat pt. ca avem garantia 
						; ca vom gasi un nod cu valoarea data
found_next:			

	mov [edx+next], ebx ; legam nodul curent la ultimul nod
	mov edx, ebx 		; actualizam ultimul nodul
	inc ecx				; incrementam valoarea cautata
	cmp ecx, [ebp + 8]	; cat timp valoarea lui ecx e mai mica sau egala cu n
	jbe make_list_loop	; putem gasi nodul urmator


	pop ebx
	leave
	ret
