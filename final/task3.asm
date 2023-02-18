global get_words
global compare_func
global sort

extern qsort
extern strlen
extern strcmp
section .text
    

;; int compare_func(const void *a, const void *b)
;  compara stringurile a si b mai intai dupa lungime, apoi lexicografic 
compare_func:
    enter 0,0
    push ebx

    mov edx, [ebp + 12] ; &b
    push dword[edx] ; b
    call strlen     ; strlen(b)
    mov ebx, eax
    mov edx, [ebp + 8]  ; &a
    push dword[edx] ; a
    call strlen     ; strlen(a)

    sub eax, ebx    ; strlen(a) - strlen(b)
    jne end_comp    ; daca strlen(a)!=strlen(b), sortam in functie de lungime
    call strcmp     ; altfel , sortam lexicografic: strcmp(a, b)
    
end_comp:
    add esp, 8      ; restauram stiva
    pop ebx
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    mov ebx, [ebp + 8]  ; words
    mov ecx, [ebp + 12] ; number_of_words
    mov eax, [ebp + 16] ; size
    push compare_func
    push eax    ; words
    push ecx    ; number_of_words
    push ebx    ; size
    call qsort  ; void qsort (void* base, size_t num, size_t size,
                ; int (*compar)(const void*,const void*));
    add esp, 16 ; restauram stiva
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    pusha
    mov ebx, [ebp + 8]  ;   s
    mov esi, [ebp + 12] ; words  (adresa adresei primului cuvant)
    mov edi, [esi]      ; *words (adresa primului cuvant)
loop_parse:
    cmp byte[ebx], 0
    je end
    
    cmp byte[ebx], 10 ;'\n' 
    je find_next_word ; daca caracterul curent este unul dintre ' .,\n'
    cmp byte[ebx], ' '; inseamna ca cuvantul curent s-a terminat si ca incepe
    je find_next_word ; cuvantul urmator
    cmp byte[ebx], '.'
    je find_next_word
    cmp byte[ebx], ','
    je find_next_word
    jmp copy_letter



find_next_word:
    inc ebx
    cmp byte[ebx], 10 ;'\n'
    je find_next_word ; daca caracterul curent este unul dintre ' .,\n'
    cmp byte[ebx], ' '; inseamna ca mai trebuie sa cautam inceputul
    je find_next_word ; urmatorului cuvant
    cmp byte[ebx], '.'
    je find_next_word
    cmp byte[ebx], ','
    je find_next_word
    cmp byte[ebx], 0
    je end
found:
    mov byte[edi], 0    ; pune 0 la sfarsitul cuvantului curent
    add esi, 4          ; trecem la inceputul cuvantului urmator
    mov edi, [esi]
copy_letter:
    mov dl, byte[ebx]   ; copiem caracterul curent din sirul initial
    inc ebx
    mov [edi], dl       ; in cuvantul curent
    inc edi
    jmp loop_parse


end:
    popa
    leave
    ret
