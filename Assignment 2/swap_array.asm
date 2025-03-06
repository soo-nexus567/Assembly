global swap_array
segment .data
    format_string db "%s", 0
    prompt_tryagain db "Invalid Input", 10, 0

segment .bss
    align 64
    storedata resb 832
segment .text
    global swap_array
swap_array:
    ; Save the base pointer
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

    mov r15, rdi
    mov r14, rsi
begin:
    movsd xmm0, [r15]
    movsd xmm1, [r14]
    movsd [r15], xmm1
    movsd [r14], xmm0
     ; Restore the general purpose registers
exit:
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
    ret
