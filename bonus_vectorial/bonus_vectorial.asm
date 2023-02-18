section .text
	global vectorial_ops

;; void vectorial_ops(int s, int A[], int B[], int C[], int n, int D[])
;  
;  Compute the result of s * A + B .* C, and store it in D. n is the size of
;  A, B, C and D. n is a multiple of 16. The result of any multiplication will
;  fit in 32 bits. Use MMX, SSE or AVX instructions for this task.

vectorial_ops: ; pentru rezolvare am folosit intructiuni AVX2
	push		rbp
	mov		rbp, rsp
	; rdi = s
	; rsi = A
	; rdx = B
	; rcx = C
	; r8 = n
	; r9 = D
	push rdi	; punem scalarul temporar in memorie pt. a realiza 
				; operatia de broadcast
	VPBROADCASTD ymm4, dword[rsp] ; pune in vector scalarul in cele 8 pozitii
	add rsp, 8
sum_loop:
	VMOVDQU ymm0, [rsi]	; citim 8 valori din memorie in registru
	add rsi, 32 ; 8*sizeof(int) = 32 
	VPMULLD ymm0, ymm0, ymm4 ; inmultim vectorul cu scalarul  
	VMOVDQU ymm1, [rdx] ; citim 8 valori din memorie in registru
	add rdx, 32 ; 8*sizeof(int) = 32 
	VMOVDQU ymm2, [rcx] ; citim 8 valori din memorie in registru
	add rcx, 32 ; 8*sizeof(int) = 32 
	VPMULLD ymm1, ymm1, ymm2 ; inmultim cei 2 vectori
	VPADDD 	ymm0, ymm0, ymm1 ; adunam cei 2 vectori obtinuti
	VMOVDQU [r9], ymm0 ; scriem valoarea registrului in memorie
	add r9, 32 	; 8*sizeof(int) = 32 
	sub r8, 8	; scadem cu numarul de elemente inserate
	jnz sum_loop
	leave
	ret
