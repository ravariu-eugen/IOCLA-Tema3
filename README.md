Task 1:
    struct node* sort(int n, struct node* node)
        Mai intai, gasim nodul cu valoarea 1 si il marcam ca inceputul listei.
    Apoi, pentru fiecare valoare de la 2 la n, gasim nodul cu acea valoarea si
    il punem la sfarxitul listei. La final, intoarcem inceputul listei
Task 2:
    int cmmmc(int a, int b)
        Pentru a calcula cel mai mic multiplu comun, folosim formula:
        cmmmc(a,b) = a * b / cmmdc(a,b)
        Calculam cel mai mare divizor comun folosind algoritmul lui Euclid, insa
    folosim scaderi repetate in loc de operatia de modul
        while(b!=0){
            if(a<b)
                swap(a,b);
            a = a - b;
        }

        Pentru a extrage parametrii folosind numai operatii de push si pop,
    extragem mai intai adresa de retur intr-un registru, extragem cei doi 
    parametrii si punem adresa inapoi pe stiva. La final, extragem din nou 
    adresa de retur, alocam 8 octeti pe stiva(locul unde ar fi fost initial
    parametrii) si punem inapoi adresa de retur
Task 3:
    int compare_func(const void *a, const void *b)
        Comparam mai intai lungimea sirurilor. Daca au lungimi diferite, 
    intoarcem strlen(a) - strlen(b). Altfel, le comparam lexicografic folosind
    strcmp; intoarcem strcmp(a,b).
    sort(char **words, int number_of_words, int size)
        Soratam vectorul de siruri de caractere folosind qsort si compare_func
Task 4:
        Cele trei functii ce urmeaza evalueaza expresii date de sirul p,
    cu lungimea memorata la adresa i 
    int expression(char *p, int *i)
        Daca expresia contine un + sau un - ce nu este intre paranteze, 
    evaluam cei doi termeni: primul de la p pana la stanga ultimului semn + 
    sau - ce nu este intre paranteze, al doilea de la dreapta ultimului semn 
    pana la sfarsit, folosind functia term. Dupa aceea, efectuam operatia de 
    adunare sau scadere
        Daca expresia nu contine + sau -, evaluam expresia folosind 
    functia term
    int term(char *p, int *i)
        Daca expresia contine un + sau un -, evaluam expresia folosind functia
    factor.
        Daca expresia contine un * sau un /, evaluam cei doi termeni: 
    primul de la p pana la stanga ultimului semn * sau /, al doilea de la 
    dreapta ultimului semn pana la sfarsit, folosind functia factor. Dupa aceea,
    efectuam operatia de inmultire sau impartire
        
    int factor(char *p, int *i)
        Daca expresia contine un semn(+,-,*,/) care nu este intre paranteze, o
    evaluam folosind expression.
        Daca expresia nu contine un semn care nu este intre paranteze, inseama
    ca fie reprezinta un numar sau expresie intre paranteze. Daca incepe cu o 
    paranteza, evaluam expresia dintre paranteze folosind expression. Altfel, 
    calculam numarul reprezentat de sirul p.

Bonus 64bit:
    void intertwine(int *v1, int n1, int *v2, int n2, int *v)
        Functia inercaleaza vectorii v1 si v2 in vectorul v.
Bonus CPUID:
    void cpu_manufact_id(char *id_string)
        Scrie string-ul de manufacturer id in id_string.
    void features(int *vmx, int *rdrand, int *avx)
        Seteaza valorile vmx, rdrand si avx la 1 daca au suport la nivel de 
    procesor si 0 altfel.
    void l2_cache_info(int *line_size, int *cache_size)
        Intoarce, prin line_size si cache_size, dimensiunea in bytes a unei 
    linii de cache L2, respectiv dimensiunea cache-ului L2 pentru un nucleu
Bonus AT&T:
    void add_vect(int *v1, int *v2, int n, int *v)
        Aduna cate un element din v1 cu elementul de la acelasi index in v2 si
    pune suma in v la indexul elementului. Apoi, aduna 3 valori la anumite 
    poziti din v.
Bonus Vectorial:
    In rezolvare am folosit instructiuni AVX2
    void vectorial_ops(int s, int A[], int B[], int C[], int n, int D[])
        Mai intai, creeaza un vector S de 8 valori int, fiecare pozitie avand 
    valoarea s. Apoi, pentru fiecare grupare de 8 valori din A, B, C, scriem in
    D vectorul rezultat din operatia S * A + B * C    