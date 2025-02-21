global isfloat
    null equ 0
    true equ -1
    false equ 0

 
segment .data

segment .bss

segment .text
    global isfloat
isfloat:
    push rbp                                          ;Backup rbp
    mov  rbp,rsp                                      ;The base pointer now points to top of stack
    push rdi                                          ;Backup rdi
    push rsi                                          ;Backup rsi
    push rdx                                          ;Backup rdx
    push rcx                                          ;Backup rcx
    push r8                                           ;Backup r8
    push r9                                           ;Backup r9
    push r10                                          ;Backup r10
    push r11                                          ;Backup r11
    push r12                                          ;Backup r12
    push r13                                          ;Backup r13
    push r14                                          ;Backup r14
    push r15                                          ;Backup r15
    push rbx                                          ;Backup rbx
    pushf     

    mov r13, rdi
    xor r14, r14

continue_validation:

loop_before_point:
    mov rax, 0
    xor rdi, rdi
    mov dil, byte [r13+1 *r14]
    call is_digit
    cmp rax, false
    je is_it_radix_point
    inc r14
    jmp loop_before_point
is_it_radix_point:
    cmp byte[r13 +1*r14], '.'
    jne return_false
start_loop_after_finding_a_point:
    inc r14
    mov rax, 0
    mov rdi, rdi
    mov dil, byte[r13+1*r14]
    call is_digit
    cmp rax, false
    jne start_loop_after_finding_a_point

    cmp byte [r13+1+r14], null
    jne return_false
    mov rax, true
    jmp restore_gpr_registers

return_false:
    mov rax, false
restore_gpr_registers:
    popf                                    ;Restore rflags
    pop rbx                                 ;Restore rbx
    pop r15                                 ;Restore r15
    pop r14                                 ;Restore r14
    pop r13                                 ;Restore r13
    pop r12                                 ;Restore r12
    pop r11                                 ;Restore r11
    pop r10                                 ;Restore r10
    pop r9                                  ;Restore r9
    pop r8                                  ;Restore r8
    pop rcx                                 ;Restore rcx
    pop rdx                                 ;Restore rdx
    pop rsi                                 ;Restore rsi
    pop rdi                                 ;Restore rdi
    pop rbp                                 ;Restore rbp

    ret                                     ;Pop the integer stack and jump to the address represented by the popped value.                                        ;Backup rflags









global is_digit:
    true equ -1
    false equ 0
    ascii_value_of_zero equ 0x30
    ascii_value_of_nine equ 0x39

    segment .data
        ;hellol
    segment .bss
        ;hello
    segment .text
    is_digit:
        push rbp                                          ;Backup rbp
        mov  rbp,rsp                                      ;The base pointer now points to top of stack
        push rdi                                          ;Backup rdi
        push rsi                                          ;Backup rsi
        push rdx                                          ;Backup rdx
        push rcx                                          ;Backup rcx
        push r8                                           ;Backup r8
        push r9                                           ;Backup r9
        push r10                                          ;Backup r10
        push r11                                          ;Backup r11
        push r12                                          ;Backup r12
        push r13                                          ;Backup r13
        push r14                                          ;Backup r14
        push r15                                          ;Backup r15
        push rbx                                          ;Backup rbx
        pushf                                             ;Backup rflags
        mov r13, 0
        mov r13b, dil

        cmp r13, ascii_value_of_zero
        jl is_digit.return_false

        cmp r13, ascii_value_of_nine
        jg is_digit.return_false

        xor rax, rax
        mov rax, true
        jmp is_digit.restore_gpr_regise.ters
    is_digit.return_false:
        xor rax, rax
        mov rax, false
    is_digit.restore_gpr_registers:
        ;Restore all general purpose registers to their original values
        popf                                    ;Restore rflags
        pop rbx                                 ;Restore rbx
        pop r15                                 ;Restore r15
        pop r14                                 ;Restore r14
        pop r13                                 ;Restore r13
        pop r12                                 ;Restore r12
        pop r11                                 ;Restore r11
        pop r10                                 ;Restore r10
        pop r9                                  ;Restore r9
        pop r8                                  ;Restore r8
        pop rcx                                 ;Restore rcx
        pop rdx                                 ;Restore rdx
        pop rsi                                 ;Restore rsi
        pop rdi                                 ;Restore rdi
        pop rbp                                 ;Restore rbp

        ret                                     ;Pop the integer stack and jump to the address represented by the popped value.
                    
                    