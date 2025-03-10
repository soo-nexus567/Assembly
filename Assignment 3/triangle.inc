

array_line1 db 10, "This program is brought to you as a courtesy of", 10, "Author: Jonathan Soo", 10, "CWID: 884776980", 10, "Email: jonathansoo07@csu.fullerton.edu", 10, 10,  0
%macro back_register 0    ;ar = activation record
    push    rbp
    mov     rbp, rsp

    ; Save the general purpose registers
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi
    push    r8 
    push    r9 
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    pushf
%endmacro
%macro backup_compnents 1
;This macro backs up all registers except GPRs to an array specified in parameter %1
   mov rax,7
   mov rdx,0
   xsave [%1]
%endmacro
%macro restore_components 1
   mov rax,7
   mov rdx,0
   xrstor [%1]
%endmacro
%macro print_info 0
    mov rax, 0
    mov rdi, array_line1
    call printf
%endmacro
%macro restore_registers 0
    popf          
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9 
    pop     r8 
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx

    ; Restore the base pointer
    pop     rbp
%endmacro