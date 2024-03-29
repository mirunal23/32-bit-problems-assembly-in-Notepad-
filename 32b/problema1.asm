bits 32
global start        

extern exit, scanf, printf
import exit msvcrt.dll
import printf msvcrt.dll 
import scanf msvcrt.dll
 

section data use32 class=data
    a dd 0
    b dd 0
    formatcitit db '%c', 0
    formatcitit1 db '%s', 0
    format1 db 'Introduceti primul caracter: ', 0
    format2 db 10, 13, 'Introduceti al doilea caracter: ', 0
    format3 db 10, 13, 'Primul caracter in ordine alfabetica este: %c', 0
    formatScr db 'Caracterul introdus a fost: %c ', 0
    eroare db 10,13, 'Nu ati introdus o litera sau nu este o litera mare!', 0

section code use32 class=code
start:

    ; Citire primul caracter
    push dword format1
    call [printf]
    add esp, 4 * 1

    push dword a
    push dword formatcitit
    call [scanf]
    add esp, 4 * 2
    
    ; Afiseaza caracterul citit
    push dword [a]
    push dword formatScr
    call [printf]
    add esp, 4*2
    
    mov eax , dword [a]
    cmp eax, 'A'
    jl er
    cmp eax, 'Z'
    jg er
    jmp citire
    
er:
    push dword eroare
    call [printf]
    add esp, 4 * 1
    jmp iesi
  

citire:  
    ; Citire al doilea caracter
    push dword format2
    call [printf]
    add esp, 4 * 1

    push dword b    
    push dword formatcitit1
    call [scanf]
    add esp, 4 * 2
    
    ; Afiseaza caracterul citit
    push dword [b]
    push dword formatScr
    call [printf]
    add esp, 4*2
    
    mov ebx, dword [b]
    cmp ebx, 'A'
    jl er
    cmp ebx, 'Z'
    jg er

    mov eax, dword [a]
    mov ebx, dword [b]
    cmp eax, ebx
    jl caract1 ; a<b
    jge caract2 ; a>b
    
    
caract1:
    ; Afișare rezultat când primul caracter este mai mic
    push eax   
    push dword [a]
    push dword format3
    call [printf]
    add esp, 4 * 2
    jmp iesi


caract2:
    ; Afișare rezultat când al doilea caracter este mai mic
    push ebx
    push dword [b]
    push dword format3
    call [printf]
    add esp, 4 * 2

    
iesi:
    push dword 0
    call [exit]
     