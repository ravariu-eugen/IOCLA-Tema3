section .text
global expression
global term
global factor
; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> string length
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, [ebp + 8]      ; p
        mov ecx, [ebp + 12]     ; &i

        add ebx, [ecx]
        dec ebx         ; p+strlen(p)-1 ; adresa ultimului caracter din sir
        push ebx
        mov ebx, [ebp + 8]      ; p
        push ebx
        call find_mult_div      ; verificam daca sirul contine o operatie 
        cmp eax, 0              ; care nu este intre paranteze
        jne is_not_number       ; daca da evaluam direct expresia
        call find_plus_minus    ;
        cmp eax, 0
        jne is_not_number
        add esp, 8
number:
        cmp byte[ebx], '('              ; daca sirul incepe cu o paranteza
        je expression_in_paranthesis    ; evaluam expresia dintre paranteze
        xor eax, eax
        mov ecx, [ecx]          ; altfel, insemna ca avem de evaluat un numar     
loop_number:                    ; calculam valoarea numarului
        mov edx ,10
        mul edx
        xor edx, edx
        mov dl, byte[ebx]
        sub dl, '0'
        add eax, edx
        inc ebx
        loop loop_number
        jmp end_factor
is_not_number:
        add esp, 8
        push dword[ebp + 12]     ; &i
        push dword[ebp + 8]      ; p
        call expression ; evaluam expresia 
        add esp, 8      
        jmp end_factor

expression_in_paranthesis:
        inc ebx
        sub dword[ecx], 2
        push dword[ebp + 12]     ; &i
        push ebx
        call expression ; evaluam expresia dintre paranteze
        add esp, 8
        add dword[ecx], 2
end_factor:
        pop edx
        pop ecx
        pop ebx
        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> string length
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, [ebp + 8]      ; p
        mov ecx, [ebp + 12]     ; &i

        add ebx, [ecx]
        dec ebx              ; p + strlen(p) - 1 ; adresa ultimului caracter
        push ebx
        mov ebx, [ebp + 8]   ; p
        push ebx
        call find_plus_minus ; verificam daca sirul contine un semn de + sau -
        add esp, 8              
        cmp eax, 0
        jne one_factor       ; daca da, il vom evalua cu factor
        sub esp, 8
        call find_mult_div   ; verificam daca sirul contine un semn de * sau /
        add esp, 8
        cmp eax, 0
        je one_factor        ; daca nu, il vom evalua cu factor

two_factors:                 ; daca da, inseamna ca avem 2 factori
        mov esi, [ecx]       ; lungime expresie
        mov edi, eax         ; pozitie * sau /
        push dword[ebp + 12] ; &i

        mov [ecx], ebx  
        add [ecx], esi
        inc edi              ; inceputul celui de-al doilea termen
        sub [ecx], edi       ; lungimea celui de-al doilea termen
        push edi
        call factor          ; valoarea celui de-al doilea termen
        add esp, 4
        dec edi
        mov edx, eax         ; valoarea celui de-al doilea termen


        mov [ecx], edi  
        sub [ecx], ebx       ; lungimea primului termen   
        
        push dword[ebp + 8]  ; p
        call factor          ; valoarea primului termen
        add esp, 8

        cmp byte[edi], '*'
        jne impartire        ; verificam daca facem inmultire sau impartire
inmultire:        
        mul edx
        jmp end_term
impartire:
        xchg ecx, edx
        push edx
        xor edx, edx
        idiv ecx
        pop edx
        xchg ecx, edx
        jmp end_term
one_factor:
        push dword[ebp + 12] ; &i
        push dword[ebp + 8]  ; p
        call factor
        add esp, 8
end_term:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> string length
; @returns:
;	the result of the parsed expression
expression:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, [ebp + 8]      ; p
        mov ecx, [ebp + 12]     ; &i

        cmp dword[ecx], 0         
        jne string_length_present
find_string_length:   ; daca i == 0, calculam lungimea sirului si o scriem la i
        push ebx      ; acest lucru se intampla numai pentru apelarea functiei 
        call str_len  ; din main 
        add esp, 4
        mov [ecx], eax
string_length_present:
        add ebx, [ecx]
        dec ebx              ; p+strlen(p)-1 ;adresa ultimului caracter din sir
        push ebx
        mov ebx, [ebp + 8]   ; p
        push ebx
        call find_plus_minus ; cautam ultimul semn de plus sau minus
        add esp, 8
        cmp eax, 0
        je one_term     ; daca nu il gasim, inseamna ca avem un singur termen

two_terms:
        mov esi, [ecx]  ; lungime expresie
        mov edi, eax    ; pozitie plus/minus
        push dword[ebp + 12] ; &i

        mov [ecx], ebx  
        add [ecx], esi
        inc edi         ; inceputul celui de-al doilea termen
        sub [ecx], edi  ; lungimea celui de-al doilea termen
        push edi
        call term       ; valoarea celui de-al doilea termen
        add esp, 4
        dec edi
        mov edx, eax    ; valoarea celui de-al doilea termen


        mov [ecx], edi  
        sub [ecx], ebx  ; lungimea primului termen   
        
        push dword[ebp + 8]  ; p
        call term       ; valoarea primului termen
        add esp, 8
        
        
        mov [ecx], esi  ; restaturare lungime expresie
        cmp byte[edi], '-' 
        jne adunare     ; verificam daca facem adunare sau scadere
scadere:        
        sub eax, edx
        jmp end_expression
adunare:
        add eax, edx
        jmp end_expression
one_term:
        push dword[ebp + 12] ; &i
        push dword[ebp + 8]  ; p
        call term
        add esp, 8
end_expression:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        leave
        ret
;; int str_len(char *string)
; lungimea sirului terminat cu null
str_len:
        enter 0,0
        push ebx
        mov ebx, [ebp + 8] ; string
        mov eax, [ebp + 8] ; string
len_loop:
        cmp byte[eax], 0
        je end_str_len
        inc eax
        jmp len_loop
end_str_len:
        sub eax, ebx
        pop ebx
        leave 
        ret

;; char *find_plus_minus(char *start, char *end)
; gaseste ultima aparitie a unui semn de plus sau minus 
; in sirul de caractere [start, end]
; care nu se afla intre paranteze
find_plus_minus:
        enter 0,0
        push ebx
        push dword[ebp + 12] ; end
        push dword[ebp + 8]  ; start
        push dword '+'
        call find_last_chr
        mov ebx, eax
        add esp, 4
        push dword '-'
        call find_last_chr
        add esp, 12
        cmp eax, ebx
        ja end_find_plus_minus
        mov eax, ebx
end_find_plus_minus:
        pop ebx
        leave
        ret

;; char *find_mult_div(char *start, char *end)
; gaseste ultima aparitie a unui semn de inmultit sau impartit 
; in sirul de carcatere [start, end]
; care nu se afla intre paranteze
find_mult_div:
        enter 0,0
        push ebx
        push dword[ebp + 12] ; end
        push dword[ebp + 8]  ; start
        push dword '*'
        call find_last_chr
        mov ebx, eax
        add esp, 4
        push dword '/'
        call find_last_chr
        add esp, 12
        cmp eax, ebx
        ja end_find_mult_div
        mov eax, ebx
end_find_mult_div:
        pop ebx
        leave
        ret

;; char *find_chr(char c, char *start, char *end)
; intoarce adresa ultimei aparitii a caracterului c in sirul [start, end] 
; care nu se afla intre paranteze
find_last_chr:
        enter 0,0
        push esi
        push edi
        push ebx
        mov bl, byte[ebp + 8]   ; c
        mov esi, [ebp + 16]     ; end
                                ; parcurgem sirul de la dreapta la stanga
        xor eax, eax
        xor edi, edi            ; contor paranteze
find_loop:                      
        cmp esi, [ebp + 12]     ; start
        jb end_find_last_chr    ; daca ajungem la stanga de start, inseamna ca 
                                ; am parcurs tot sirul

        cmp byte[esi], ')'      
        jne skip1
        inc edi                 ; incrementam pentru o paranteza inchisa
        jmp not_found           ; daca caracterul este o paranteza, nu poate
                                ; fi caracterul dorit
skip1:
        cmp byte[esi], '('      
        jne skip2
        dec edi                 ; decrementam pentru o paranteza deschisa
        jmp not_found           ; daca caracterul este o paranteza, nu poate
                                ; fi caracterul dorit
skip2:
        cmp edi, 0              ; daca contorul este nenul, inseamna ca 
        jne not_found           ; ne aflam intre paranteze
        cmp byte[esi], bl
        jne not_found
found:                          ; daca am gasit caracterul
        mov eax, esi            ; il intoarcem
        jmp end_find_last_chr
not_found:
        dec esi                 ; daca nu gasim caracterul de pozitia curenta
                                ; decrementam adresa
        jmp find_loop

end_find_last_chr:
        pop ebx
        pop edi
        pop esi
        leave
        ret

