section .text
	global cpu_manufact_id
	global features
	global l2_cache_info
;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	pusha

	mov esi, [ebp + 8] 		; adresa unde scriem manufacturer id string
	mov eax, 0
	cpuid
	mov dword[esi], ebx		; cele 3 parti pentru manufacturer id string
	mov dword[esi + 4], edx	; 
	mov dword[esi + 8], ecx	;

	popa
	leave
	ret


;; void features(int *vmx, int *rdrand, int *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	pusha
	mov eax, 1
	cpuid
	; 
	; vmx = bitul 5 din ecx
	mov eax, ecx
	shr eax, 5
	and eax, 1
	mov esi, [ebp + 8]	; vmx
	mov dword[esi], eax	; 
	
	; rdrand = bitul 30 din ecx
	mov eax, ecx
	shr eax, 30
	and eax, 1
	mov esi, [ebp + 12]	; rdrand
	mov dword[esi], eax	;
	; avx = bitul 28 din ecx
	mov eax, ecx
	shr eax, 28
	and eax, 1
	mov esi, [ebp + 16]	; avx
	mov dword[esi], eax	;
	popa
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	pusha
	mov eax, 0x80000006
	cpuid
	
	mov eax, ecx
	and eax, 0xff 		; bitii 0-7 - valoarea pt. cache line size
	mov esi, [ebp + 8]	; line_size
	mov dword[esi], eax ; 

	mov eax, ecx
	shr eax, 16 		; bitii 16-31 - valoarea pt. cache size pt. un nucleu 
	mov esi, [ebp + 12] ; cache_size
	mov dword[esi], eax
	popa
	leave
	ret
