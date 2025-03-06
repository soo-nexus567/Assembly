%ifndef TRIANGLE_INC
#define TRIANGLE_INC
global triangle
    extern printf
section .data
    array_line1 db "This program is brought to you as a courtesy of", 10, "Author: Jonathan Soo", 10, "CWID: 884776980", 10, "Email: jonathansoo07@csu.fullerton.edu", 10
%macro back_up_register 0
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
%macro print_info 0
    mov rax, 0
    mov rdi, array_line1
    call printf
%endmacro
%macro restore_register 0
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
%endmacro