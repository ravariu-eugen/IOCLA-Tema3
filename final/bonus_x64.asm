section .text
	global intertwine
extern printf
;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	push rbx
	xor eax, eax	; contor pt. v1, v2
	; rdi = v1
	; esi = n1
	; rdx = v2
	; ecx = n2;
	; r8 = v


inter_loop:
	cmp eax, esi 	; n1 
	je 	fill2_loop
	cmp eax, ecx	; n2
	je 	fill1_loop
	mov ebx, [rdi] 	; citim valoarea din v1
	add rdi, 4		; trecem v1 la valoarea urmatoare
	mov [r8], ebx	; scriem valoarea in v
	add r8, 4		; trecem v la valoarea urmatoare
	mov ebx, [rdx]	; citim valoarea din v2
	add rdx, 4		; trecem v2 la valoarea urmatoare
	mov [r8], ebx	; scriem valoarea in v
	add r8, 4		; trecem v la valoarea urmatoare
	inc eax	
	jmp inter_loop


fill1_loop:			; punem restul valorilor din v1 in v
	cmp eax, esi 	; n1 
	je 	end
	mov ebx, [rdi]	; citim valoarea din v1
	add rdi, 4		; trecem v1 la valoarea urmatoare
	mov [r8], ebx	; scriem valoarea in v
	add r8, 4		; trecem v la valoarea urmatoare
	inc eax
	jmp fill1_loop
fill2_loop:			; punem restul valorilor din v2 in v
	cmp eax, ecx	; n2
	je 	end
	mov ebx, [rdx]	; citim valoarea din v2
	add rdx, 4		; trecem v2 la valoarea urmatoare
	mov [r8], ebx	; scriem valoarea in v
	add r8, 4		; trecem v la valoarea urmatoare
	inc eax
	jmp fill2_loop
end:
	pop rbx
	leave
	ret
