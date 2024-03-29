bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll
 

segment data use32 class=data
    sir times 20 db 0
    sir_afisare times 20 db 0  ; Adăugăm o nouă secțiune de date pentru a stoca șirul afișat
    formatCit db '%s', 0
    mesaj db 'Introduceti un sir de caractere (minim 10, maxim 20):', 0
    mesaj_mai_putin db 'EROARE: Ati introdus mai putin de 10 caractere!', 0
    mesaj_impar db 10,13, 'EROARE: Ati introdus un numar impar de caractere intre 10 si 20!', 0
    mesaj_corect db 10,13,'COD CORECT! Ati introdus un numar par de caractere intre 10 si 20!', 0
    mesaj_eroare db 10,13,'EROARE: Ati introdus mai mult de 20 de caractere!', 0
    mesaj_sir db 10,13,'Sirul introdus este: %s', 0
    mesaj_colorat db 10,13,'Doriti sa afisati sirul colorat? (colorat - c, necolorat - n): ', 0
    mesaj_colorat_eroare db 10,13,'EROARE: Raspuns invalid! Introduceti!', 0
    culoare_verde db 0x80



segment code use32 class=code
start:
    ; afiseaza mesaj introductiv
    push dword mesaj
    call [printf]
    add esp, 4*1

    mov ESI, 0
    
    ; citeste un sir de la tastatura
    lea eax, [sir]
    push eax
    push dword formatCit
    call [scanf]
    add esp, 4*2

    ; calculate string length
    mov ecx, 0
calc_length:
    cmp byte [sir + ecx], 0
    je  ver
    inc ecx
    cmp ecx, 20
    jge lungime
    jmp calc_length

ver:
    cmp ecx, 10
    jl nesuf
    
    test ecx, 1                
    jnz impar    

    jmp bun

lungime:
    ; Mesaj pentru sirul cu lungime incorecta
    push dword sir
    push dword mesaj_eroare
    call [printf]
    add esp, 4*2
    jmp pa
    
impar:
    push dword sir
    push dword mesaj_impar
    call [printf]
    add esp, 4*2
    jmp pa
    
bun:
    ; Afiseaza mesaj pentru cazul corect
    push dword sir
    push dword mesaj_corect
    call [printf]
    add esp, 4*2

msg:
    ; Întreabă utilizatorul dacă dorește afișarea colorată
    push dword mesaj_colorat
    call [printf]
    add esp, 4*1
    mov ecx, 0
    
copy_sir:
    mov al, [sir + ecx]
    mov [sir_afisare + ecx], al
    inc ecx
    cmp al, 0
    jnz copy_sir

    ; Citeste raspunsul
    lea eax, [sir]
    push eax
    push dword formatCit
    call [scanf]
    add esp, 4*2
    
    
    ; Verifica raspunsul
    cmp byte [sir], 'c'
    je afisare_colorata
    cmp byte [sir], 'n'
    je afisare_necolorata
    
    ; Raspuns invalid
    push dword mesaj_colorat_eroare
    call [printf]
    add esp, 4*1
    jmp msg

afisare_colorata:
    ; Afișeaza intregul sir introdus cu verde
    push dword sir_afisare
    push dword culoare_verde
    push dword mesaj_sir
    call [printf]
    add esp, 4*3
    jmp pa
    
afisare_necolorata:
    push dword sir_afisare
    push dword mesaj_sir
    call [printf]
    add esp, 4*2
    jmp pa



nesuf:
    push dword sir
    push dword mesaj_mai_putin
    call [printf]
    add esp, 4*2

pa:                   
    push dword 0
    call [exit]
